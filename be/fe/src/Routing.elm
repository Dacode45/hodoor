module Routing exposing (..)

import Navigation exposing (Location)
import Model exposing (..)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map DoorLockRoute (s "locks" </> string)
        , map DoorLocksRoute (s "locks")
        ]


locksPath : String
locksPath =
    "#locks"


lockPath : String -> String
lockPath id =
    "#locks/" ++ id


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
