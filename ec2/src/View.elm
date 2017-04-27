module View exposing (..)

import Html exposing (Html, h1, div, text, iframe, h4, span)
import Html.Attributes exposing (src, class)
import Msgs exposing (Msg(..))
import Models exposing (Model)
import LF.View
import LF.Models exposing (LogIn)
import RemoteData
import Material.Button as Button
import Material.Card as Card
import Material.Options as Options
import Material.Scheme
import Material.Layout as Layout


view : Model -> Html Msg
view model =
    Material.Scheme.top <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = [ h1 [] [ text "Door Locks" ] ]
            , drawer = []
            , tabs = ( [], [] )
            , main = [ page model ]
            }


page : Model -> Html Msg
page model =
    case model.lf.login of
        RemoteData.Success login ->
            viewLoggedIn model login

        RemoteData.Failure error ->
            div [] [ LF.View.view model.lf, span [ class "error" ] [ text "No door lock with that id" ] ]

        _ ->
            div [] [ LF.View.view model.lf ]


viewLocked : LogIn -> Html msg
viewLocked login =
    if login.locked then
        span [ class "locked-text" ] [ text "Your door is locked" ]
    else
        span [ class "unlocked-text" ] [ text "Your door is unlocked" ]


iframeUrl : Model -> String -> String
iframeUrl model str =
    model.httpUrl ++ "/api/" ++ str ++ "/view/"


viewLoggedIn : Model -> LogIn -> Html Msg
viewLoggedIn model login =
    div []
        [ Card.view []
            [ Card.title []
                [ Card.head [] [ text "Welcome to your doorlock" ]
                , Card.subhead [] [ viewLocked login ]
                ]
            , Card.text []
                [ iframe
                    [ src <| (iframeUrl model (toString login.button))
                    , class "iframe"
                    ]
                    []
                ]
            , Card.actions []
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised
                    , Button.primary
                    , Options.onClick LockDoor
                    ]
                    [ text "Lock Door" ]
                , Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised
                    , Button.accent
                    , Options.onClick UnlockDoor
                    ]
                    [ text "Unlock Door" ]
                ]
            ]
        ]
