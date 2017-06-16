module Components.Profile.Parent exposing (profile)

import App exposing (Msg, ProfileTabView)
import Components.API exposing (Profile)
import Components.UI exposing (tab)
import Components.Profile.Info exposing (profileInfoWidget)
import Components.Profile.Library exposing (profileLibrary)
import Html exposing (..)


-- import Html.Attributes exposing (style)


profile : Profile -> ProfileTabView -> Html Msg
profile apiProfile currentTab =
    div []
        [ tabBar apiProfile currentTab
        , displayTabContent apiProfile currentTab
        ]


tabBar : Profile -> ProfileTabView -> Html Msg
tabBar profile current =
    tab
        [ { header = "Profile", message = (App.ChangeProfileTab profile App.ProfileTab), isActive = current == App.ProfileTab }
        , { header = "Library", message = (App.ChangeProfileTab profile App.LibraryTab), isActive = current == App.LibraryTab }
        ]


displayTabContent : Profile -> ProfileTabView -> Html Msg
displayTabContent profile currentTab =
    case currentTab of
        App.ProfileTab ->
            profileInfoWidget profile

        App.LibraryTab ->
            profileLibrary profile
