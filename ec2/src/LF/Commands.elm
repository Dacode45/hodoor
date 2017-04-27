module LF.Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import LF.Msgs exposing (..)
import LF.Models exposing (..)
import RemoteData
import Msgs exposing (..)


getUrl : Model -> String
getUrl model =
    model.url ++ "/api/login/" ++ model.text


login : Model -> Cmd Msg
login model =
    Http.get (getUrl model) loginDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnLogin
        |> Cmd.map LF


loginDecoder : Decode.Decoder LogIn
loginDecoder =
    decode LogIn
        |> required "button" Decode.int
        |> required "locked" Decode.bool
