defmodule NodeCache do
  @moduledoc false




  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_opts) do
    :ets.new(:users_weight, [:set, :public, :named_table])
    :ets.new(:messages_weight, [:set, :public, :named_table])
    Process.flag(:trap_exit, true)
    IO.puts "init"
    Process.send_after(self(), :update_cache, 1_000)
    {:ok, %{}}
  end

  def maybe_insert({nodename, {:users_count, value}}) do
    :true = :ets.insert(:users_weight, {nodename, :users_count, value})
  end

  def call() do
    {rep, bad} = GenServer.multi_call([Node.self] ++ Node.list, NodeRepository, :get_users_weight)
    reply_nodes(rep)
    error_nodes(bad)
  end

  def reply_nodes(nodes) do
    for v <- nodes, do: maybe_insert(v)
  end

  def error_nodes(nodes) do
    {:error, nodes}
  end

  def handle_info(:update_cache, state) do
    Process.send_after(self(), :update_cache, 5_000)
    ### update the tables chace here...
    spawn_link(__MODULE__, :call, [])
    {:noreply, state}
  end
  def handle_info({:EXIT, _pid, _reason}, state) do

    {:noreply, state}
  end


  def handle_call(:status, _from, state) do


    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end