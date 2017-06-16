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
import Round exposing (..)
import Components.Util exposing (prettyDataSourceName)
import Html exposing (Html, div, a, text, span)
import Html.Attributes as Attr
import Html.Attributes exposing (style)
import Components.API exposing (Recommendation, Source, Link)


recommendationWidget : Recommendation -> Html Msg
recommendationWidget recommendation =
    ctbl frame
        ((List.filter (\i -> not (List.isEmpty i.references)) recommendation.sources)
            |> (List.map sourceToCategoryUi)
        )


sourceToCategoryUi : Source -> Category
sourceToCategoryUi source =
    { header = header source
    , entries = (List.map entry source.references)
    }


header : Source -> CategoryHeader
header source =
    [ Text ((prettyDataSourceName source.name))
    , Htm (span [ style header__style ] [ text (Round.round 2 source.rating) ])
    ]


header__style : List ( String, String )
header__style =
    [ ( "float", "right" ), ( "margin-right", "5px" ) ]


entry : Link -> Element
entry lnk =
    Htm (div [] [ a [ Attr.href lnk.href ] [ text lnk.text ] ])


frame : CssStyle
frame =
    [ ( "margin", "30px" )
    , ( "margin-left", "-10px" )
    , ( "width", "50vw" )
    , ( "height", "79vh" )
    , ( "overflow-y", "auto" )
    ]
