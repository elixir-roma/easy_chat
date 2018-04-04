module Update exposing(..)

import Routing exposing (parseLocation)
import Msgs exposing (Msg(..))
import Models exposing (Model, Login, Credentials)

import Http exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Navigation exposing (newUrl)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NavigateTo url ->
        (model, newUrl url)
    OnLocationChange location ->
      let
        newRoute =
            parseLocation location
      in
        ( { model | route = newRoute }, Cmd.none )
    UpdatePassword password ->
      let
        login : Login
        login = model.login
        newLogin : Login
        newLogin =
          { login | password = password }
      in
        ( { model | login = newLogin }, Cmd.none )
    UpdateRepeatPassword password ->
      let
        login : Login
        login = model.login
        newLogin : Login
        newLogin =
          { login | repeat_password = password }
      in
        ( { model | login = newLogin }, Cmd.none )
    UpdateUsername username ->
      let
        login : Login
        login = model.login
        newLogin : Login
        newLogin =
          { login | username = username }
      in
        ( { model | login = newLogin }, Cmd.none )
    StartSession ->
        ( model, authUserCmd model loginUrl )
    NewUser ->
        ( model, authUserCmd model registerUrl )
    GetTokenCompleted result ->
        getTokenCompleted model result

api: String
api = "/api/"

registerUrl : String
registerUrl =
    api ++ "user"

loginUrl : String
loginUrl =
    api ++ "session"

userEncoder : Model -> Encode.Value
userEncoder model =
    Encode.object
        [ ("username", Encode.string model.login.username)
        , ("password", Encode.string model.login.password)
        ]

tokenDecoder : Decoder Credentials
tokenDecoder =
    Decode.map Credentials
        (Decode.field "access_token" Decode.string)

authUser : Model -> String -> Http.Request Credentials
authUser model apiUrl =
    let
        body =
            model
            |> userEncoder
            |> Http.jsonBody
    in
        Http.post apiUrl body tokenDecoder

authUserCmd : Model -> String -> Cmd Msg
authUserCmd model apiUrl =
    Http.send GetTokenCompleted (authUser model apiUrl)


getTokenCompleted : Model -> Result Http.Error Credentials -> ( Model, Cmd Msg )
getTokenCompleted model result =
    case result of
        Ok credentials ->
          let
            newModel : Model
            newModel =
                { model | access_token = Just credentials.access_token }

            newLogin : Login
            newLogin = Login model.login.username  ""  "" False
          in
            ( { newModel | login = newLogin }, Cmd.none )
        Err error ->
          let
            newLogin : Login
            newLogin = Login model.login.username  ""  "" True
          in
            ( { model | login = newLogin }, Cmd.none )
