page 93000 "LSC Trans. Server Work List"
{
    ApplicationArea = All;
    Caption = 'Trans. Server Work List';
    Editable = false;
    PageType = List;
    SourceTable = "LSC Trans. Server Work Table";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Store No."; Rec."Store No.")
                {
                }
                field("POS Terminal No."; Rec."POS Terminal No.")
                {
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                }
                field(Table; Rec.Table)
                {
                }
                field(Key1; Rec.Key1)
                {
                }
                field(Key2; Rec.Key2)
                {
                }
                field(Code1; Rec.Code1)
                {
                }
                field(Code2; Rec.Code2)
                {
                }
                field(Bool1; Rec.Bool1)
                {
                }
                field(Bool2; Rec.Bool2)
                {
                }
                field(Int1; Rec.Int1)
                {
                }
                field(Int2; Rec.Int2)
                {
                }
                field("Web Request ID"; Rec."Web Request ID")
                {
                }
                field("Web Error Message"; Rec."Web Error Message")
                {
                }
                field("Created by Store No."; Rec."Created by Store No.")
                {
                }
                field("Created by POS Terminal No."; Rec."Created by POS Terminal No.")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }

    views
    {
        view(TransactionHeaders)
        {
            Caption = 'Transactions';
            OrderBy = ascending("Table", Key1, Key2, "Store No.", "POS Terminal No.", "Transaction No.");
            Filters = where("Table" = const(Database::"LSC Transaction Header"));
        }
        view(DataEntries)
        {
            Caption = 'Data Entries';
            OrderBy = ascending("Table", Key1, Key2, "Store No.", "POS Terminal No.", "Transaction No.");
            Filters = where("Table" = const(Database::"LSC POS Data Entry"));
        }
        view(VoucherEntries)
        {
            Caption = 'Voucher Entries';
            OrderBy = ascending("Table", Key1, Key2, "Store No.", "POS Terminal No.", "Transaction No.");
            Filters = where("Table" = const(Database::"LSC Voucher Entries"));
        }
    }
}
