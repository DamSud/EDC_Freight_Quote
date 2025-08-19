let
    index = 0,

    tableText = GetValueFromTable("BuildItemTable", index, "Quote Details"),

    CratesQunatity = ExtractCratesQuantity(tableText),

    ListeResShelving = ExtractShelvingSummary(tableText),

    ResPassthrough = ExtractPassthroughQuantity(tableText),

    ResDoorSize = ExtractDoorSize(tableText),

    BiggestDoorSize = GetBiggestDoorSize(ResDoorSize)
in
    ResDoorSize