defmodule UserNodeRepository do
  @moduledoc false

  require Logger
  alias EasyChat.BoundedContext.User.Repository, as: RepUser

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(:get_users_weight, _from, state) do
    {:reply, RepUser.count(), state}
  end

  def handle_call({:fetch, username, password}, _from, state) do
    result = RepUser.fetch(%{"username" => username, "password" => password})
    Logger.info "Local result fecth: #{inspect(result)}"
    {:reply, result, state}
  end

  def handle_call({:exist, username}, _from, state) do
    result = RepUser.exist(username)
    {:reply, result, state}
  end

  def handle_call({:insert, username, password}, _from, state) do
    result = RepUser.insert(%{"username" => username, "password" => password})
    {:reply, result, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
