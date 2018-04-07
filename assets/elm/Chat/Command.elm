module Chat.Command exposing (..)

import Models exposing (Message, Model)
import Msgs exposing (Msg(..))
import Json.Decode as Decode
import Json.Encode as Encode
import Jwt exposing (JwtError)
import Debug

api: String
api = "/api/"

usersUrl : String
usersUrl =
    api ++ "session"

messagesUrl : String
messagesUrl =
    api ++ "message"

userDecoder : Decode.Decoder (List String)
userDecoder =
    Decode.list Decode.string

fetchUsers : String -> Cmd Msg
fetchUsers access_token =
    Jwt.get access_token usersUrl userDecoder
    |> Jwt.send UsersFetched

messagesDecoder : Decode.Decoder (List Message)
messagesDecoder =
    Decode.list messageDecoder

fetchMessages : String -> Cmd Msg
fetchMessages access_token =
    Jwt.get access_token messagesUrl messagesDecoder
    |> Jwt.send MessagesFetched

messageDecoder : Decode.Decoder Message
messageDecoder =
    Decode.map2 Message
        (Decode.field "sender" Decode.string)
        (Decode.field "content" Decode.string)

getUsersCompleted : Model -> Result JwtError (List String) -> ( Model, Cmd Msg )
getUsersCompleted model result =
    case result of
        Ok users ->
          let
            newModel : Model
            newModel =
                { model | people = users }
          in
            (newModel, Cmd.none)
        Err error ->
            ( model, Cmd.none )

getMessagesCompleted : Model -> Result JwtError (List Message) -> ( Model, Cmd Msg )
getMessagesCompleted model result =
    case result of
        Ok messages ->
          let
            newModel : Model
            newModel =
                { model | messages = messages }
          in
            (newModel, Cmd.none)
        Err error ->
            ( model, Cmd.none )

generateMessage : Model -> String
generateMessage model =
    case model.access_token of
        Just access_token ->
            "{\"jwt\": \"" ++ access_token ++ "\", \"command\": \"msg\", \"content\": \"" ++ model.newMessage ++ "\"}"
        Nothing ->
            ""
generateJoinChatMessage : String -> String
generateJoinChatMessage access_token =
    Encode.object
        [ ("jwt", Encode.string access_token)
        , ("command", Encode.string "join")
        ]
    |> Encode.encode 0

parseWebsocketMessage : Model -> String -> (Model, Cmd Msg)
parseWebsocketMessage model wsMessage =
    Debug.log wsMessage
    (model, Cmd.none)
