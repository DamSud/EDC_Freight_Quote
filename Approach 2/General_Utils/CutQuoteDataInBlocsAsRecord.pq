(quote as text) => 
let
    #"blocs cutted by double lf" = Text.Split(quote, "#(lf)#(lf)"),
    
    #"quote number bloc" = #"blocs cutted by double lf"{0},

    #"content blocs" = List.RemoveFirstN(#"blocs cutted by double lf", 1),

    #"List of Blocs as record" = List.Transform(
        #"content blocs", 
        each 
            try let 
                #"bloc splitted by lf" = Text.Split(_, "#(lf)"),
                #"bloc lines as record" = List.Transform(
                    #"bloc splitted by lf",
                    each 
                        if Text.Contains(_, ":") then 
                            [
                                name = Text.BeforeDelimiter(_, ":"),
                                value = Text.AfterDelimiter(_, ":")
                            ]
                        else 
                            [ #"single value" = _ ]

                ),

                #"remove lines without ':'" = List.Select(
                    #"bloc lines as record", 
                    each 
                        Record.HasFields(_, "name") and Record.HasFields(_, "value")
                ),

                #"lines without ':'" = List.Select(
                    #"bloc lines as record", 
                    each
                        Record.HasFields(_, "single value")
                ),

                #"filter lines without ':'" = List.Select(
                    #"lines without ':'", 
                    each Text.Length(Text.Trim(Record.Field(_, "single value"))) <> 0
                ),

                #"bloc record" = List.Accumulate(
                    #"remove lines without ':'",
                    [],
                    (state, current) => 
                        Record.AddField(
                            state, 
                            current[name],
                            current[value]
                        )
                ),

                #"Crates Quantity line" = #"filter lines without ':'"{0},

                #"adding crates quantity line in bloc record" = Record.AddField(
                    #"bloc record", 
                    "crates quantity",
                    Record.Field(#"Crates Quantity line", "single value")
                ),

                #"remaining lines witout ':'" = List.RemoveFirstN(
                    #"filter lines without ':'",
                    1
                ),

                #"remaining lines as list of text" = List.Combine(
                    List.Transform(
                        #"remaining lines witout ':'",
                        each 
                            Record.FieldValues(_[[#"single value"]])
                    )
                    
                ),

                #"remaining separator" = " ---- ",

                #"concatenating remaining datas without ':'" = 
                    if List.Count(#"remaining lines witout ':'") > 0 then 
                        Text.Combine(
                            #"remaining lines as list of text",
                            #"remaining separator"
                        )
                    else 
                        "",

                #"adding remaining datas in bloc record" = Record.AddField(
                    #"adding crates quantity line in bloc record",
                    "remaining",
                    #"concatenating remaining datas without ':'"
                )

            in
                #"adding remaining datas in bloc record"
        otherwise null
                
    )
    
in
    #"List of Blocs as record"