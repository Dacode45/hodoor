module DoorLock exposing (..)

import Models exposing (..)
import RemoteData
import RemoteData exposing (WebData)
import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options exposing (css)
import WebSocket


type alias Command =
    String


type alias WSModel =
    { lock : DoorLock
    }


type alias Model =
    { user : Maybe User
    , lock : WebData DoorLock
    , mdl : Material.Model
    }


init : Maybe User -> ( Model, Cmd Msg )
init user =
    ( Model user RemoteData.Loading Material.model, Cmd.none )


type Msg
    = OnFetchLock (WebData DoorLock)
    | ToggleLock DoorLockId
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchLock response ->
            ( { model | lock = response }, Cmd.none )

        ToggleLock id ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen webSocketUrl NewMessage


view : Model -> Html Msg
view model =
    case model.user of
        Just user ->
            case model.lock of
                RemoteData.NotAsked ->
                    text "Please Wait"

                RemoteData.Loading ->
                    text "Loading DoorLock"

                RemoteData.Success lock ->
                    viewDoorLock model.mdl user lock

                RemoteData.Failure error ->
                    text ("Failed to Get Lock: " ++ (toString error))

        _ ->
            viewNoUser


viewDoorLock : Material.Model -> User -> DoorLock -> Html Msg
viewDoorLock mdl user lock =
    div []
        [ h2 [] [ text (user.username ++ "'s DoorLock: " ++ lock.name) ]
        , p [] [ text ("LOCK STATUS: " ++ lock.status) ]
        , Button.render Mdl
            [ 0 ]
            mdl
            [ Button.raised
            , Button.colored
            , Options.onClick (ToggleLock lock.id)
            ]
            [ text
                (if lock.status == statusLocked then
                    "Unlock"
                 else
                    "Lock"
                )
            ]
        ]


viewNoUser : Html msg
viewNoUser =
    div [] [ a [ href "/" ] [ text "please login." ] ]


fetchLock : DoorLockId -> Cmd Msg
fetchLock id =
    Http.get (fetchLockUrl id) lockDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchLock


fetchLockUrl : DoorLockId -> String
fetchLockUrl id =
    "http://localhost:4000/api/locks/" ++ (toString id)


webSocketUrl : String
webSocketUrl =
    "ws://localhost:4000"


lockDecoder : Decode.Decoder DoorLock
lockDecoder =
    decode DoorLock
        |> Json.Decode.Pipeline.required "id" Decode.int
        |> Json.Decode.Pipeline.required "userId" Decode.int
        |> Json.Decode.Pipeline.required "name" Decode.string
        |> Json.Decode.Pipeline.required "status" Decode.string
        |> Json.Decode.Pipeline.required "webCamLink" Decode.string
