module DoorLocksPage exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Routing exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.List as Lists


doorLocksPageView : Model -> Html Msg
doorLocksPageView model =
    div []
        [ Lists.ul []
            (List.map
                (\lock ->
                    Lists.li []
                        [ Lists.content []
                            [ Lists.icon "lock" []
                            , a [ href (lockPath lock.id) ] [ text lock.name ]
                            , span [ class lock.status ] [ text lock.status ]
                            ]
                        ]
                )
                model.doorLocks
            )
        ]
