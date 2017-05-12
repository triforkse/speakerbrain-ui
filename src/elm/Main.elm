module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as E
import Components.API as API
import Http
import Query
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


type State
    = Init
    | Loading
    | Error String
    | Loaded (List API.Recommendation)


type alias Model =
    { state : State, queryString : String }


init : ( Model, Cmd Msg )
init =
    { state = Init, queryString = "" } ! []



-- UPDATE


type Msg
    = OnResponse API.RecommendationResponse
    | Search String
    | SetQuery String
    | OnKeyDown KeyCode


type alias Term =
    String


type Query
    = Query (List Term)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search queryString ->
            { model | state = Loading } ! [ API.recommend OnResponse (Query.fromString queryString) ]

        SetQuery queryString ->
            { model | queryString = queryString } ! []

        OnKeyDown key ->
            if key == 13 then
                update (Search model.queryString) model
            else
                model ! []

        OnResponse (Err err) ->
            case err of
                Http.BadPayload errorString e ->
                    { model | state = Error errorString } ! []

                _ ->
                    { model | state = Error (toString err) } ! []

        OnResponse (Ok people) ->
            { model | state = (Loaded (people |> List.sortBy .total |> List.reverse)) } ! []



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view { state, queryString } =
    case state of
        Init ->
            viewSearch queryString

        Loading ->
            div []
                [ viewSearch queryString
                , text "Searching..."
                ]

        Error errText ->
            text <| "Error: " ++ errText

        Loaded people ->
            div []
                [ viewSearch queryString
                , ul [] (List.map (\person -> li [] [ viewRecomendation person ]) people)
                ]


viewSearch : String -> Html Msg
viewSearch queryString =
    div [ Attr.class "search" ]
        [ input [ Attr.class "search__field", Attr.value queryString, E.onInput SetQuery ] []
        , button [ Attr.class "search__button", E.onClick <| Search queryString ] [ text "Search" ]
        ]


viewLink link =
    a [ Attr.href link.href ] [ text link.text ]


viewSource source =
    div []
        [ b [] [ text source.name ]
        , ul [] (List.map (viewLink >> List.singleton >> li []) source.references)
        ]


viewRecomendation : API.Recommendation -> Html Msg
viewRecomendation recommendation =
    div [ Attr.class "recommendation" ]
        [ h1 [ Attr.class "recommendation__name" ] [ text <| recommendation.name ++ " (" ++ (toString recommendation.total) ++ ")" ]
        , div [] (List.map viewSource recommendation.sources)
        ]


viewProfile : API.Profile -> Html Msg
viewProfile profile =
    div []
        [ div [] [ text <| profile.name ]
        , div [] []
        ]



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "33%" )
        , ( "border", "4px solid #337AB7" )
        ]
    }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses OnKeyDown
