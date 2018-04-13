module Chat.View exposing (..)

import Models exposing (Model, Message)
import Msgs exposing (Msg(..))
import Html exposing ( Html
                     , text
                     , span
                     , div
                     , a
                     , p
                     , i
                     , img
                     , nav
                     , strong
                     , article
                     , section
                     , textarea
                     )
import Html.Attributes exposing ( attribute
                                , class
                                , alt
                                , src
                                , href
                                , placeholder
                                , rows
                                , value
                                )
import Html.Events exposing (onInput, onClick)

view : Model -> Html Msg
view model =
  section []
    [ nav
        [ attribute "aria-label" "main navigation"
        , class "navbar"
        , attribute "role" "navigation"
        ]
        [ div [ class "navbar-brand" ]
          [ a [ class "navbar-item"
              , href "/"
              ]
            [ img [ alt "Bulma: a modern CSS framework based on Flexbox"
                  , attribute "height" "28"
                  , src "/images/logo.png"
                  , attribute "width" "42"
                  ]
              []
            ]
          , div [ class "navbar-burger" ]
            [ span [] []
            , span [] []
            , span [] []
            ]
          ]
        , div [ class "navbar-menu" ]
          [ div [ class "navbar-end" ]
            [ div [ class "navbar-item" ]
              [ p [ class "control" ]
                [ a [ class "button is-danger", href "/"]
                  [span [ class "icon"]
                    [ i [class "fa fa-sign-out"] []]
                  , span [] [text "Logout"]
                  ]
                ]
              ]
            ]
          ]
        ]
      , section [ attribute "style" "height: calc(100vh - 52px);" ]
          [ div [ class "columns is-gapless" ]
                [ div [ class "column is-one-quarter is-hidden-mobile" ]
                      [ p
                        [ attribute "style" "background-color: #eee;height: calc(100vh - 53px);overflow:auto;"
                        ] <| List.map generate_user_item model.people
                      ]
                , div [ class "column" ]
                      [ p
                        [ attribute "style" "margin-top:auto;background-color: #ddd;height: calc(100vh - 100px);overflow:auto;"
                        ] <| List.map generate_message_item model.messages
                      , div [ class "field has-addons" ]
                          [ div [ class "control", attribute "style" "width: 100%" ]
                                [ textarea [ class "textarea", placeholder "Your message...", rows 1, value model.newMessage, onInput NewMessageUpdate ]
                                      []
                                ]
                          , div [ class "control" ]
                              [ a [ class "button is-primary", attribute "style" "height: 46px", onClick SendNewMessage ] [ text "Send" ]
                              ]
                          ]
                      ]
                ]
          ]
      ]


generate_user_item : String -> Html Msg
generate_user_item username =
    div [ class "box", attribute "style" "background-color: #eee;margin: 0;" ]
    [ article [ class "media" ]
        [ div [ class "media-content" ]
            [ div [ class "content" ]
                [ p [ ]
                    [ strong []
                        [ text username ]
                    ]
                ]
            ]
        ]
    ]

generate_message_item : Message -> Html Msg
generate_message_item message =
    div [class "column is-full", attribute "style" "margin: 0;padding:0;" ]
        [ div [ class "box", attribute "style" "background-color: #bbb;margin: 0;" ]
              [ article [ class "media" ]
                    [ div [ class "media-left" ]
                          [ p []
                                [ strong []
                                      [ text <| message.sender ++ ":" ]
                                ]
                          ]
                    , div [ class "media-content" ]
                          [ div [ class "content" ]
                                [ p []
                                      [ text message.content ]
                                ]
                          ]
                    , div [ class "content" ]
                        [ p []
                              [ text message.node ]
                        ]
                    ]
              ]

        ]
