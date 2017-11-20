defmodule EasyChat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, EasyChat.Router, [], port: 8080)
    ]

    opts = [strategy: :one_for_one, name: EasyChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
