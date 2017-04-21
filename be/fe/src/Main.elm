module Main exposing (..)

import Model exposing (..)
import Msg exposing (..)
import Routing exposing (parseLocation)
import View exposing (..)
import Html exposing (..)
import Material


---- MODEL ----
---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UsernameInput username ->
            ( { model | loginForm = LoginForm username model.loginForm.password }, Cmd.none )

        PasswordInput password ->
            ( { model | loginForm = LoginForm model.loginForm.username password }, Cmd.none )

        SubmitLoginForm ->
            ( model, Cmd.none )

        LockDoor id ->
            ( model, Cmd.none )

        UnlockDoor id ->
            ( model, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



---- VIEW ----
---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
