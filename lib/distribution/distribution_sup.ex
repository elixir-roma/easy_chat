defmodule DistributionSup.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(NodeCache, [], restart: :permanent),
      worker(NodeRepository, [], restart: :permanent)
    ]

    supervise(children, strategy: :one_for_one)
  end

end
