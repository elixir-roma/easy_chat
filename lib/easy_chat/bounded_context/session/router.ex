defmodule EasyChat.BoundedContext.Session.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Session.PostSession
  alias EasyChat.BoundedContext.Session.PutSession
  alias EasyChat.BoundedContext.Session.CgetSession
  alias EasyChat.BoundedContext.Session.Guardian, as: ECGuardian
  alias EasyChat.BoundedContext.Session.ErrorHandler, as: EH

  plug :match

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  post "/", to: PostSession

  plug Guardian.Plug.Pipeline, module: ECGuardian,
    error_handler: EH
  plug Guardian.Plug.EnsureAuthenticated

  get "/", to: CgetSession

  plug :dispatch
end
