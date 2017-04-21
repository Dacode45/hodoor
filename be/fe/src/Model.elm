module Model exposing (..)

import Msg exposing (..)
import Material


type alias Status =
    String


type alias LoginForm =
    { username : String
    , password : String
    }


type Route
    = LoginRoute
    | DoorLockRoute String
    | DoorLocksRoute
    | NotFoundRoute


type alias User =
    { id : String
    , username : String
    }


type alias DoorLock =
    { id : String
    , userId : String
    , status : Status
    , name : String
    , awsClientId : String
    , webcamLink : String
    }


type alias Model =
    { user : Maybe User
    , doorLocks : Maybe (List DoorLock)
    , loginForm : LoginForm
    , route : Route
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { user = Nothing
      , doorLocks = Nothing
      , loginForm = LoginForm "" ""
      , route = LoginRoute
      , mdl = Material.model
      }
    , Cmd.none
    )
