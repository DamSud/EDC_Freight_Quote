(date_debut as text, date_fin as text) => 
let
    url = "https://quote.energydoorco.com",
    endpoint = "api/quote-data.php",
    api_key_value = APIKey(),
    param = [
        apikey = api_key_value,
        start = date_debut,
        end = date_fin
    ],

    Source = Json.Document(
        Web.Contents(
            url,
            [
                RelativePath = endpoint,
                Query = param
            ]
        )
    )
in
    Source