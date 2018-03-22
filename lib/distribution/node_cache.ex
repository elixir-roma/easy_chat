defmodule NodeCache do
  @moduledoc false




  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_opts) do
    Process.send_after(self(), :update_cache, 1_000)
    users_weight = :ets.new(:users_weight, [:set, :protected])
    messages_weight = :ets.new(:users_weight, [:set, :protected])
    {:ok, {users_weight, messages_weight}}
  end

  def handle_info(:update_cache,  {users_weight, messages_weight}) do
    Process.send_after(self(), :update_cache, 6_000)
    ### update the tables chace here...
    {:noreply, {users_weight, messages_weight}}
  end
  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end