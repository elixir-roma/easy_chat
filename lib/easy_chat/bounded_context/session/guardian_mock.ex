defmodule EasyChat.BoundedContext.Session.GuardianMock do
  @moduledoc false

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  ## Mock helpers
  def subscribe do
    GenServer.call(__MODULE__, :subscribe)
  end

  def stub(return_value) do
    GenServer.call(__MODULE__, {:stub, return_value})
  end

  def init(_) do
    {:ok, {[], nil}}
  end

  ## Mock callbacks
  def handle_call({:stub, stubbed_response}, _from, {listeners, responses}) do
    {:reply, :ok, {listeners, [stubbed_response|responses]}}
  end
  def handle_call(:subscribe, {pid, _}, {listeners, stubbed_response}) do
    {:reply, :ok, {[pid | listeners], stubbed_response}}
  end

  def handle_call({:side_effect, message}, _from, {listeners, _} = state) do
    send_to_listeners(listeners, message)
    {:reply, :ok, state}
  end

  def handle_call(:stubbed, _from, {listeners, [stubbed_response|rest]}) do
    {:reply, stubbed_response, {listeners, rest}}
  end

  def decode_and_verify(_) do
    GenServer.call(__MODULE__, :stubbed)
  end

  def resource_from_token(_) do
    GenServer.call(__MODULE__, :stubbed)
  end

  defp send_to_listeners(listeners, message) do
    for listener <- listeners do
      send(listener, {message, __MODULE__})
    end
  end
end
