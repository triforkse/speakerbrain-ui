module Components.UiFrame exposing (ui)

import App exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Attributes as Attr
import Html.Events as E


ui : String -> Html Msg -> Html Msg
ui queryString body =
    div [ style root__css ]
        [ omniSearch queryString
        , body
        ]


omniSearch : String -> Html Msg
omniSearch queryString =
    div [ style search__css ]
        [ input [ Attr.class "search__field", Attr.value queryString, E.onInput App.SetQuery, Attr.placeholder "Search for technology or speaker" ] []
        , button [ Attr.class "search__button", E.onClick <| App.Search queryString ] [ text "Search" ]
        ]


search__css : List ( String, String )
search__css =
    [ ( "background-color", "#FAFAFA" )
    , ( "font-size", "20px" )
    , ( "display", "flex" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "height", "10vh" )
    , ( "border-bottom", "solid thin #DCDCDC" )
    ]


root__css : List ( String, String )
root__css =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    ]
