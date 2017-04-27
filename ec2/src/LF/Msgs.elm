module LF.Msgs exposing (..)

import LF.Models exposing (..)
import RemoteData exposing (WebData)


type LFMsg
    = OnLogin (WebData LogIn)
    | TextEntered String
    | Login
