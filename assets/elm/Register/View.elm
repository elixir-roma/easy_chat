module Register.View exposing (view)

import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Models exposing (Login)
import Json.Decode as Decode
import Html exposing (Html
                     , p
                     , section
                     , div
                     , h3
                     , input
                     , form
                     , img
                     , text
                     , label
                     , button
                     , a
                     , figure)
import Html.Attributes exposing (class
                                , src
                                , attribute
                                , placeholder
                                , type_
                                , href
                                , value)

view : Login -> Html Msg
view login =
  section [ class "hero is-success is-fullheight login" ]
    [ if login.error then
          div [ class "notification is-danger"]
            [ button [class "delete"] []
            , text "Something went wrong..."
            ]
      else
          text ""
    , div [ class "hero-body" ]
        [ div [ class "container has-text-centered" ]
          [ div [ class "column is-4 is-offset-4" ]
              [ h3 [ class "title has-text-grey" ]
                [ text "Sign up" ]
              , p [ class "subtitle has-text-grey" ]
                [ text "Choose an username and a password to continue." ]
              , div [ class "box" ]
                [ loginAvatar
                , loginForm login
                ]
              , subMenu
              ]
          ]
        ]
    ]

loginAvatar : Html Msg
loginAvatar =
  figure [ class "avatar" ]
    [ img [ src "https://placehold.it/128x128" ]
        []
    ]

subMenu : Html Msg
subMenu =
  p [ class "has-text-grey" ]
    [ a [ href "/"
        , onWithOptions "click"
            { stopPropagation = True
            , preventDefault = True
            }
            <| Decode.succeed
            <| NavigateTo "/"
        ]
        [ text "Sign In" ]
    ]

loginForm : Login -> Html Msg
loginForm login =
  form []
    [ div [ class "field" ]
      [ div [ class "control" ]
          [ input [ attribute "autofocus" ""
                  , class <| "input is-large" ++ if login.error then " is-danger" else ""
                  , placeholder "Your Username"
                  , onInput UpdateUsername
                  , value login.username
                  ]
            []
          ]
      ]
    , div [ class "field" ]
      [ div [ class "control" ]
        [ input [ class <| "input is-large" ++ if login.error then " is-danger" else ""
                , placeholder "Your Password"
                , type_ "password"
                , onInput UpdatePassword
                , value login.password
                ]
            []
        ]
      ]
    , div [ class "field" ]
      [ div [ class "control" ]
        [ input [ class <| "input is-large" ++ if login.error then " is-danger" else ""
                , placeholder "Repeat Password"
                , type_ "password"
                , onInput UpdateRepeatPassword
                , value login.repeat_password
                ]
            []
        ]
      ]
    , button [ class "button is-block is-info is-large is-fullwidth"
             , onWithOptions "click"
                 { stopPropagation = True
                 , preventDefault = True
                 }
                   <| Decode.succeed
                   <| NewUser
             ]
      [ text "Login" ]
    ]
