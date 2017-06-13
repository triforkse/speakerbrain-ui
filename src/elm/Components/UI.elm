module Components.UI exposing (sectionHeader, tbl)

import App exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (style)


sectionHeader : String -> Html Msg
sectionHeader name =
    div [ style section__header ] [ span [] [ text name ] ]


tbl : List ( String, String ) -> List ( String, String ) -> List (List String) -> Html Msg
tbl styling headers rows =
    div [ style styling ]
        [ tableLine
        , div [ style header ] (List.map columnHeader headers)
        , tableLine
        , tableRows headers rows
        , tableLine
        ]


tableRows : List ( String, String ) -> List (List String) -> Html Msg
tableRows headersDef rows =
    div [] (List.map (tableRow headersDef) rows)


tableRow : List ( String, String ) -> List String -> Html Msg
tableRow headersDef row =
    div [ style table__row ] (List.map2 tableRowColumn headersDef row)


tableRowColumn : ( String, String ) -> String -> Html Msg
tableRowColumn ( _, columnWidth ) value =
    span [ style (table__row__column columnWidth) ] [ text value ]


columnHeader : ( String, String ) -> Html Msg
columnHeader ( label, colWidth ) =
    div [ style (header__column colWidth) ] [ text label ]


header : List ( String, String )
header =
    [ ( "display", "flex" )
    , ( "border-left", "solid thin #DCDCDC" )
    , ( "border-right", "solid thin #DCDCDC" )
    , ( "padding", "10px" )
    , ( "padding-top", "6px" )
    , ( "padding-bottom", "6px" )
    ]


tableLine : Html Msg
tableLine =
    div [ style table__line ] []


section__header : List ( String, String )
section__header =
    [ ( "font-weight", "lighter" )
    , ( "width", "100%" )
    , ( "font-size", "14pt" )
    , ( "border-bottom", "solid 1px #A9A9A9" )
    , ( "margin-bottom", "5px" )
    ]


header__column : String -> List ( String, String )
header__column colWidth =
    [ ( "width", colWidth )
    , ( "font-size", "10pt" )
    , ( "text-transform", "uppercase" )
    , ( "color", "#4F4F4F" )
    ]


table__line : List ( String, String )
table__line =
    [ ( "padding-left", "10px" )
    , ( "padding-right", "10px" )
    , ( "border-bottom", "solid thin #DCDCDC" )
    ]


table__row : List ( String, String )
table__row =
    [ ( "display", "flex" )
    , ( "height", "30px" )
    , ( "max-height", "30px" )
    , ( "width", "100%" )
    , ( "padding-left", "10px" )
    , ( "border-left", "solid thin #DCDCDC" )
    , ( "border-right", "solid thin #DCDCDC" )
    ]


table__row__column : String -> List ( String, String )
table__row__column colWidth =
    [ ( "width", colWidth ), ( "color", "#585858" ) ]
