defmodule EasyChat.BoundedContext.Chat.Websocket do
  @moduledoc false
  @behaviour :cowboy_websocket_handler

  @session_repository Application.get_env(:easy_chat, :session_repo)
  @message_repository Application.get_env(:easy_chat, :message_repo)
  @auth Application.get_env(:easy_chat, :auth)

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  @timeout 60_000

  def websocket_init(_type, req, _opts) do
    state = %{}
    {:ok, req, state, @timeout}
  end

  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:text, data}, req, state) do
    term = Poison.decode!(data)

    case @auth.decode_and_verify(term["jwt"]) do
      {:ok, _claims} ->
         manage_content(term)
        {:ok, req, state}
      _ ->
        {:ok, req, state}
    end
  end

  defp manage_content(term) do
    {:ok, user, _} = @auth.resource_from_token(term["jwt"])
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

  def websocket_info({:msg, msg}, req, state) do
    data = Poison.encode!(Map.put(msg, "command", "msg"))
    {:reply, {:text, data}, req, state}
  end

  def websocket_info({:join, user}, req, state) do
    data = Poison.encode!(%{"command" => "user_join", "content" => user})
    {:reply, {:text, data}, req, state}
  end

  def websocket_info({:leave, user}, req, state) do
    data = Poison.encode!(%{"command" => "user_leave", "content" => user})
    {:reply, {:text, data}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    case @session_repository.remove(self()) do
      {:ok, name} ->
        @session_repository.get_all()
        |> Enum.each(fn {_, pid} -> send pid, {:leave, name} end)
      _ ->
        :ok
    end
  end
end
