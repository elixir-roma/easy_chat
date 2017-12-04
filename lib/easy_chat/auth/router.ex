defmodule EasyChat.Auth.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.Auth.PostSession
  alias EasyChat.Auth.DeleteSession
  alias EasyChat.Auth.PutSession

  plug :match

  plug Guardian.Plug.Pipeline, module: EasyChat.Auth.Guardian
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug :dispatch

  post "/session", to: PostSession
  delete "/session", to: DeleteSession
  put "/refresh", to: PutSession, init_opts: [type: "refresh"]
end
