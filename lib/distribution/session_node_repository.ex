defmodule SessionNodeRepository do
  @moduledoc false

  require Logger

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call({:get_all}, _from, state) do
    Logger.info "inner get_all_session : #{inspect(:get_all)}"
    r = EasyChat.BoundedContext.Session.Repository.get_all
    {:reply, r, state}
  end

end
