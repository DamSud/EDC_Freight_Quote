(door_sizes as list) =>
let
    #"Door Size Priority Order" = {
        "30"" wide x 79""  high", 
        "30"" wide x 75""  high", 
        "29"" wide x 79""  high", 
        "29"" wide x 75""  high"}
in
    List.First(
        List.Select(
            #"Door Size Priority Order",
            each
                List.Contains(
                    door_sizes,
                    _
                )
        ),
        null
    )