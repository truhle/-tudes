defmodule Person do
  use GenServer

  defmodule State do
    defstruct chat_server: :nil
  end

  def start_link(chat_server) do
    GenServer.start_link(__MODULE__, [chat_server], [{:name, {:global, __MODULE__}}])
  end

  def init([chat_server]) do
    {:ok, %State{chat_server: {:Chatroom, chat_server}}}
  end

  def handle_call(request, _from, state) do
    chat_server = state.chat_server
    case request do
      :get_chat_node ->
        {:reply, chat_server, state}
      {:login, user_name} ->
        full_request = {:login, user_name, Node.self}
        GenServer.call(chat_server, full_request)
      :logout ->
        GenServer.call(chat_server, :logout)
      {:say, text} ->
        GenServer.call(chat_server, {:say, text})
    end
  end

  def handle_cast(msg, state) do
    {:message, {from_user, from_server}, text} = msg
    IO.puts("#{from_user} #{from_server}:")
    IO.puts(text)
    {:noreply, state}
  end

  def handle_info(_info, state) do
   {:noreply, state}
 end

 def terminate(_reason, _state) do
   {:ok}
 end

 def code_change(_old_version, state, _extra) do
   {:ok, state}
 end


end
