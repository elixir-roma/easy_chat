defmodule NodeCache do
  @moduledoc false


  def users_status() do
    GenServer.call(__MODULE__, :users_status)
  end

  def messages_status() do
    GenServer.call(__MODULE__, :messages_status)
  end

  def insert(username, password) do
    GenServer.call(__MODULE__, {:insert_to_lower, username, password})
  end


  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
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
    spawn_link(__MODULE__, :call, [])
    {:noreply, state}
  end
  def handle_info({:EXIT, _pid, _reason}, state) do

    {:noreply, state}
  end

  def handle_call(:users_status, _from, state) do
    w = :ets.tab2list(:users_weight)
    {:reply, w, state}
  end

  def handle_call({:insert_to_lower, username, password}, _from, state) do

    s = Enum.sort(
      :ets.tab2list(:users_weight),
      fn ({_, _, value}, {_, _, valuey}) -> valuey > value end
    )
    {node, _, _} = List.first(s)
    IO.puts "lower: #{inspect(node)}"
    case EasyChat.BoundedContext.User.Repository.exist(username) do
      :true ->
        {:reply, :exist, state}
      :false ->
        r = :rpc.call(
          node,
          EasyChat.BoundedContext.User.Repository,
          :insert,
          [%{"username" => username, "password" => password}]
        )
        IO.puts "result: #{inspect(r)}"
        {:reply, r, state}
    end


  end

  def handle_call(:messages_status, _from, state) do
    w = :ets.tab2list(:messages_weight)
    {:reply, w, state}
  end


  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end