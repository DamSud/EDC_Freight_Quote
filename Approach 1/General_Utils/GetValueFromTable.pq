(table as text, row as number, columnName as text) as any =>
let
    Source = Excel.CurrentWorkbook(),
    
    table_obj = Source{[Name=table]}[Content],

    _value = 
        try 
            Record.Field(table_obj{row}, columnName) 
        otherwise 
            null
in
    _value