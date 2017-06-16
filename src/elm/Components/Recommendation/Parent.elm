module Components.Recommendation.Parent exposing (recommendation)

import App exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (style)
import Components.API exposing (Recommendation)
import Components.Recommendation.Details exposing (recommendationWidget)
import Components.Recommendation.Speakers exposing (recommendedSpeakers)


recommendation : String -> List Recommendation -> Maybe Recommendation -> Html Msg
recommendation queryString recommendations selectedRecommendation =
    if List.isEmpty recommendations then
        noResultsFound queryString
    else
        div [ style recommendation__frame ]
            [ recommendedSpeakers recommendations
            , case selectedRecommendation of
                Nothing ->
                    div [] []

                Just recommed ->
                    recommendationWidget recommed
            ]


noResultsFound : String -> Html Msg
noResultsFound queryString =
    div [ style no__results__found ]
        [ span [ style not__found__text ] [ text ("NO results found for \"" ++ queryString ++ "\"!") ]
        , button [ style crawl__button ] [ text ("Crawl for speakers named \"" ++ queryString ++ "\"") ]
        , button [ style crawl__button ] [ text ("Crawl for technologies named \"" ++ queryString ++ "\"") ]
        ]


recommendation__frame : List ( String, String )
recommendation__frame =
    [ ( "display", "flex" )
    , ( "align-items", "flex-start" )
    , ( "height", "80%" )
    ]


crawl__button : List ( String, String )
crawl__button =
    [ ( "align-self", "center" )
    , ( "width", "300px" )
    , ( "margin-top", "55px" )
    , ( "height", "75px" )
    , ( "background-color", "#FAFAFA" )
    , ( "border", "solid 1px #DCDCDC" )
    , ( "border-radius", "10px" )
    , ( "color", "#404040" )
    , ( "font-size", "12pt" )
    ]


not__found__text : List ( String, String )
not__found__text =
    [ ( "align-self", "center" )
    , ( "font-size", "26pt" )
    ]


no__results__found : List ( String, String )
no__results__found =
    [ ( "width", "100%" )
    , ( "margin-top", "100px" )
    , ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "justify-content", "center" )
    ]
