module Msgs exposing (..)

import LF.Msgs exposing (LFMsg)
import Material


type Msg
    = NoOp
    | LockDoor
    | UnlockDoor
    | WS String
    | LF LFMsg
    | Mdl (Material.Msg Msg)
