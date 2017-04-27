module Models exposing (..)

import LF.Models as LF
import Material
import Material.Snackbar as Snackbar


type alias Model =
    { lf : LF.Model
    , socketUrl : String
    , httpUrl : String
    , mdl : Material.Model
    }


model : String -> String -> Model
model socketUrl httpUrl =
    { lf = LF.model httpUrl
    , socketUrl = socketUrl
    , httpUrl = httpUrl
    , mdl = Material.model
    }
