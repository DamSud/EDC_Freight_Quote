(quote_details as text) =>
let
    // cleaning quote details
    cleanedCR = Text.Replace(quote_details, "#(cr)", " "),
    cleanedLF = Text.Replace(cleanedCR, "#(lf)", " "),
    cleanedTAB = Text.Replace(cleanedLF, "#(tab)", " "),

    // special case
    cleanedPER_SET = Text.Replace(cleanedTAB, "PER SET ", ""),

    // splitting quote text by Shelving: (one way to do it between others)
    blocs = Text.Split(cleanedPER_SET, "Shelving:"),

    // first element is useless
    usefull_blocs = List.Skip(blocs, 1),

    // reduce bloc size to keep only essential informations
    new_delimiter = " : ",
    reduced_blocs = List.Transform(usefull_blocs, each 
        let 
            cut_after_deep = Text.Combine({Text.Split(_, "deep),"){0}, " deep"}),
            remove_parentheses = Text.Replace(cut_after_deep, " (", new_delimiter)
        in
            remove_parentheses
    ),

    // parring dimensions and quantity
    parring = List.Transform(
        if List.Count(reduced_blocs) > 0 then reduced_blocs else {""}, each 
        let 
            trimmed = Text.Trim(_),
            quantity = 
                try
                    Number.From(Text.BeforeDelimiter(trimmed, " : "))
                otherwise null,
            dimension = 
                try 
                    Text.BetweenDelimiters(trimmed, " : ", " deep")
                otherwise null
        in
            [dimension = dimension, quantity = quantity]

    ),

    // grouping quantities by summing them when they are for the same dimension
    parring_as_table = Table.FromRecords(parring),
    grouped = Table.Group(
        parring_as_table, {"dimension"}, {{"Total", each List.Sum([quantity]), type number}}
    ),

    // building final formated string
    asStrings = Table.ToRows(grouped),
    formatedOut = List.Transform(asStrings, each _{0} & " : " & Text.From(_{1}))

in
    formatedOut