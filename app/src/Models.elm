module Models exposing (..)


type alias UserId =
    Int


type alias DoorLockId =
    Int


type alias LockStatus =
    String


statusLocked : LockStatus
statusLocked =
    "locked"


statusUnlocked : LockStatus
statusUnlocked =
    "unlocked"


type alias User =
    { id : UserId
    , doorLockId : DoorLockId
    , username : String
    }


type alias DoorLock =
    { id : DoorLockId
    , userId : UserId
    , name : String
    , status : LockStatus
    , webCamLink : String
    }


type alias Model =
    String
