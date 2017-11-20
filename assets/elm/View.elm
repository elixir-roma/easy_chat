module View exposing (..)

import Login.View exposing (..)
import Register.View exposing(view)
import Models exposing (Model)
import Msgs exposing (Msg)
import Html exposing (Html, text, div)

view : Model -> Html Msg
view model =
  case model.route of
    Models.LoginRoute ->
      Login.View.view model.login
    Models.SignupRoute ->
      Register.View.view model.login
    Models.ChatRoute ->
      text ""
    Models.NotFoundRoute ->
      notFoundView

notFoundView : Html msg
notFoundView =
  div []
    [ text "404 - Not found" ]
