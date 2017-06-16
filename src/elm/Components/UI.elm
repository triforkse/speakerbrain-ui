module Components.UI
    exposing
        ( CssStyle
        , TableColumn
        , TableRow
        , Element(Text, Htm)
        , Category
        , CategoryHeader
        , CategoryEntry
        , Tab
        , tab
        , sectionHeader
        , tbl
        , ctbl
        , btn
        , dpb
        , nmd
        , txt
        )

import App exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Attributes as Attr
import Html.Events as E


type alias CssStyle =
    List ( String, String )


type alias TableColumn =
    ( String, CssStyle )


type Element
    = Htm (Html Msg)
    | Text String


type alias TableRow =
    List Element


type alias CategoryHeader =
    List Element


type alias CategoryEntry =
    List Element


type alias Category =
    { header : CategoryHeader
    , entries : CategoryEntry
    }


type alias Tab =
    { header : String
    , message : Msg
    , isActive : Bool
    }


tab : List Tab -> Html Msg
tab tabs =
    div [ style tab__bar ] (List.map tabItem tabs)


tabItem : Tab -> Html Msg
tabItem tab =
    div [ style (tab__item tab.isActive) ]
        [ span [ E.onClick tab.message ] [ text tab.header ]
        ]


tab__bar : List ( String, String )
tab__bar =
    [ ( "height", "5vh" )
    , ( "padding-left", "30px" )
    , ( "padding-right", "30px" )
    , ( "display", "flex" )
    , ( "border-bottom", "solid thin #DCDCDC" )
    ]


tab__item : Bool -> CssStyle
tab__item active =
    [ ( "height", "5vh" )
    , ( "display", "flex" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "margin-right", "20px" )
    , ( "cursor", "pointer" )
    ]
        ++ if active then
            [ ( "font-weight", "bold" ) ]
           else
            [ ( "opacity", "0.8" ) ]


sectionHeader : String -> Html Msg
sectionHeader name =
    div [ style section__header ] [ span [] [ text name ] ]


ctbl : CssStyle -> List Category -> Html Msg
ctbl styling categories =
    div [ style styling ] (tableLine :: (List.map drawCategory categories))


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


drawCategory : Category -> Html Msg
drawCategory category =
    div []
        [ categoryHeader category.header
        , tableLine
        , categoryEntries category.entries
        , tableLine
        ]


categoryHeader : CategoryHeader -> Html Msg
categoryHeader cheader =
    div [ style category__header ] (List.map (drawElement False) cheader)


drawElement : Bool -> Element -> Html Msg
drawElement break element =
    case element of
        Text value ->
            if break then
                div [] [ text value ]
            else
                span [] [ text value ]

        Htm html ->
            html


categoryEntries : CategoryEntry -> Html Msg
categoryEntries entries =
    div [ style category__header ] (List.map (drawElement True) entries)


extractHeightCss : CssStyle -> CssStyle
extractHeightCss css =
    List.filter (\( prop, _ ) -> prop == "height") css


tableRows : CssStyle -> List TableColumn -> List TableRow -> Html Msg
tableRows styling headersDef rows =
    div [ style (table__rows ++ styling) ] (List.map (tableRow headersDef) rows)


tableRow : List TableColumn -> TableRow -> Html Msg
tableRow headersDef row =
    div [ style table__row ] (List.map2 tableRowColumn headersDef row)


tableRowColumn : TableColumn -> Element -> Html Msg
tableRowColumn ( _, columnStyling ) cell =
    case cell of
        Text value ->
            span [ style (table__row__column ++ columnStyling) ] [ text value ]

        Htm html ->
            html


columnHeader : TableColumn -> Html Msg
columnHeader ( label, styling ) =
    div [ style (header__column ++ styling) ] [ text label ]


category__header : CssStyle
category__header =
    [ ( "border-left", "solid thin #DCDCDC" )
    , ( "border-right", "solid thin #DCDCDC" )
    , ( "padding", "4px" )
    , ( "color", "#4F4F4F" )
    ]


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
    [ ( "overflow-y", "auto" ), ( "border-left", "solid thin #DCDCDC" ) ]


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
