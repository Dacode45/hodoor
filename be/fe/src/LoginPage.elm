module LoginPage exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options exposing (css)


loginPageView : Model -> Html Msg
loginPageView model =
    div []
        [ Html.form []
            [ Textfield.render Mdl
                [ 0 ]
                model.mdl
                [ Textfield.label "User Name"
                , Options.onInput UsernameInput
                ]
                []
            , Textfield.render Mdl
                [ 1 ]
                model.mdl
                [ Textfield.label "Password"
                , Options.onInput PasswordInput
                ]
                []
            , Button.render Mdl
                [ 2 ]
                model.mdl
                [ Button.raised
                , Options.onClick SubmitLoginForm
                ]
                [ text "Login" ]
            ]
        ]
        |> Material.Scheme.top
