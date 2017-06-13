module Components.Profile.Info exposing (profileInfoWidget)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import App exposing (Msg)
import Components.UI exposing (..)
import Components.API exposing (Profile)


profileInfoWidget : Profile -> Html Msg
profileInfoWidget profile =
    div [ style root__div ]
        [ section "Credentials" [ tbl table__css headers (profileCredentials profile) ]
        ]


section : String -> List (Html Msg) -> Html Msg
section name children =
    div [ style section__div ] (sectionHeader name :: children)


profileCredentials : Profile -> List (List String)
profileCredentials profile =
    profile.credentials
        |> List.concatMap (\{ dataSource, usernames } -> List.map (\u -> [ dataSource, u ]) usernames)


table__css : List ( String, String )
table__css =
    [ ( "width", "30vw" )
    ]


headers : List ( String, String )
headers =
    [ ( "Source", "150px" ), ( "Value", "190px" ) ]


section__div : List ( String, String )
section__div =
    [ ( "width", "50vw" )
    ]


root__div : List ( String, String )
root__div =
    [ ( "display", "flex" )
    , ( "justify-content", "center" )
    ]
