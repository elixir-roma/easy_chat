defmodule EasyChat.BoundedContext.Session.Repository do
  @moduledoc false

  def start_link do
    Agent.start_link(&Map.new/0, name: __MODULE__)
  end

  def insert({username, pid}) do
    Agent.update(__MODULE__, &(Map.put(&1, username, pid)))
  end

  def remove(pid) do
    case find(pid) do
      {user, _} ->
        delete(pid)
        {:ok, user}
      nil ->
        {:ok, nil}
    end
  end

  defp delete(pid) do
    Agent.update __MODULE__, fn map ->
      map
      |> Enum.filter(fn {_, user_pid} -> pid != user_pid end)
      |> Enum.into(%{})
    end
  end

  defp find(pid) do
    Agent.get(__MODULE__, fn map ->
      map
      |> Enum.find(fn {_, this_pid} -> this_pid == pid end)
    end)
  end

  def get_all, do: Agent.get(__MODULE__, &Map.to_list/1)
end
