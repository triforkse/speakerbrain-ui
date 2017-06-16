module Components.Util exposing (..)


prettyDataSourceName : String -> String
prettyDataSourceName name =
    case name of
        "lanyrd" ->
            "Lanyrd"

        "youtube" ->
            "YouTube"

        "twitter" ->
            "Twitter"

        "github" ->
            "GitHub"

        _ ->
            name
