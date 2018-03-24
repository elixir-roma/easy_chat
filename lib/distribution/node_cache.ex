defmodule NodeCache do
  @moduledoc false

  require Logger
  def users_status do
    GenServer.call(__MODULE__, :users_status)
  end

  def messages_status do
    GenServer.call(__MODULE__, :messages_status)
  end

  def insert(%{"username" => username, "password" => password}) do
    GenServer.call(__MODULE__, {:insert_to_lower, username, password})
  end

  def fetch(%{"username" => username, "password" => password}) do
    GenServer.call(__MODULE__, {:fetch, username, password})
  end

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    table_type = [
      :set,
      :public,
      :named_table,
      {:write_concurrency, true},
      {:read_concurrency, true}
    ]
    :ets.new(:users_weight, table_type)
    :ets.new(:messages_weight, table_type)
    Process.flag(:trap_exit, true)
    Process.send_after(self(), :update_cache, 1_000)
    {:ok, %{}}
  end

  ######### Users Cache Count ###############################
  def maybe_insert_to_cache({nodename, {:users_count, value}}) do
    :true = :ets.insert(:users_weight, {nodename, :users_count, value})
  end

  def get_users_weight do
    {rep, bad} = GenServer.multi_call(
      [Node.self] ++ Node.list,
      NodeRepository,
      :get_users_weight
    )
    for v <- rep, do: maybe_insert_to_cache(v)
    maybe_nodes_error(bad)
  end

  def maybe_nodes_error([]), do: :true
  def maybe_nodes_error(nodes) do
    Logger.error "Bad respose from nodes: #{inspect(nodes)}"
    {:error, nodes}
  end
  ##########################################################

  ###### Login user ########################################
  def fetch_user(username, password) do
    {rep, bad} = GenServer.multi_call(
      [Node.self] ++ Node.list,
      NodeRepository,
      {:fetch, username, password}
    )
    maybe_nodes_error(bad)
    is_valid_user? Enum.filter(rep, fn ({_, respose}) -> respose != :error end)
  end
  ##########################################################

  def is_valid_user?([]), do: :error
  def is_valid_user?(l) when is_list(l) do
    {_, {:ok, username}} = List.first(l)
    {:ok, username} end

  ###### Insert user to DB #################################
  def user_exist(username) do
    {rep, bad} =
      GenServer.multi_call([Node.self] ++ Node.list,
        NodeRepository, {:exist, username})
    maybe_nodes_error(bad)
    maybe_exist? Enum.filter(rep, fn ({_, value}) -> value != :false end)
  end

  def maybe_exist?([]), do: :false
  def maybe_exist?(l) when is_list(l) do
    :true end

  def maybe_insert_into_db?(:true, _, _, _), do: :exist
  def maybe_insert_into_db?(:false, node_destination, username, password) do
    {rep, bad} = GenServer.multi_call(
      [node_destination],
      NodeRepository,
      {:insert, username, password}
    )
    maybe_nodes_error(bad)
    is_valid_user? rep
  end
  ##########################################################

  ###### GenServer Handle ##################################
  def handle_info(:update_cache, state) do
    Process.send_after(self(), :update_cache, 5_000)
    get_users_weight()
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
    sort_by_weight = Enum.sort(
      :ets.tab2list(:users_weight),
      fn ({_, _, value}, {_, _, valuey}) -> valuey > value end
    )
    {node_destination, _, _} = List.first(sort_by_weight)

    result = maybe_insert_into_db?(
      user_exist(username),
      node_destination,
      username,
      password
    )

    Logger.info "Insert to lower result: #{inspect(result)}"
    {:reply, result, state}
  end

  def handle_call({:fetch, username, password}, _from, state) do
    result = fetch_user(username, password)
    Logger.info "Cluster fecth result : #{inspect(result)}"
    {:reply, result, state}
  end

  def handle_call(:messages_status, _from, state) do
    w = :ets.tab2list(:messages_weight)
    {:reply, w, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end
