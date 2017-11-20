module Main exposing (..)

import Models exposing (Model, initialModel, Route(..))
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Update exposing (update)
import View exposing (view)
import WebSocket exposing (listen)
import Time 
type alias Flags =
  { websocketHost : String }

init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute = LoginRoute
    in
        ( initialModel currentRoute flags.websocketHost, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.route of
        ChatRoute ->
            Sub.batch [ listen model.websocketHost WsMessage
                      , Time.every (Time.second * 30) Heartbeat
                      ]
        _ ->
            Sub.none

main : Program Flags Model Msg
main = 
    Navigation.programWithFlags Msgs.OnLocationChange
        { init          = init
        , view          = view
        , update        = update
        , subscriptions = subscriptions
        }

