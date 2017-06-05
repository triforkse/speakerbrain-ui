module Components.API exposing (..)

import Json.Decode as Json exposing (..)
import Dict exposing (Dict)
import Http


baseURL : String
baseURL =
    "http://localhost:5000/"


type alias Source =
    { name : String
    , rating : Float
    , references : List Link
    , details : List (Dict String DetailValue)
    }


type alias Link =
    { text : String, href : String }


type alias Recommendation =
    { id : String
    , name : String
    , total : Float
    , sources : List Source
    }


type alias ProfileData =
    { id : String
    , name : String
    , href : String
    , data : Dict String DetailValue
    }



-- type alias DataSourceEntry a =
--     { a
--         | id : String
--         , name : String
--     }
--
--
-- type alias UnknownDataSourceEntry =
--     DataSourceEntry
--         { data : Dict String DetailValue
--         }
--
--
-- type alias YouTubeVideo =
--     DataSourceEntry
--         { youtubeId : String
--         , views : String
--         , likes : String
--         , dislikes : String
--         }
--
--
-- type alias LanyrdEvent =
--     DataSourceEntry
--         { location : String
--         , date : String
--         }
--
--
-- type alias GitHubRepository =
--     DataSourceEntry
--         { language : String
--         , stargazers : String
--         , subscribers : String
--         , forks : String
--         , watchers : String
--         , fromOrganisation : String
--         }
--


type alias Profile =
    { id : String
    , name : String
    , data : Dict String (List ProfileData)
    }


type DetailValue
    = DetailString String
    | DetailFloat Float
    | DetailBool Bool


type alias RecommendationResponse =
    Result Http.Error (List Recommendation)


type alias ProfileResponse =
    Result Http.Error Profile


type SearchResult
    = Recommendations (List Recommendation)
    | SpeakerProfile Profile


type alias SearchResponse =
    Result Http.Error SearchResult


decodeLink : Decoder Link
decodeLink =
    map2 Link
        (at [ "text" ] string)
        (at [ "href" ] string)


decodeProfileData : Decoder ProfileData
decodeProfileData =
    dict decodeDetailValue
        |> andThen
            (\data ->
                let
                    id =
                        Dict.get "id" data

                    name =
                        Dict.get "name" data

                    href =
                        Dict.get "origin_url" data

                    others =
                        data |> Dict.remove "id" |> Dict.remove "name"
                in
                    case ( id, name, href ) of
                        ( Just (DetailString id), Just (DetailString name), Just (DetailString href) ) ->
                            map4 ProfileData
                                (Json.succeed id)
                                (Json.succeed name)
                                (Json.succeed href)
                                (Json.succeed others)

                        ( Nothing, _, _ ) ->
                            Json.fail "id is missing"

                        ( _, Nothing, _ ) ->
                            Json.fail "name is missing"

                        ( Just (DetailString id), Just (DetailString name), Nothing ) ->
                            map4 ProfileData
                                (Json.succeed id)
                                (Json.succeed name)
                                (Json.succeed "")
                                (Json.succeed others)

                        error ->
                            Json.fail <| "id or name is illegal: " ++ (toString error)
            )



-- map3 ProfileData
--     (at [ "id" ] string)
--     (at [ "name" ] string)
--     (at [ "data" ] <| dict decodeDetailValue)


decodeDetailValue : Decoder DetailValue
decodeDetailValue =
    oneOf
        [ Json.map DetailString string
        , Json.map DetailFloat float
        , Json.map DetailBool bool
        ]


decodeProfile : Decoder Profile
decodeProfile =
    map3 Profile
        (at [ "id" ] string)
        (at [ "name" ] string)
        (at [ "data" ] <| dict (list decodeProfileData))


decodeSource : Decoder Source
decodeSource =
    map4 Source
        (at [ "name" ] string)
        (at [ "rating" ] float)
        (at [ "references" ] <| list decodeLink)
        (at [ "details" ] <| list (dict decodeDetailValue))


decodePerson : Decoder Recommendation
decodePerson =
    map4 Recommendation
        (at [ "id" ] string)
        (at [ "name" ] string)
        (at [ "total" ] float)
        (at [ "sources" ] <| list decodeSource)


decodeSearch : Decoder SearchResult
decodeSearch =
    at [ "result" ] string |> andThen decodeSearchData


decodeSearchData : String -> Decoder SearchResult
decodeSearchData result =
    case result of
        "recommendations" ->
            map Recommendations (field "data" (list decodePerson))

        "speakerprofile" ->
            map SpeakerProfile (field "data" decodeProfile)

        _ ->
            fail (result ++ " unkown result")


search : (SearchResponse -> msg) -> String -> Cmd msg
search toMsg query =
    Http.get (baseURL ++ "search?query=" ++ query) decodeSearch |> Http.send toMsg


recommend : (RecommendationResponse -> msg) -> String -> Cmd msg
recommend toMsg query =
    Http.get (baseURL ++ "recommend?query=" ++ query) (list decodePerson)
        |> Http.send toMsg


profile : (ProfileResponse -> msg) -> String -> Cmd msg
profile toMsg userId =
    Http.get (baseURL ++ "profile/" ++ toString userId) decodeProfile
        |> Http.send toMsg
