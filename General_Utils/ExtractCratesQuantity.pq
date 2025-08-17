(quote_details as text) =>
let
    //// cleaning quote text
    // replacing special characteres with simple spaces
    cleanedCR = Text.Replace(quote_details, "#(cr)", " "),
    cleanedLF = Text.Replace(cleanedCR, "#(lf)", " "),
    cleanedTab = Text.Replace(cleanedLF, "#(tab)", " "),

    // replacing Sets and sets with set (easier to process but still hardcoded)
    cleanedCapSets = Text.Replace(cleanedTab, "Sets", "set"), // with capitalized S
    cleanedSets = Text.Replace(cleanedCapSets, "sets", "set"), // with s

    // processing crates qantities
    splitted_by_words = Text.Split(cleanedSets, " "),

    indexSet = List.PositionOfAny(
        splitted_by_words, 
        {"set"}, 
        Occurrence.All
    ),

    values = List.Transform(
        indexSet, 
        each 
            try 
                Number.From(splitted_by_words{_ - 1}) * Number.From(splitted_by_words{_ + 2}) 
            otherwise 0
    ),

    total = List.Sum(values)
in
    total