module Msgs exposing (..)
import Navigation exposing (Location)
import Http exposing (Error)
import Models exposing (Credentials, Message)
import Jwt exposing (JwtError)

type Msg
    = UpdatePassword String
    | UpdateUsername String
    | UpdateRepeatPassword String
    | StartSession
    | NewUser
    | OnLocationChange Location
    | NavigateTo String
    | GetTokenCompleted (Result Error Credentials)
    | WsMessage String
    | UsersFetched (Result JwtError (List String))
    | MessagesFetched (Result JwtError (List Message))
    | NewMessageUpdate String
    | SendNewMessage
