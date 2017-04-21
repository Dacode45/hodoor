module Msg exposing (..)

import Material
import Navigation exposing (Location)


type Msg
    = NoOp
    | UsernameInput String
    | PasswordInput String
    | SubmitLoginForm
    | LockDoor String
    | UnlockDoor String
    | OnLocationChange Location
    | Mdl (Material.Msg Msg)
