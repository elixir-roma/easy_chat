defmodule NodeRepository do
  @moduledoc false

  require Logger

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


  def handle_call({:fetch, username, password}, _from, state) do
    result = EasyChat.BoundedContext.User.Repository.fetch(%{"username" => username, "password" => password})
    Logger.info "Local result fecth: #{inspect(result)}"
    {:reply, result, state}
  end

  def handle_call({:exist, username}, _from, state) do
    result = EasyChat.BoundedContext.User.Repository.exist(username)
    {:reply, result, state}
  end

  def handle_call({:insert, username, password}, _from, state) do
    result = EasyChat.BoundedContext.User.Repository.insert(%{"username" => username, "password" => password})
    {:reply, result, state}
  end



  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end