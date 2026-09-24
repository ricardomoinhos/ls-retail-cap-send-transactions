codeunit 93000 "LSC POS Trans. EOT Mgt." implements "LSC IPOS Trans. EOT Mgt."
{
    Access = Internal;

    procedure ShouldSendAtEndOfTransaction(PosFuncProfile: Record "LSC POS Func. Profile"; TransactionHeader: Record "LSC Transaction Header"): Boolean
    begin
        exit(true in [
            PosFuncProfile."TS Send Transactions",
            PosFuncProfile."DD Send Transaction",
            PosFuncProfile."TS Data Entries",
            PosFuncProfile."DD Data Entry",
            TransactionHeader."Member Card No." <> ''
        ]);
    end;

    procedure SendFromPage(var Trans: Record "LSC Transaction Header")
    var
        SentCount: Integer;
        SkippedCount: Integer;
    begin
        if Trans.FindSet() then
            repeat
                ProcessTransactionFromPage(Trans, SentCount, SkippedCount);
            until Trans.Next() = 0;

        Message(BatchResultMsg, SentCount, SkippedCount);
    end;

    // Not wrapped as a TryFunction: SendAtEndOfTransaction inserts/modifies records, which a TryFunction can't do.
    local procedure ProcessTransactionFromPage(var TransHeader: Record "LSC Transaction Header"; var SentCount: Integer; var SkippedCount: Integer)
    var
        POSTransServerUtility: Codeunit "LSC POS Trans. Server Utility";
        POSSession: Codeunit "LSC POS Session";
    begin
        if TransHeader.Replicated then
            if not Confirm(ReplicatedConfirmQst, false, Format(TransHeader."Transaction No."), TransHeader."Store No.", TransHeader."POS Terminal No.") then begin
                SkippedCount += 1;
                exit;
            end;

        TransHeader.TestField("Store No.");
        TransHeader.TestField("POS Terminal No.");

        POSSession.Init();
        POSSession.SetStore(TransHeader."Store No.");
        POSSession.SetTerminal(TransHeader."POS Terminal No.");

        if not ShouldSendAtEndOfTransaction(POSSession.FunctionalityProfile(), TransHeader) then
            Error(NoRequirementsErr);
        POSTransServerUtility.SendAtEndOfTransaction(TransHeader);

        SentCount += 1;
    end;

    var
        ReplicatedConfirmQst: Label 'Transaction No. %1 in Store No. %2, POS Terminal No. %3 is marked as already replicated. Do you want to continue?', Comment = '%1 = Transaction No., %2 = Store No., %3 = POS Terminal No.';
        NoRequirementsErr: Label 'The posted transaction does not fill the requirements to be sent at the end of the transaction.';
        BatchResultMsg: Label '%1 transaction(s) placed in the Trans. Work Server Table to be sent to Head Office. %2 skipped.', Comment = '%1 = number added, %2 = number skipped';
}
