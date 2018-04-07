module Models exposing (..)

type alias Model = { route         : Route
                   , login         : Login
                   , access_token  : Maybe String
                   , people        : List String
                   , messages      : List Message
                   , websocketHost : String
                   , newMessage    : String
                   }

type Route
    = LoginRoute
    | ChatRoute
    | SignupRoute
    | NotFoundRoute

type alias Credentials =
    { access_token : String }

type alias Message =
    { sender  : String
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

initialModel : Route -> String -> Model
initialModel route websocketHost
    = Model route initialLogin Nothing [] [] websocketHost ""
