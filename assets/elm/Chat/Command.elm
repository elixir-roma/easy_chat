module Chat.Command exposing (..)

import Models exposing (Message, Model, WsMessageFromServer)
import Msgs exposing (Msg(..))
import Json.Decode as Decode
import Json.Encode as Encode
import Jwt exposing (JwtError)
import List
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
            Encode.object
                [ ("jwt", Encode.string access_token)
                , ("command", Encode.string "msg")
                , ("content", Encode.string model.newMessage)
                ]
            |> Encode.encode 0
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
    case Decode.decodeString decodeWsMessage wsMessage of
        Ok wsMessageFromServer ->
            case wsMessageFromServer.command of
                "msg" ->
                    let
                        message : Message
                        message = Message wsMessageFromServer.sender wsMessageFromServer.content
                        messages : List Message
                        messages = List.append model.messages [message]
                    in
                        Debug.log "It's a message"
                        ({model | messages = messages}, Cmd.none)
                "user_join" ->
                    let
                        people : List String
                        people = List.append model.people [wsMessageFromServer.content]
                    in
                        Debug.log "It's a join"
                        ({model | people = people}, Cmd.none)
                _ ->
                    Debug.log "It's a wsMessage"
                    (model, Cmd.none)
        Err error ->
            Debug.log "It isn't a wsMessage"
            (model, Cmd.none)

decodeWsMessage : Decode.Decoder WsMessageFromServer
decodeWsMessage =
    Decode.map3 WsMessageFromServer
        (Decode.field "command" Decode.string)
        (Decode.field "content" Decode.string)
        (Decode.oneOf [ (Decode.field "sender" Decode.string)
                      , Decode.succeed ""
                      ]
        )
