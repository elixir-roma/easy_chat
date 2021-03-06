defmodule MessageNodeRepository do
  @moduledoc false

  use GenServer
  alias EasyChat.BoundedContext.Chat.Repository, as: MessageRepository

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call({:insert_message, msg}, _from, state) do
    r = MessageRepository.insert_c(msg)
    {:reply, r, state}
  end

  def handle_call(:get_messages_weight, _from, state) do
    {:reply, MessageRepository.count(), state}
  end

  def handle_call({:get_all}, _from, state) do
    r = MessageRepository.get_all_c
    {:reply, r, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
