module Chat.View exposing (..)

import Models exposing (Model)
import Msgs exposing (Msg)
import Html exposing ( Html
                     , text
                     , span
                     , div
                     , a
                     , p
                     , i
                     , img
                     , nav
                     , section
                     )
import Html.Attributes exposing ( attribute
                                , class
                                , alt
                                , src
                                , href
                                )

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
              , href "https://bulma.io"
              ]
            [ img [ alt "Bulma: a modern CSS framework based on Flexbox"
                  , attribute "height" "28"
                  , src "https://bulma.io/images/bulma-logo.png"
                  , attribute "width" "112"
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
                [ a [ class "button is-danger", href "/logout"]
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
                [ div [ class "column is-one-third is-hidden-mobile" ]
                      [ p
                        [ attribute "style" "background-color: #eee;height: calc(100vh - 52px);"
                        ] [ text "text" ] ]
                , div [ class "column" ]
                      [ p
                        [ attribute "style" "background-color: #ddd;height: calc(100vh - 52px);"
                        ] [ text "text" ] ]
                ]
          ]
      ]
