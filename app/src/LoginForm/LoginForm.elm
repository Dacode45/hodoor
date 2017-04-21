module LoginForm exposing (..)

import Models exposing (User)
import RemoteData
import RemoteData exposing (WebData)
import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Html exposing (..)
import Material
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options exposing (css)


type alias Model =
    { username : String
    , password : String
    , user : WebData (User)
    , mdl : Material.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" RemoteData.Loading Material.model, Cmd.none )


type Msg
    = UsernameInput String
    | PasswordInput String
    | SubmitLoginForm
    | OnLogin (WebData User)
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UsernameInput username ->
            ( { model | username = username }, Cmd.none )

        PasswordInput password ->
            ( { model | password = password }, Cmd.none )

        SubmitLoginForm ->
            ( model, loginUser model.username model.password )

        OnLogin response ->
            ( { model | user = response }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    let
        loadingText =
            case model.user of
                RemoteData.NotAsked ->
                    text "Try Logging In"

                RemoteData.Loading ->
                    text "Attempting Login"

                RemoteData.Success user ->
                    text ("Logged in as " ++ user.username)

                RemoteData.Failure error ->
                    text ("Failed To Login: " ++ (toString error))
    in
        div []
            [ loadingText
            , Html.form []
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


loginUser : String -> String -> Cmd Msg
loginUser username password =
    Http.post loginUserUrl (loginBody username password) userDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnLogin


loginUserUrl : String
loginUserUrl =
    "http://localhost:4000/api/login"


loginBody : String -> String -> Http.Body
loginBody username password =
    Http.jsonBody <|
        Encode.object
            [ ( "username", Encode.string username )
            , ( "password", Encode.string password )
            ]


userDecoder : Decode.Decoder User
userDecoder =
    decode User
        |> Json.Decode.Pipeline.required "id" Decode.int
        |> Json.Decode.Pipeline.required "doorLockId" Decode.int
        |> Json.Decode.Pipeline.required "username" Decode.string
