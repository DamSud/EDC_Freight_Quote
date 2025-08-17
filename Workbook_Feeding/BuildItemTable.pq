let
    quotes_table = Excel.CurrentWorkbook(){[Name="BuildQuoteTable"]}[Content],
    #"Removing Useless Columns" = Table.SelectColumns(quotes_table, {"quote_number"}),

    #"Receiving API Result" = Table.AddColumn(
        #"Removing Useless Columns", 
        "Quote Details", 
        each 
            GetItems(Text.From(_[quote_number]))
    ),
    
    #"Crates Quantity Columns" = Table.AddColumn(
        #"Receiving API Result",
        "Crates Quantities",
        each 
            ExtractCratesQuantity(_[Quote Details])
    ),

    #"Shelving Summary Column" = Table.AddColumn(
        #"Crates Quantity Columns",
        "Shelving Summary",
        each 
        let 
            combined = Text.Trim(Text.Combine(
                ExtractShelvingSummary(
                    _[Quote Details]
                ),
                ", #(lf)"
            )),

            res = 
                if 
                    Text.Length(combined) = 0 
                then
                    null
                else
                    combined

        in 
            res
    ),

    #"Passthrough Doors Quantity Column" = Table.AddColumn(
        #"Shelving Summary Column",
        "Passthrough Quantity",
        each 
            ExtractPassthroughQuantity(_[Quote Details])
    ),

    #"Door Size Column" = Table.AddColumn(
        #"Passthrough Doors Quantity Column",
        "Door Size",
        each
            ExtractDoorSize(_[Quote Details])
    )
in
    #"Door Size Column"