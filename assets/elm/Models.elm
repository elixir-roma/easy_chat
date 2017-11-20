module Models exposing (..)

type alias Model = { route : Route
                   , login : Login
                   , refresh_token : Maybe String
                   , access_token : Maybe String
                   }

type Route
    = LoginRoute
    | ChatRoute
    | SignupRoute
    | NotFoundRoute

type alias Credentials =
    { access_token : String
    , refresh_token : String
    }

type alias Login = { username : String
                   , password : String
                   , repeat_password : String
                   , error    : Bool
                   }

initialLogin : Login
initialLogin =
    Login "" "" "" False

initialModel : Route -> Model
initialModel route
  = Model route initialLogin Nothing Nothing
