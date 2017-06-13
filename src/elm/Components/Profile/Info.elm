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


profileCredentials : Profile -> List TableRow
profileCredentials profile =
    profile.credentials
        |> List.concatMap
            (\{ dataSource, usernames } ->
                List.map
                    (\u ->
                        [ (Text dataSource)
                        , (Text u)
                        , (Htm (btn "Delete" delete__btn))
                        ]
                    )
                    usernames
            )


table__css : CssStyle
table__css =
    [ ( "width", "30vw" )
    , ( "margin-left", "10vw" )
    ]


headers : List TableColumn
headers =
    [ ( "Source", [ ( "width", "150px" ) ] )
    , ( "Value", [ ( "width", "190px" ) ] )
    , ( "", [ ( "width", "60px" ) ] )
    ]


delete__btn : CssStyle
delete__btn =
    [ ( "background-color", "red" )
    , ( "border-color", "red" )
    , ( "color", "white" )
    ]


section__div : CssStyle
section__div =
    [ ( "width", "50vw" )
    ]


root__div : CssStyle
root__div =
    [ ( "display", "flex" )
    , ( "justify-content", "center" )
    ]
