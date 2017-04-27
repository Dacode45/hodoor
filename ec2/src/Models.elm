module Models exposing (..)

import LF.Models as LF
import Material
import Material.Snackbar as Snackbar
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)


type alias Model =
    { lf : LF.Model
    , socketUrl : String
    , httpUrl : String
    , status : Maybe WSUpdate
    , mdl : Material.Model
    }


type alias WSUpdate =
    { button : Int
    , locked : Bool
    , msg : String
    }


wsDecoder : Decode.Decoder WSUpdate
wsDecoder =
    decode WSUpdate
        |> required "button" Decode.int
        |> required "locked" Decode.bool
        |> required "msg" Decode.string


model : String -> String -> Model
model socketUrl httpUrl =
    { lf = LF.model httpUrl
    , socketUrl = socketUrl
    , httpUrl = httpUrl
    , status = Nothing
    , mdl = Material.model
    }
