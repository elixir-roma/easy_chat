module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (Model, Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map SignupRoute (s "sign-up")
        , map ChatRoute (s "chat")
        ]


parseLocation : Model -> Location -> Route
parseLocation model location =
    case (parseHash matchers location) of
        Just route ->
            case route of
                ChatRoute ->
                    if model.access_token == Maybe.Nothing then
                        LoginRoute
                    else
                        ChatRoute
                _ ->
                    route

        Nothing ->
            NotFoundRoute
