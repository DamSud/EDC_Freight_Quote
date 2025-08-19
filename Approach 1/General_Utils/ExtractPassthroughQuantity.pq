(quote_details as text) =>
let
    // cleaning quote details
    cleanedCR = Text.Replace(quote_details, "#(cr)", " "),
    cleanedTAB = Text.Replace(cleanedCR, "#(tab)", " "),

    // standardize token
    std_passthrough = Text.Replace(cleanedTAB, "Passthrough", "passthrough"),

    // separate blocs
    blocs = Text.Split(std_passthrough, "#(lf)#(lf)"),

    bloc_crates_list_qtt_when_passthrough = List.Transform(
        blocs,
        each 
            if Text.Contains(_, "passthrough") then 
                ExtractCratesQuantity(_)
            else
                0
    ),

    sum_passthrough_doors = List.Sum(bloc_crates_list_qtt_when_passthrough)
in
    sum_passthrough_doors