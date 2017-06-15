module Components.API
    exposing
        ( SearchResponse
        , SpeakerBrainInfoResponse
        , Recommendation
        , SearchResult(..)
        , Profile
        , SpeakerBrainInfo
        , ProfileData
        , Source
        , Link
        , search
        , fetchInfo
        )

import Json.Decode as Json exposing (..)
import Dict exposing (Dict)
import Http


andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    map2 (|>)


{-| Infix version of `andMap` that makes for a nice DSL when decoding objects.
See [the `(|:)` docs](https://github.com/elm-community/json-extra/blob/2.0.0/docs/infixAndMap.md)
for an explanation of how `(|:)` works and how to use it.
-}
(|:) : Decoder (a -> b) -> Decoder a -> Decoder b
(|:) =
    flip andMap


baseURL : String
baseURL =
    "http://localhost:5000/"


type alias SpeakerBrainInfo =
    { datasources : List String
    , speakers : String
    , tweets : String
    , twitter_accounts : String
    , youtube_videos : String
    , github_repositories : String
    , github_users : String
    , lanyrd_profiles : String
    , lanyrd_events : String
    }


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


type alias CredenitalSet =
    { dataSource : String
    , usernames : List String
    }


type alias Profile =
    { id : String
    , name : String
    , credentials : List CredenitalSet
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


type alias SpeakerBrainInfoResponse =
    Result Http.Error SpeakerBrainInfo


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
                        data |> Dict.remove "id" |> Dict.remove "name" |> Dict.remove "origin_url"
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


decodeDetailValue : Decoder DetailValue
decodeDetailValue =
    oneOf
        [ Json.map DetailString string
        , Json.map DetailFloat float
        , Json.map DetailBool bool
        ]


decodeCredentials : Decoder (List CredenitalSet)
decodeCredentials =
    dict (list string)
        |> Json.map Dict.toList
        |> Json.map (List.map (\( k, v ) -> CredenitalSet k v))


decodeProfile : Decoder Profile
decodeProfile =
    map4 Profile
        (at [ "id" ] string)
        (at [ "name" ] string)
        (at [ "credentials" ] decodeCredentials)
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


decodeSpeakerbrainInfo : Decoder SpeakerBrainInfo
decodeSpeakerbrainInfo =
    succeed SpeakerBrainInfo
        |: (at [ "datasources" ] (list string))
        |: (at [ "speakers" ] string)
        |: (at [ "tweets" ] string)
        |: (at [ "twitter_accounts" ] string)
        |: (at [ "youtube_videos" ] string)
        |: (at [ "github_repositories" ] string)
        |: (at [ "github_users" ] string)
        |: (at [ "lanyrd_profiles" ] string)
        |: (at [ "lanyrd_events" ] string)


fetchInfo : (SpeakerBrainInfoResponse -> msg) -> Cmd msg
fetchInfo toMsg =
    Http.get (baseURL ++ "info") decodeSpeakerbrainInfo |> Http.send toMsg
