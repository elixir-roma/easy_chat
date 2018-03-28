defmodule EasyChat.BoundedContext.Chat.Websocket do

  @session_repository Application.get_env(:easy_chat, :session_repo)
  @auth Application.get_env(:easy_chat, :auth)

  def init(req, _state) do
    {:cowboy_websocket, req, _newState = %{}, %{:idle_timeout => 60000 * 20}}
  end

  def websocket_init(state) do
    {:ok, state}
  end

  def websocket_handle({:text, data}, state) do
    term = Poison.decode!(data)

    case @auth.decode_and_verify(term["jwt"]) do
      {:ok, _} ->
        case term["command"] do
          "join" ->
            @session_repository.insert(
              {@auth.resource_from_token(term["jwt"]), self()}
            )
        end
        {:ok, state}
      _ ->
        {:ok, state}
    end
  end

  def websocket_info({:msg, msg}, state) do
    data = Poison.encode!(msg)
    {:reply, {:text, data}, state}
  end

  def terminate(_reason, _req, state) do
    {:ok, _name} = ChatRoom.remove_client(state.room.pid, self())
    :ok
  end
end
