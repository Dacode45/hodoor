module Main exposing (..)

import Html exposing (programWithFlags)
import Msgs exposing (Msg(..))
import Models exposing (Model)
import Update exposing (update, websocketUrl)
import View exposing (view)
import WebSocket


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Models.model flags.socketUrl flags.httpUrl, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen (websocketUrl model) WS


type alias Flags =
    { socketUrl : String
    , httpUrl : String
    }



-- MAIN


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
