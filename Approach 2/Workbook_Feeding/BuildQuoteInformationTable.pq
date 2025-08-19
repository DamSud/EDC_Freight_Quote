let
    quotes_table = Excel.CurrentWorkbook(){[Name="BuildQuoteTable"]}[Content],
    #"Removing Useless Columns" = Table.SelectColumns(quotes_table, {"quote_number"}),

    #"Receiving API Result" = Table.AddColumn(
        #"Removing Useless Columns", 
        "quote as text", 
        each 
            GetItems(Text.From(_[quote_number]))
    ),

    #"Computing Quote as records" = Table.AddColumn(
        #"Receiving API Result", 
        "quote as records", 
        each 
            CutQuoteDataInBlocsAsRecord(_[#"quote as text"])
    )
in
    #"Computing Quote as records"