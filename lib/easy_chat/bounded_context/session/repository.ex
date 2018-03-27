defmodule EasyChat.BoundedContext.Session.Repository do
  @moduledoc false

  def start_link do
    Agent.start_link(&Map.new/0, name: __MODULE__)
  end

  def insert({username, pid}) do
    Agent.update(__MODULE__, &(Map.put(&1, username, pid)))
  end

  def remove(pid) do
    Agent.update __MODULE__, fn map ->
      Enum.filter(map, fn {_, user_pid} -> pid != user_pid end)
      |> Enum.into(%{})
    end
  end

  def get_all, do: Agent.get(__MODULE__, &Map.to_list/1)
end
