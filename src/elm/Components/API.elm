module Components.API exposing (..)

import Json.Decode as Json exposing (..)
import Dict exposing (Dict)
import Http


baseURL : String
baseURL =
    "http://192.168.1.113:5000/"


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
    , data : Dict String DetailValue
    }


type alias Profile =
    { id : String
    , name : String
    , data : Dict String ProfileData
    }


type DetailValue
    = DetailString String
    | DetailFloat Float


type alias RecommendationResponse =
    Result Http.Error (List Recommendation)


type alias ProfileResponse =
    Result Http.Error Profile


decodeLink : Decoder Link
decodeLink =
    map2 Link
        (at [ "text" ] string)
        (at [ "href" ] string)


decodeProfileData : Decoder ProfileData
decodeProfileData =
    map3 ProfileData
        (at [ "id" ] string)
        (at [ "name" ] string)
        (at [ "data" ] <| dict decodeDetailValue)


decodeDetailValue : Decoder DetailValue
decodeDetailValue =
    oneOf
        [ string |> andThen (DetailString >> succeed)
        , float |> andThen (DetailFloat >> succeed)
        ]


decodeProfile : Decoder Profile
decodeProfile =
    map3 Profile
        (at [ "id" ] string)
        (at [ "name" ] string)
        (at [ "data" ] <| dict decodeProfileData)


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


recommend : (RecommendationResponse -> msg) -> List String -> Cmd msg
recommend toMsg topics =
    Http.get (baseURL ++ "recommend?motifs=" ++ (String.join "," topics)) (list decodePerson)
        |> Http.send toMsg


profile : (ProfileResponse -> msg) -> String -> Cmd msg
profile toMsg userId =
    Http.get (baseURL ++ "profile/" ++ toString userId) decodeProfile
        |> Http.send toMsg
