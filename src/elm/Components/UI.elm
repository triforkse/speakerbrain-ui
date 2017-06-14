module Components.UI exposing (CssStyle, TableColumn, TableRow, TableCell(Text, Htm), sectionHeader, tbl, btn, dpb, nmd, txt)

import App exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Attributes as Attr


type alias CssStyle =
    List ( String, String )


type alias TableColumn =
    ( String, CssStyle )


type TableCell
    = Htm (Html Msg)
    | Text String


type alias TableRow =
    List TableCell


sectionHeader : String -> Html Msg
sectionHeader name =
    div [ style section__header ] [ span [] [ text name ] ]


txt : Html Msg
txt =
    input [ style std__input ] []


dpb : Html Msg
dpb =
    select [ style select__css ] [ option [] [ text "YouTube" ], option [] [ text "GitHub" ], option [] [ text "Twitter" ] ]


nmd : String -> Html Msg -> Html Msg
nmd name html =
    div [ style nmd__css ] [ span [ style nmd__label ] [ text name ], html ]


btn : String -> CssStyle -> Html Msg
btn label styling =
    button [ style (button__css ++ styling) ] [ text label ]


tbl : CssStyle -> List TableColumn -> List TableRow -> Html Msg
tbl styling headers rows =
    div [ style styling ]
        [ tableLine
        , div [ style header ] (List.map columnHeader headers)
        , tableLine
        , tableRows (extractHeightCss styling) headers rows
        , tableLine
        ]


extractHeightCss : CssStyle -> CssStyle
extractHeightCss css =
    List.filter (\( prop, _ ) -> prop == "height") css


tableRows : CssStyle -> List TableColumn -> List TableRow -> Html Msg
tableRows styling headersDef rows =
    div [ style (table__rows ++ styling) ] (List.map (tableRow headersDef) rows)


tableRow : List TableColumn -> TableRow -> Html Msg
tableRow headersDef row =
    div [ style table__row ] (List.map2 tableRowColumn headersDef row)


tableRowColumn : TableColumn -> TableCell -> Html Msg
tableRowColumn ( _, columnStyling ) cell =
    case cell of
        Text value ->
            span [ style (table__row__column ++ columnStyling) ] [ text value ]

        Htm html ->
            html


columnHeader : TableColumn -> Html Msg
columnHeader ( label, styling ) =
    div [ style (header__column ++ styling) ] [ text label ]


std__input : CssStyle
std__input =
    [ ( "height", "20px" )
    , ( "border", "solid thin grey" )
    , ( "border-radius", "2px" )
    ]


nmd__css : CssStyle
nmd__css =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "margin-right", "20px" )
    ]


nmd__label : CssStyle
nmd__label =
    [ ( "font-size", "8pt" )
    ]


tableLine : Html Msg
tableLine =
    div [ style table__line ] []


button__css : CssStyle
button__css =
    std__input
        ++ [ ( "background", "white" )
           , ( "font-size", "8pt" )
           ]


select__css : CssStyle
select__css =
    std__input ++ [ ( "background-color", "white" ) ]


header : CssStyle
header =
    [ ( "display", "flex" )
    , ( "border-left", "solid thin #DCDCDC" )
    , ( "border-right", "solid thin #DCDCDC" )
    , ( "padding", "10px" )
    , ( "padding-top", "6px" )
    , ( "padding-bottom", "6px" )
    ]


section__header : CssStyle
section__header =
    [ ( "font-weight", "lighter" )
    , ( "width", "100%" )
    , ( "font-size", "14pt" )
    , ( "border-bottom", "solid 1px #A9A9A9" )
    , ( "margin-bottom", "5px" )
    ]


header__column : CssStyle
header__column =
    [ ( "font-size", "10pt" )
    , ( "text-transform", "uppercase" )
    , ( "color", "#4F4F4F" )
    ]


table__rows : CssStyle
table__rows =
    [ ( "overflow-y", "scroll" ), ( "border-left", "solid thin #DCDCDC" ) ]


table__line : CssStyle
table__line =
    [ ( "padding-left", "10px" )
    , ( "padding-right", "10px" )
    , ( "border-bottom", "solid thin #DCDCDC" )
    ]


table__row : CssStyle
table__row =
    [ ( "display", "block" )
    , ( "height", "30px" )
    , ( "max-height", "30px" )
    , ( "width", "100%" )
    , ( "padding-left", "10px" )
    ]


table__row__column : CssStyle
table__row__column =
    [ ( "color", "#585858" ), ( "display", "inline-block" ) ]
