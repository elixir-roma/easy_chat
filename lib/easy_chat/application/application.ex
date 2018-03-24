defmodule EasyChat.Application do
  @moduledoc false

  use Application
  alias Plug.Adapters.Cowboy
  alias EasyChat.Presentation.Router
  import Supervisor.Spec

  def start(_type, _args) do
    http_port = case System.get_env("HTTP_PORT") do
      nil -> 8080
      value -> {res, _} = Integer.parse(value)
               res
    end

    children = [
      worker(EasyChat.BoundedContext.User.Repository, []),
      Cowboy.child_spec(:http, Router, [], port: http_port)
    ]

    opts = [strategy: :one_for_one, name: EasyChat.Supervisor]
    DistributionSup.Supervisor.start_link()
    Supervisor.start_link(children, opts)
  end
end
