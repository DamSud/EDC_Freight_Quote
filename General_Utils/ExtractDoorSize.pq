(quote_details as text) =>
let
    // cleaning quote details
    cleanedCR = Text.Replace(quote_details, "#(cr)", " "),
    cleanedTAB = Text.Replace(cleanedCR, "#(tab)", " "),

    // standardize token
    std_size = Text.Replace(cleanedTAB, "Size", "size"),

    // separate blocs
    blocs = Text.Split(std_size, "#(lf)#(lf)"),

    #"Door Size by Blocs" = List.Transform(
        blocs,
        each 
            if Text.Contains(_, "size") then 
                Text.Trim(Text.Combine({Text.BetweenDelimiters(_, "size:", "high"), " high"}))
            else 
                null
    ),

    #"filter nulls" = List.Select(
        #"Door Size by Blocs",
        each _ <> null
    ),

    #"Biggest Door Size" = GetBiggestDoorSize(#"filter nulls")
in
    #"Biggest Door Size"