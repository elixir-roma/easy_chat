import Html exposing (div, text, h1, p, hr)
import Html.Attributes exposing (class)

main =
  div [ class "jumbotron jumbotron-fluid" ]
    [ div [ class "container" ]
        [ h1 [ class "display-3" ]
            [ text "Hello World!" ]
        , hr [] []
        , p [ class "lead" ]
            [ text "This is just a test." ]
        ]
    ]
