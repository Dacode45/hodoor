module DoorLockPage exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Button as Button
import Material.Options as Options


doorLockPageView : Model -> String -> Html Msg
doorLockPageView model id =
    let
        d =
            List.filter (\d -> d.id == id) model.doorLocks |> List.head
    in
        case d of
            Just lock ->
                div []
                    [ h3 [] [ a [ href ("/doors/" ++ toString (lock.id)) ] [ text lock.name ] ]
                    , h4 [ class lock.status ] [ text lock.status ]
                    , Button.render Mdl
                        [ 0 ]
                        model.mdl
                        [ Button.raised
                        , Button.ripple
                        , Options.onClick (LockDoor id)
                        ]
                        [ text "Lock Door" ]
                    , Button.render Mdl
                        [ 1 ]
                        model.mdl
                        [ Button.raised
                        , Button.ripple
                        , Options.onClick (UnlockDoor id)
                        ]
                        [ text "Unlock Door" ]
                    ]

            _ ->
                div [] [ h1 [] [ text "Can't find that lock!" ] ]
