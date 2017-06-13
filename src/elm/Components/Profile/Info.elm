module Components.Profile.Info exposing (profileInfoWidget)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style)
import App exposing (Msg)
import Components.UI exposing (..)
import Components.API exposing (Profile)


profileInfoWidget : Profile -> Html Msg
profileInfoWidget profile =
    div [ style root__div ]
        [ section "Credentials"
            [ tbl table__css headers (profileCredentials profile)
            , addCredential
            ]
        ]


addCredential : Html Msg
addCredential =
    div [ style add__credential ]
        [ div [ style add__credential__details ]
            [ nmd "Datasource" dpb
            , nmd "Credential" txt
            ]
        , btn "Add" add__credential__btn
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


add__credential : CssStyle
add__credential =
    [ ( "display", "flex" )
    , ( "justify-content", "space-between" )
    , ( "width", "30vw" )
    , ( "margin-top", "20px" )
    , ( "margin-left", "10vw" )
    ]


add__credential__details : CssStyle
add__credential__details =
    [ ( "display", "flex" ) ]


add__credential__btn : CssStyle
add__credential__btn =
    [ ( "background-color", "#c0f6d2" )
    , ( "border-color", "#c0f6d2" )
    , ( "color", "white" )
    , ( "margin-top", "10pt" )
    , ( "width", "70px" )
    ]


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
    [ ( "background-color", "#ff7c81" )
    , ( "border-color", "#ff7c81" )
    , ( "color", "white" )
    , ( "float", "right" )
    , ( "margin-right", "10px" )
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
