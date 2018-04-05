defmodule EasyChat.BoundedContext.Chat.Websocket do
  @moduledoc false

  @session_repository Application.get_env(:easy_chat, :session_repo)
  @message_repository Application.get_env(:easy_chat, :message_repo)
  @auth Application.get_env(:easy_chat, :auth)

  def init(req, _state) do
    {:cowboy_websocket, req, _new_state = %{}, %{:idle_timeout => 60_000 * 20}}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, data}, state) do
    term = Poison.decode!(data)

    case @auth.decode_and_verify(term["jwt"]) do
      {:ok, _claims} ->
         manage_content(term)
        {:ok, state}
      _ ->
        {:ok, state}
    end
  end

  defp manage_content(term) do
    user = @auth.resource_from_token(term["jwt"])
    case term["command"] do
      "join" ->
        @session_repository.insert({user, self()})
        @session_repository.get_all()
        |> Enum.map(fn {_, pid} -> send pid, {:join, user} end)
      "msg" ->
        msg = %{sender: user, content: term["content"]}
        @message_repository.insert(msg)
        @session_repository.get_all
        |> Enum.map(fn {_, pid} -> send pid, {:msg, msg} end)
    end
  end

  def websocket_info({:msg, msg}, state) do
    data = Poison.encode!(Map.put(msg, "command", "msg"))
    {:reply, {:text, data}, state}
  end

  def websocket_info({:join, user}, state) do
    data = Poison.encode!(%{"command" => "user_join", "content" => user})
    {:reply, {:text, data}, state}
  end

  def websocket_info({:leave, user}, state) do
    data = Poison.encode!(%{"command" => "user_leave", "content" => user})
    {:reply, {:text, data}, state}
  end

  def terminate(_reason, _req, _state) do
    {:ok, name} = @session_repository.remove(self())

    @session_repository.get_all()
    |> Enum.each(fn {_, pid} -> send pid, {:leave, name} end)
  end
end
