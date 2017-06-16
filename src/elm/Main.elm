module Main exposing (..)

import App exposing (Msg, State, ProfileTabView)
import Components.CoreUi exposing (ui, loadingView)
import Components.Home.Info exposing (speakerBrainInfo)
import Components.Profile.Parent exposing (profile)
import Components.Recommendation.Parent exposing (recommendation)
import Html exposing (..)
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

        App.LoadedRecommendations people selected ->
            ui
                queryString
                (recommendation queryString people selected)



-- CSS STYLES
-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses App.OnKeyDown
