module Main exposing (..)

import App exposing (Msg, State, ProfileTabView)
import Components.UI exposing (..)
import Components.Home.Info exposing (speakerBrainInfo)
import Components.Recommendation.Details exposing (recommendationWidget)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Attributes as Attr
import Html.Events as E
import Components.API as API
import Components.Profile.Info exposing (profileInfoWidget)
import Http
import Dict
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
                    div [] [ viewSearch queryString, speakerBrainInfo info ]

                Nothing ->
                    viewSearch queryString

        App.Loading ->
            div [] [ viewSearch queryString, loadingView queryString ]

        App.Error errText ->
            text <| "Error: " ++ errText

        App.LoadedProfile profile currentTab ->
            div [ style root_div ] [ viewSearch queryString, profileTabBar profile currentTab, (showProfile profile currentTab) ]

        App.LoadedRecommendations people selectedUserId ->
            div [ style root_div ]
                [ viewSearch queryString
                , tabBar
                , showQueryResult people queryString selectedUserId
                ]


loadingView : String -> Html Msg
loadingView queryString =
    div [ style loading__view ]
        [ img [ Attr.src "static/img/loading.svg" ] []
        , span [ style loading__label ] [ text ("Looking for '" ++ queryString ++ "'...") ]
        ]


viewSearch : String -> Html Msg
viewSearch queryString =
    div [ style search__section ]
        [ input [ Attr.class "search__field", Attr.value queryString, E.onInput App.SetQuery, Attr.placeholder "Search for technology or speaker" ] []
        , button [ Attr.class "search__button", E.onClick <| App.Search queryString ] [ text "Search" ]
        ]


tabBar : Html Msg
tabBar =
    div [ style tab__bar ]
        [ div [ style (tab__item True) ] [ text "Speakers" ]
        ]


profileTabBar : API.Profile -> ProfileTabView -> Html Msg
profileTabBar profile currentTab =
    div [ style tab__bar ]
        [ profileTabItem profile currentTab App.ProfileTab "Profile"
        , profileTabItem profile currentTab App.LibraryTab "Library"
        ]


profileTabItem : API.Profile -> ProfileTabView -> ProfileTabView -> String -> Html Msg
profileTabItem profile currentTab thisTab name =
    div [ style (tab__item (currentTab == thisTab)) ]
        [ span [ E.onClick (App.ChangeProfileTab profile thisTab) ] [ text name ] ]


showProfile : API.Profile -> ProfileTabView -> Html Msg
showProfile profile currentTab =
    case currentTab of
        App.ProfileTab ->
            profileInfoWidget profile

        App.LibraryTab ->
            showProfileLibrary profile


showProfileInfo : Html Msg
showProfileInfo =
    div [] []


showProfileLibrary : API.Profile -> Html Msg
showProfileLibrary profile =
    div [ style generic__table ] <|
        (profile.data
            |> Dict.toList
            |> List.filter (Tuple.second >> List.isEmpty >> not)
            |> List.map profileDatasource
        )


profileDatasource : ( String, List API.ProfileData ) -> Html Msg
profileDatasource ( name, data ) =
    div [ style recommendation__table__line ]
        [ div [ style (recommendation__table__header ++ recommendation__table__line) ] [ text name ]
        , div [] (List.map profileDatasourceElement data)
        ]


profileDatasourceElement : API.ProfileData -> Html Msg
profileDatasourceElement data =
    div [] [ a [ Attr.href data.href ] [ text data.name ] ]


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


recommendationSource : API.Source -> Html Msg
recommendationSource source =
    if List.isEmpty source.references then
        div [] []
    else
        div []
            [ div [ style (recommendation__table__header ++ recommendation__table__line) ] [ text source.name ]
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


search__section : List ( String, String )
search__section =
    [ ( "background-color", "#FAFAFA" )
    , ( "font-size", "20px" )
    , ( "display", "flex" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "height", "10vh" )
    , ( "border-bottom", "solid thin #DCDCDC" )
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


root_div : List ( String, String )
root_div =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    ]


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


generic__table : List ( String, String )
generic__table =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "margin", "30px" )
    , ( "padding", "10px" )
    , ( "border", "solid thin #DCDCDC" )
    ]


recommendation__table : List ( String, String )
recommendation__table =
    [ ( "margin", "30px" )
    , ( "width", "50vw" )
    , ( "height", "75vh" )
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
    , ( "min-height", "30px" )
    , ( "height", "30px" )
    ]


recommendation__rating__column : List ( String, String )
recommendation__rating__column =
    [ ( "width", "90px" ) ]


recommendation__options__column : List ( String, String )
recommendation__options__column =
    [ ( "right", "0px" ), ( "float", "right" ) ]


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
    Keyboard.presses App.OnKeyDown
