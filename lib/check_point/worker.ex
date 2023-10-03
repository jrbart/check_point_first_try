defmodule CheckPoint.Worker do
  use GenServer

  # Client API
  def start_link(%{fn: check_function} = default) when is_function(check_function) do
    GenServer.start_link(__MODULE__, default)
  end

  # Callbacks

  # the initialization showld quckly return so the engine can move on to 
  # initializing the rest of the checks.
  @impl true
  def init(init_list) do
    IO.puts("init")
    IO.inspect(init_list)
    {:ok, init_list, {:continue, :start}}
  end

  # call the check function and wait for the results
  @impl true
  def handle_call(_request, from, state) do
    IO.puts("call")
    IO.inspect(state)
    {:reply, from, state}
  end

  # the main loop will run the check funtion that was passed
  # in and record the result.  Then if the result was not :ok
  # it should notify the alert handler.  If everything was ok
  # then it should send_after to wake up later
  @impl true
  def handle_cast(_request, state) do
    IO.puts("cast")
    IO.inspect(state)
    %{fn: check_fn, arg: arg} = state
    IO.inspect(check_fn.(arg))
    {:noreply, state} 
  end

  # this will be used to change the status level
  # normally the level will be :up
  # if a check fails, the level will change to :warn
  # and the frequency of the check will be increased
  # after a number of failures the level will change to :down
  # and the frequency will back off so it doesn't flood
  # something that is already having problems
  @impl true
  def handle_info(_msg, state) do
    IO.puts("info")
    IO.inspect(state)
    {:noreply, state}
  end
    
  # continue with any setup that needs to be done on init
  @impl true
  def handle_continue(continue_arg, state) do
    Process.sleep(1000)
    IO.inspect(continue_arg)
    IO.inspect(state)
    IO.puts("continue")
    {:noreply, state}
  end

end
