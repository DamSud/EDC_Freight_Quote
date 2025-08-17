let
    date_debut = Text.From(GetValueFromTable("PowerQueriesSettings", 0, "Date Debut")),
    date_fin = Text.From(GetValueFromTable("PowerQueriesSettings", 0, "Date Fin")),

    quote_list_as_records = GetDatas(date_debut, date_fin),

    #"Converted to Table" = Table.FromList(quote_list_as_records, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", 
            {
                "date", "quote_number", "contact", "customer", "salesman", "markfor", "order_number", "blank1", "blank2", "number_doors", "blank3", "total_usd", "total_cad", "username", "address", 
                "city", "state", "zipcode", "country", "sc_code"
            }, 
            {
                "date", "quote_number", "contact", "customer", "salesman", "markfor", "order_number", "blank1", "blank2", "number_doors", "blank3", "total_usd", "total_cad", "username", "address", 
                "city", "state", "zipcode", "country", "sc_code"
            }),

    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",
            {
                {"date", type date}, {"quote_number", Int64.Type}, {"contact", type text}, {"customer", type text}, {"salesman", type text}, {"markfor", type text}, {"order_number", Int64.Type}, {"blank1", type any}, {"blank2", type any}, 
                {"number_doors", Int64.Type}, {"blank3", type any}, {"total_usd", type number}, {"total_cad", type number}, {"username", type text}, {"address", type text}, {"city", type text}, {"state", type text}, {"zipcode", type text}, 
                {"country", type text}, {"sc_code", type text}
            })
in
    #"Changed Type"