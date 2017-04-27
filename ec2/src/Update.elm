module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model)
import LF.Models
import LF.Update as LF
import Material
import WebSocket
import RemoteData
import Debug


websocketUrl : Model -> String
websocketUrl model =
    let
        _ =
            Debug.log model.socketUrl 1
    in
        model.socketUrl


lockMsg : Int -> Bool -> String
lockMsg id locked =
    "{\"id\":"
        ++ (toString id)
        ++ ", \"lock\": "
        ++ (toString <|
                if locked then
                    "lock"
                else
                    "unlock"
           )
        ++ "}"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LF msg ->
            let
                ( lf, cmd ) =
                    LF.update msg model.lf
            in
                ( { model | lf = lf }, cmd )

        LockDoor ->
            case model.lf.login of
                RemoteData.Success login ->
                    ( model, WebSocket.send (websocketUrl model) (lockMsg login.button True) )

                _ ->
                    ( model, Cmd.none )

        UnlockDoor ->
            case model.lf.login of
                RemoteData.Success login ->
                    ( model, WebSocket.send (websocketUrl model) (lockMsg login.button False) )

                _ ->
                    ( model, Cmd.none )

        WS msg_ ->
            case msg_ of
                "LOGOUT" ->
                    ( { model | lf = LF.Models.model model.httpUrl }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model
