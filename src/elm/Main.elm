module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Attributes as Attr
import Html.Events as E
import Components.API as API
import Http
import Dict
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


type alias UiRecommendation =
    { id : String
    , name : String
    , total : Float
    , sources : List API.Source
    , showDetails : Bool
    }


apiRecommendationToUi : API.Recommendation -> UiRecommendation
apiRecommendationToUi apiRec =
    { id = apiRec.id
    , name = apiRec.name
    , total = apiRec.total
    , sources = apiRec.sources
    , showDetails = False
    }



-- MODEL


type State
    = Init
    | Loading
    | Error String
    | LoadedRecommendations (List UiRecommendation)
    | LoadedProfile API.Profile


type alias Model =
    { state : State, queryString : String }


init : ( Model, Cmd Msg )
init =
    { state = Init, queryString = "" } ! []



-- UPDATE


type Msg
    = OnResponse API.SearchResponse
    | Search String
    | ShowDetails String
    | SetQuery String
    | OnKeyDown KeyCode


type alias Term =
    String


type Query
    = Query (List Term)


toggleDetailsForRecommendation : String -> UiRecommendation -> UiRecommendation
toggleDetailsForRecommendation userId recommendation =
    if recommendation.id == userId then
        { recommendation | showDetails = not recommendation.showDetails }
    else
        recommendation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search queryString ->
            { model | state = Loading } ! [ API.search OnResponse (queryString) ]

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

        OnResponse (Ok result) ->
            case result of
                API.SpeakerProfile profile ->
                    { model | state = (LoadedProfile profile) } ! []

                API.Recommendations people ->
                    { model | state = (LoadedRecommendations (people |> List.sortBy .total |> List.reverse |> List.map apiRecommendationToUi)) } ! []

        ShowDetails userId ->
            case model.state of
                LoadedRecommendations recommendations ->
                    { model | state = (LoadedRecommendations (List.map (toggleDetailsForRecommendation userId) recommendations)) } ! []

                _ ->
                    model ! []



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

        LoadedProfile profile ->
            div [ style root_div ] [ viewSearch queryString, showProfile profile ]

        LoadedRecommendations people ->
            div [ style root_div ]
                [ viewSearch queryString
                , showQueryResult people queryString
                ]


viewSearch : String -> Html Msg
viewSearch queryString =
    div [ Attr.class "search" ]
        [ input [ Attr.class "search__field", Attr.value queryString, E.onInput SetQuery ] []
        , button [ Attr.class "search__button", E.onClick <| Search queryString ] [ text "Search" ]
        ]


showProfile : API.Profile -> Html Msg
showProfile profile =
    div [] <|
        (profile.data
            |> Dict.toList
            |> List.filter (Tuple.second >> List.isEmpty >> not)
            |> List.map profileDatasource
        )


profileDatasource : ( String, List API.ProfileData ) -> Html Msg
profileDatasource ( name, data ) =
    div []
        [ h2 [] [ text name ]
        , div [] (List.map profileDatasourceElement data)
        ]


profileDatasourceElement : API.ProfileData -> Html Msg
profileDatasourceElement data =
    div [] [ text data.name ]


showQueryResult : List UiRecommendation -> String -> Html Msg
showQueryResult recommendations queryString =
    if List.isEmpty recommendations then
        noResultsFound queryString
    else
        recommendationTable recommendations


recommendationTable : List UiRecommendation -> Html Msg
recommendationTable recommendations =
    div [ style recommendation__table ] (recommendationTableHeader :: (List.map recommendationTableRow recommendations))


recommendationTableHeader : Html Msg
recommendationTableHeader =
    div [ style (recommendation__table__row ++ recommendation__table__line) ]
        [ span [ style recommendation__table__header ] [ text "Speaker" ]
        , span [ style recommendation__table__header ] [ text "Rating" ]
        , span [ style recommendation__table__header ] [ text "Options" ]
        ]


recommendationTableRow : UiRecommendation -> Html Msg
recommendationTableRow recommendation =
    div []
        [ div [ style recommendation__table__row ]
            [ span [] [ text recommendation.name ]
            , span [] [ text (toString recommendation.total) ]
            , span [] [ recommendationRowOptions recommendation ]
            ]
        , if recommendation.showDetails then
            recommendationDetails recommendation.sources
          else
            div [] []
        ]


recommendationRowOptions : UiRecommendation -> Html Msg
recommendationRowOptions recommendation =
    div []
        [ button [ style recommendation__row__details__btn, E.onClick (ShowDetails recommendation.id) ] [ text "Details" ]
        , button [ style recommendation__row__details__btn ] [ text "Search" ]
        ]


recommendationDetails : List API.Source -> Html Msg
recommendationDetails sources =
    div [ style recommendation__details ] (List.map recommendationSource sources)


recommendationSource : API.Source -> Html Msg
recommendationSource source =
    if List.isEmpty source.references then
        div [] []
    else
        div []
            [ div [] [ span [ style recommendation__source__name ] [ text source.name ] ]
            , ul [] (List.map recommendationSourceLink source.references)
            ]


recommendationSourceLink : API.Link -> Html Msg
recommendationSourceLink link =
    div [] [ a [ Attr.href link.href ] [ text link.text ] ]


noResultsFound : String -> Html Msg
noResultsFound queryString =
    div [ style no__results__found ]
        [ span [ style not__found__text ] [ text ("NO results found for \"" ++ queryString ++ "\"!") ]
        , button [ style crawl__button ] [ text ("Crawl for speakers named \"" ++ queryString ++ "\"") ]
        , button [ style crawl__button ] [ text ("Crawl for technologies named \"" ++ queryString ++ "\"") ]
        ]


viewProfile : API.Profile -> Html Msg
viewProfile profile =
    div []
        [ div [] [ text <| profile.name ]
        , div [] []
        ]



-- CSS STYLES


root_div : List ( String, String )
root_div =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    ]


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


recommendation__table : List ( String, String )
recommendation__table =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "justify-content", "space-around" )
    , ( "margin", "30px" )
    , ( "padding", "10px" )
    , ( "border", "solid thin #DCDCDC" )
    ]


recommendation__table__header : List ( String, String )
recommendation__table__header =
    [ ( "font-size", "10pt" )
    , ( "text-transform", "uppercase" )
    , ( "color", "#4F4F4F" )
    ]


recommendation__table__line : List ( String, String )
recommendation__table__line =
    [ ( "margin-left", "-10px" )
    , ( "padding-left", "10px" )
    , ( "margin-right", "-10px" )
    , ( "padding-right", "10px" )
    , ( "padding-bottom", "3px" )
    , ( "margin-bottom", "4px" )
    , ( "border-bottom", "solid thin #DCDCDC" )
    ]


recommendation__table__row : List ( String, String )
recommendation__table__row =
    [ ( "display", "flex" )
    , ( "height", "30px" )
    , ( "justify-content", "space-between" )
    ]


recommendation__details : List ( String, String )
recommendation__details =
    [ ( "margin-bottom", "7px" )
    ]


recommendation__source__name : List ( String, String )
recommendation__source__name =
    [ ( "text-transform", "capitalize" )
    ]


recommendation__row__details__btn : List ( String, String )
recommendation__row__details__btn =
    [ ( "background-color", "#FAFAFA" )
    , ( "border", "solid 1px #DCDCDC" )
    , ( "margin-right", "7px" )
    ]


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
