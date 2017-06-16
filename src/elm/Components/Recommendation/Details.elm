module Components.Recommendation.Details exposing (recommendationWidget)

import App exposing (Msg)
import Components.UI
    exposing
        ( Category
        , CategoryEntry
        , CategoryHeader
        , Element(..)
        , ctbl
        , CssStyle
        )
import Components.Util exposing (prettyDataSourceName)
import Html exposing (Html, div, a, text)
import Html.Attributes as Attr
import Components.API exposing (Recommendation, Source, Link)


recommendationWidget : Recommendation -> Html Msg
recommendationWidget recommendation =
    ctbl frame
        ((List.filter (\i -> not (List.isEmpty i.references)) recommendation.sources)
            |> (List.map sourceToCategoryUi)
        )


sourceToCategoryUi : Source -> Category
sourceToCategoryUi source =
    { header = [ Text (prettyDataSourceName source.name) ]
    , entries = (List.map entry source.references)
    }


entry : Link -> Element
entry lnk =
    Htm (div [] [ a [ Attr.href lnk.href ] [ text lnk.text ] ])


frame : CssStyle
frame =
    [ ( "margin", "30px" )
    , ( "margin-left", "-10px" )
    , ( "width", "50vw" )
    , ( "height", "75vh" )
    ]
