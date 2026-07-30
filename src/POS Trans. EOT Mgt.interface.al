interface "LSC IPOS Trans. EOT Mgt."
{
    Access = Internal;

    procedure ShouldSendAtEndOfTransaction(PosFuncProfile: Record "LSC POS Func. Profile"; TransactionHeader: Record "LSC Transaction Header"): Boolean;
    procedure SendFromPage(Trans: Record "LSC Transaction Header");
}
