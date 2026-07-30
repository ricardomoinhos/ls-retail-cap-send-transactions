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

    procedure SendFromPage(TransHeader: Record "LSC Transaction Header")
    var
        POSTransServerUtility: Codeunit "LSC POS Trans. Server Utility";
        POSSession: Codeunit "LSC POS Session";
    begin
        TransHeader.TestField("Store No.");
        TransHeader.TestField("POS Terminal No.");

        POSSession.Init();
        POSSession.SetStore(TransHeader."Store No.");
        POSSession.SetTerminal(TransHeader."POS Terminal No.");

        if TransHeader.Replicated then
            if not Confirm(ReplicatedConfirmQst, false, Format(TransHeader."Transaction No."), TransHeader."Store No.", TransHeader."POS Terminal No.") then
                exit;

        if not ShouldSendAtEndOfTransaction(POSSession.FunctionalityProfile(), TransHeader) then
            Error(NoRequirementsErr);
        POSTransServerUtility.SendAtEndOfTransaction(TransHeader);
        Message(TransAddedToWorkTableMsg);
    end;

    var
        ReplicatedConfirmQst: Label 'Transaction No. %1 in Store No. %2, POS Terminal No. %3 is marked as already replicated. Do you want to continue?', Comment = '%1 = Transaction No., %2 = Store No., %3 = POS Terminal No.';
        NoRequirementsErr: Label 'The posted transaction does not fill the requirements to be sent at the end of the transaction.';
        TransAddedToWorkTableMsg: Label 'The transaction should have been placed in the Trans. Work Server Table to be sent to Head Office.';
}
