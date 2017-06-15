module App exposing (..)

import Components.API as API
import Keyboard exposing (KeyCode)


type ProfileTabView
    = ProfileTab
    | LibraryTab


type Msg
    = OnSearchResponse API.SearchResponse
    | OnInfoResponse API.SpeakerBrainInfoResponse
    | Search String
    | ShowDetails API.Recommendation
    | ChangeProfileTab API.Profile ProfileTabView
    | SetQuery String
    | OnKeyDown KeyCode


type State
    = Init
    | Loading
    | Error String
    | LoadedRecommendations (List API.Recommendation) (Maybe API.Recommendation)
    | LoadedProfile API.Profile ProfileTabView
