defmodule EasyChat.Application do
  @moduledoc false

  use Application
  alias Plug.Adapters.Cowboy
  alias EasyChat.Router

  def start(_type, _args) do
    children = [
      Cowboy.child_spec(:http, Router, [], port: 8080)
    ]

    opts = [strategy: :one_for_one, name: EasyChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
