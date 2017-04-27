module LF.Update exposing (..)

import LF.Msgs exposing (..)
import Msgs exposing (Msg)
import LF.Models exposing (Model)
import LF.Commands exposing (login)


update : LFMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLogin response ->
            ( { model | login = response }, Cmd.none )

        TextEntered str ->
            ( { model | text = str }, Cmd.none )

        Login ->
            ( model, login model )
