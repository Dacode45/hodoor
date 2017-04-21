module NotFoundPage exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Html exposing (..)


notFoundPageView : Model -> Html msg
notFoundPageView model =
    div []
        [ text "Page Not Found !" ]
