(item_ref as text) => 
let
    url = "https://quote.energydoorco.com",
    endpoint = "api/quote-items.php",
    api_key_value = APIKey(),
    param = [
        apikey = api_key_value,
        quoteid = item_ref
    ],

    result = Json.Document(
        Web.Contents(
            url,
            [
                RelativePath = endpoint,
                Query = param
            ]
        )
    )
in
    result