module LF.View exposing (..)

import LF.Msgs exposing (..)
import LF.Models exposing (..)
import Msgs exposing (..)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id, style, class)
import Html
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options


textEnteredMsg : String -> Msg
textEnteredMsg str =
    LF (TextEntered str)


view : Model -> Html Msg
view model =
    div [ id "login-from" ]
        [ Textfield.render Mdl
            [ 0 ]
            model.mdl
            [ Textfield.label "Enter your door lock id"
            , Textfield.floatingLabel
            , Textfield.text_
            , Textfield.value model.text
            , Options.onInput textEnteredMsg
            ]
            []
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Button.raised
            , Button.ripple
            , Options.onClick (LF Login)
            ]
            [ text "Check Lock" ]
        ]
