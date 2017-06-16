module Components.Profile.Library exposing (profileLibrary)

import App exposing (Msg)
import Dict
import Components.API exposing (Profile, ProfileData)
import Components.UI exposing (Category, CategoryEntry, CategoryHeader, CssStyle, Element(..), ctbl)
import Html exposing (Html, a, div, span, text)
import Components.Util exposing (prettyDataSourceName)
import Html.Attributes as Attr


profileLibrary : Profile -> Html Msg
profileLibrary profile =
    ctbl frame
        (Dict.toList profile.data
            |> List.filter (Tuple.second >> List.isEmpty >> not)
            |> List.map dataSourceToCategory
        )


dataSourceToCategory : ( String, List ProfileData ) -> Category
dataSourceToCategory ( datasource, data ) =
    { header = [ Text (prettyDataSourceName datasource) ]
    , entries = (List.map profileEntity data)
    }


profileEntity : ProfileData -> Element
profileEntity data =
    Htm (div [] [ a [ Attr.href data.href ] [ text data.name ] ])


frame : CssStyle
frame =
    [ ( "margin", "30px" ) ]
