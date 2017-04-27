module LF.Models exposing (..)

import RemoteData exposing (WebData)
import Material


type alias LogIn =
    { button : Int
    , locked : Bool
    }


type alias Model =
    { url : String
    , text : String
    , login : WebData LogIn
    , mdl : Material.Model
    }


model : String -> Model
model url =
    Model url "" RemoteData.Loading Material.model
