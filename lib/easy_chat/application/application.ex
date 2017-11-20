defmodule EasyChat.Application do
  @moduledoc false

  use Application
  alias Plug.Adapters.Cowboy
  alias EasyChat.Presentation.Router
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(EasyChat.BoundedContext.User.Repository, []),
      Cowboy.child_spec(:http, Router, [], port: 8080)
    ]

    opts = [strategy: :one_for_one, name: EasyChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
