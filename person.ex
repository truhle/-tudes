defmodule Person do
  use GenServer

  defmodule State do
    defstruct chat_server: :nil
  end

  def start_link(chat_server) do
    GenServer.start_link(__MODULE__, [chat_server], [{:name, __MODULE__}])
  end

  def init([chat_server]) do
    {:ok, %State{chat_server: {Chatroom, chat_server}}}
  end

  def handle_call(request, _from, state) do
    chat_server = state.chat_server
    case request do
      :get_chat_node ->
        {:reply, chat_server, state}
      {:login, user_name} ->
        full_request = {:login, user_name, Node.self}
        GenServer.call(chat_server, full_request)
        {:reply, "Sent login request", state}
      :logout ->
        reply = GenServer.call(chat_server, :logout)
        {:reply, reply, state}
      {:say, text} ->
        reply = GenServer.call(chat_server, {:say, text})
        {:reply, reply, state}
    end
  end

  def handle_cast(msg, state) do
    {:message, {from_user, from_server}, text} = msg
    IO.puts("#{from_user}@#{from_server} says: ")
    IO.puts(text)
    {:noreply, state}
  end

  def get_chat_node do
    GenServer.call(Person, :get_chat_node)
  end

  def login(user_name) when is_atom(user_name) do
    GenServer.call(Person, {:login, Atom.to_string(user_name)})
  end

  def login(user_name) do
    GenServer.call(Person, {:login, user_name})
  end

  def logout do
    GenServer.call(Person, :logout)
  end

  def say(text) do
    GenServer.call(Person, {:say, text})
  end

  def users do
    GenServer.call(Person.get_chat_node, :users)
  end


end
