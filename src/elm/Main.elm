module Main exposing (..)

import App exposing (Msg, State, ProfileTabView)
import Components.UI exposing (..)
import Components.UiFrame exposing (ui)
import Components.Home.Info exposing (speakerBrainInfo)
import Components.Recommendation.Details exposing (recommendationWidget)
import Components.Profile.Parent exposing (profile)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Attributes as Attr
import Html.Events as E
import Components.API as API
import Http
import Keyboard exposing (KeyCode)


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { state : State, queryString : String, sbInfo : Maybe API.SpeakerBrainInfo }


init : ( Model, Cmd Msg )
init =
    { state = App.Init, queryString = "", sbInfo = Nothing } ! [ API.fetchInfo App.OnInfoResponse ]



-- UPDATE


type alias Term =
    String


type Query
    = Query (List Term)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        App.Search queryString ->
            if String.isEmpty queryString then
                { model | state = App.Init } ! []
            else
                { model | state = App.Loading } ! [ API.search App.OnSearchResponse (queryString) ]

        App.SetQuery queryString ->
            { model | queryString = queryString } ! []

        App.OnKeyDown key ->
            if key == 13 then
                update (App.Search model.queryString) model
            else
                model ! []

        App.OnSearchResponse (Err err) ->
            case err of
                Http.BadPayload errorString e ->
                    { model | state = App.Error errorString } ! []

                _ ->
                    { model | state = App.Error (toString err) } ! []

        App.OnSearchResponse (Ok result) ->
            case result of
                API.SpeakerProfile profile ->
                    { model | state = (App.LoadedProfile profile App.ProfileTab) } ! []

                API.Recommendations people ->
                    { model | state = (App.LoadedRecommendations (people |> List.sortBy .total |> List.reverse) Nothing) } ! []

        App.OnInfoResponse result ->
            case result of
                Ok info ->
                    { model | sbInfo = Just info } ! []

                _ ->
                    model ! []

        App.ChangeProfileTab profile newTabView ->
            { model | state = (App.LoadedProfile profile newTabView) } ! []

        App.ShowDetails recommendation ->
            case model.state of
                App.LoadedRecommendations recommendations _ ->
                    { model | state = (App.LoadedRecommendations recommendations (Just recommendation)) } ! []

                _ ->
                    model ! []



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view { state, queryString, sbInfo } =
    case state of
        App.Init ->
            case sbInfo of
                Just info ->
                    ui queryString (speakerBrainInfo info)

                Nothing ->
                    ui queryString (div [] [])

        App.Loading ->
            ui queryString (loadingView queryString)

        App.Error errText ->
            text <| "Error: " ++ errText

        App.LoadedProfile apiProfile currentTab ->
            ui queryString (profile apiProfile currentTab)

        App.LoadedRecommendations people selectedUserId ->
            ui
                queryString
                (div [] [ tabBar, showQueryResult people queryString selectedUserId ])


loadingView : String -> Html Msg
loadingView queryString =
    div [ style loading__view ]
        [ img [ Attr.src "static/img/loading.svg" ] []
        , span [ style loading__label ] [ text ("Looking for '" ++ queryString ++ "'...") ]
        ]


tabBar : Html Msg
tabBar =
    div [ style tab__bar ]
        [ div [ style (tab__item True) ] [ text "Speakers" ]
        ]


showQueryResult : List API.Recommendation -> String -> Maybe API.Recommendation -> Html Msg
showQueryResult recommendations queryString selectedUserId =
    if List.isEmpty recommendations then
        noResultsFound queryString
    else
        div [ style recommendation__frame ]
            [ recommendationTable recommendations
            , userRecommendationDetails selectedUserId
            ]


recommendationTable : List API.Recommendation -> Html Msg
recommendationTable recommendations =
    tbl recommendation__table recommendationColumns (List.map recommendationTableRow recommendations)


recommendationColumns : List TableColumn
recommendationColumns =
    [ ( "Rating", [ ( "width", "70px" ) ] )
    , ( "Speaker", [ ( "width", "90px" ) ] )
    ]


userRecommendationDetails : Maybe API.Recommendation -> Html Msg
userRecommendationDetails selectedUserId =
    case selectedUserId of
        Nothing ->
            div [] []

        Just recommendation ->
            recommendationWidget recommendation


recommendationTableRow : API.Recommendation -> TableRow
recommendationTableRow recommendation =
    [ (Text (toString recommendation.total))
    , (Htm (span [ style link__button ] [ a [ E.onClick (App.ShowDetails recommendation) ] [ text recommendation.name ] ]))
    ]


noResultsFound : String -> Html Msg
noResultsFound queryString =
    div [ style no__results__found ]
        [ span [ style not__found__text ] [ text ("NO results found for \"" ++ queryString ++ "\"!") ]
        , button [ style crawl__button ] [ text ("Crawl for speakers named \"" ++ queryString ++ "\"") ]
        , button [ style crawl__button ] [ text ("Crawl for technologies named \"" ++ queryString ++ "\"") ]
        ]



-- CSS STYLES


loading__view : List ( String, String )
loading__view =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "height", "90vh" )
    ]


loading__label : List ( String, String )
loading__label =
    [ ( "font-size", "32pt" )
    , ( "font-weight", "lighter" )
    ]


tab__bar : List ( String, String )
tab__bar =
    [ ( "height", "5vh" )
    , ( "padding-left", "30px" )
    , ( "padding-right", "30px" )
    , ( "display", "flex" )
    , ( "border-bottom", "solid thin #DCDCDC" )
    ]


tab__item : Bool -> List ( String, String )
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


link__button : List ( String, String )
link__button =
    [ ( "cursor", "pointer" ) ]


no__results__found : List ( String, String )
no__results__found =
    [ ( "width", "100%" )
    , ( "margin-top", "100px" )
    , ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "justify-content", "center" )
    ]


not__found__text : List ( String, String )
not__found__text =
    [ ( "align-self", "center" )
    , ( "font-size", "26pt" )
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


recommendation__frame : List ( String, String )
recommendation__frame =
    [ ( "display", "flex" )
    , ( "align-items", "flex-start" )
    , ( "height", "80%" )
    ]


recommendation__table : List ( String, String )
recommendation__table =
    [ ( "margin", "30px" )
    , ( "width", "50vw" )
    , ( "height", "75vh" )
    ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses App.OnKeyDown
