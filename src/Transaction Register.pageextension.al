pageextension 93001 "LSC CAP Transaction Register" extends "LSC Transaction Register"
{
    actions
    {
        addlast("T&ransaction")
        {
            action("CAP Re-send Transaction")
            {
                ApplicationArea = All;
                Caption = 'Re-send Transaction';
                ToolTip = 'Manually queues the transaction to be re-sent, adding it to the Trans. Work Server Table to be picked up by a scheduler job/background session, replicating the process that runs automatically at the end of a POS transaction (based on POS Functionality Profile settings). Use this if the transaction was not sent due to a failure or connectivity issue.';
                Image = SendConfirmation;

                trigger OnAction()
                var
                    EOTMgt: Codeunit "LSC POS Trans. EOT Mgt.";
                    SelectedTransHeader: Record "LSC Transaction Header";
                begin
                    CurrPage.SetSelectionFilter(SelectedTransHeader);
                    EOTMgt.SendFromPage(SelectedTransHeader);
                end;
            }

            action("CAP Sending Transaction Queue")
            {
                ApplicationArea = All;
                Caption = 'Open Trans. Server Work List';
                Image = Log;
                ToolTip = 'Opens the list of transactions (or other tables included) queued to be sent. Use this to monitor or troubleshoot pending transaction sends.';

                trigger OnAction()
                begin
                    Page.Run(Page::"LSC Trans. Server Work List");
                end;
            }
        }
    }

}
