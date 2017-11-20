module Msgs exposing (..)
import Navigation exposing (Location)
import Http exposing (Error)
import Models exposing (Credentials)

type Msg
    = UpdatePassword String
    | UpdateUsername String
    | UpdateRepeatPassword String
    | StartSession
    | NewUser
    | OnLocationChange Location
    | NavigateTo String
    | GetTokenCompleted (Result Error Credentials)
