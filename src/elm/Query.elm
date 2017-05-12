module Query exposing (..)


type alias Query =
    List String


fromString : String -> Query
fromString s =
    String.split "," s
