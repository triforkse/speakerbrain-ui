module Components.Home.Info exposing (speakerBrainInfo)

import Html exposing (Html, div, text, span)
import Html.Attributes exposing (style)
import App exposing (Msg)
import Components.API exposing (SpeakerBrainInfo)


speakerBrainInfo : SpeakerBrainInfo -> Html Msg
speakerBrainInfo info =
    div [ style info__root ]
        [ speakerStat info
        , twitterStat info
        , youtubeStat info
        , githubStat info
        , lanyrdStat info
        ]


speakerStat : SpeakerBrainInfo -> Html Msg
speakerStat info =
    div []
        [ numStat info.speakers
        , text " speakers found"
        ]


twitterStat : SpeakerBrainInfo -> Html Msg
twitterStat info =
    div []
        [ numStat info.tweets
        , text " tweets from "
        , numStat info.twitter_accounts
        , text " accounts"
        ]


githubStat : SpeakerBrainInfo -> Html Msg
githubStat info =
    div []
        [ numStat info.github_repositories
        , text " GitHub repositories from "
        , numStat info.github_users
        , text " GitHub users"
        ]


youtubeStat : SpeakerBrainInfo -> Html Msg
youtubeStat info =
    div []
        [ numStat info.youtube_videos
        , text " YouTube videos"
        ]


lanyrdStat : SpeakerBrainInfo -> Html Msg
lanyrdStat info =
    div []
        [ numStat info.lanyrd_events
        , text " Lanyrd Events with "
        , numStat info.lanyrd_profiles
        , text " Lanyrd speakers"
        ]


numStat : String -> Html Msg
numStat value =
    span [ style num__stat ] [ text value ]


info__root : List ( String, String )
info__root =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "height", "90vh" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "color", "#575757" )
    , ( "font-size", "32pt" )
    , ( "font-weight", "lighter" )
    ]


num__stat : List ( String, String )
num__stat =
    [ ( "font-weight", "bold" ) ]
