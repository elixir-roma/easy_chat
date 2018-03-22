defmodule NodeRepository do
  @moduledoc false
  


  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call(:get_users_weight, _from, state) do
    {:reply, EasyChat.BoundedContext.User.Repository.count(), state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end