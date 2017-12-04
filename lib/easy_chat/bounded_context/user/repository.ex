defmodule EasyChat.BoundedContext.User.Repository do

  @moduledoc """
  This module store the users
  """
  def start_link do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def fetch(%{"username" => username, "password" => password}) do
    hash = hash(password)
    case Agent.get(__MODULE__, fn map -> Map.get(map, username) end) do
      ^hash ->
        {:ok, username}
      _ ->
        :error
    end
  end

  def insert(%{"username" => username, "password" => password}) do
    case Agent.get(__MODULE__, fn map -> Map.get(map, username) end) do
      nil ->
        insert_username(username, password)
        {:ok, username}
      _ ->
        :error
    end
  end

  defp hash(password), do: Base.encode64(:crypto.hash(:sha, password))

  defp insert_username(username, password) do
    Agent.update(__MODULE__,
      fn map ->
        Map.put_new_lazy(map, username,
          fn ->
            hash(password)
          end)
      end)
  end
end
