module View exposing (..)

import Model exposing (..)
import Msg exposing (..)
import LoginPage exposing (..)
import DoorLocksPage exposing (..)
import DoorLockPage exposing (..)
import NotFoundPage exposing (..)
import Html exposing (..)
import Material
import Material.Scheme


page : Model -> Html Msg
page model =
    case model.route of
        LoginRoute ->
            loginPageView model

        DoorLocksRoute ->
            doorLocksPageView model

        DoorLockRoute id ->
            doorLockPageView model id

        NotFoundRoute ->
            notFoundPageView model


view : Model -> Html Msg
view model =
    div [] [ page model ] |> Material.Scheme.top
