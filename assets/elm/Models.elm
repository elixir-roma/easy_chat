module Models exposing (..)

type alias Model = { route : Route
                   , login : Login
                   , access_token : Maybe String
                   , people : List String
                   , messages: List Message
                   }

type Route
    = LoginRoute
    | ChatRoute
    | SignupRoute
    | NotFoundRoute

type alias Credentials =
    { access_token : String }

type alias Message =
    { username : String
    , content : String
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
    = Model route initialLogin Nothing ["An User"] [ Message "An User" "My first message"]
