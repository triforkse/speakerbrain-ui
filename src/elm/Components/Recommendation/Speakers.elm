module Components.Recommendation.Speakers exposing (recommendedSpeakers)

import App exposing (Msg)
import Html exposing (..)
import Html.Events as E
import Html.Attributes exposing (style)
import Components.API exposing (Recommendation)
import Components.UI exposing (tbl, CssStyle, TableRow, TableColumn, Element(..))


recommendedSpeakers : List Recommendation -> Html Msg
recommendedSpeakers recommendations =
    tbl recommendation__table recommendationColumns (List.map recommendationTableRow recommendations)


recommendation__table : CssStyle
recommendation__table =
    [ ( "margin", "30px" )
    , ( "width", "50vw" )
    , ( "height", "75vh" )
    ]


recommendationColumns : List TableColumn
recommendationColumns =
    [ ( "Rating", [ ( "width", "70px" ) ] )
    , ( "Speaker", [ ( "width", "90px" ) ] )
    ]


recommendationTableRow : Recommendation -> TableRow
recommendationTableRow recommendation =
    [ (Text (toString recommendation.total))
    , (Htm (span [ style link__button ] [ a [ E.onClick (App.ShowDetails recommendation) ] [ text recommendation.name ] ]))
    ]


link__button : List ( String, String )
link__button =
    [ ( "cursor", "pointer" ) ]
