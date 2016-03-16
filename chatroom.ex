defmodule Chatroom do
  use GenServer

  defmodule State do
    defstruct users: []
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  def init([]) do
    {:ok, %State{users: []}}
  end

  def handle_call(request, from, state) do
    {pid, _} = from
    users = state.users
    case request do
      {:login, user_name, server_name} ->
        user = {user_name, server_name}
        IO.puts("#{user_name}@#{server_name} logging in from #{inspect pid}")
        name_taken? = List.keymember?(users, user, 0)
        reply = case name_taken? do
          true ->
            {:error, "#{user_name} already logged in on this server"}
          false ->
            {:ok, "Logging #{user_name} in"}
        end
        case reply do
          {:error, _} ->
            {:reply, reply, state}
          {:ok, _} ->
            new_state = %State{users: [{user, pid} | users]}
            {:reply, reply, new_state}
        end
      :logout ->
        user = List.keyfind(users, pid, 1)
        new_state = %State{users: List.delete(users, user)}
        reply = {:ok, "#{inspect pid} logged out"}
        {:reply, reply, new_state}
      {:say, text} ->
        user = List.keyfind(users, pid, 1)
        other_users = List.delete(users, user)
        {{user_name, server_name}, _pid} = user
        Enum.each(other_users, fn({_, to_pid}) ->
          GenServer.cast(to_pid, {:message, {user_name, server_name}, text})
        end)
        reply = {:ok, "Message sent"}
        {:reply, reply, state}
      :users ->
        user_list = List.foldl(users, [], fn (user, acc) ->
          {user_tuple, _} = user
          [user_tuple | acc]
        end)
        {:reply, {:ok, user_list}, state}
    end
  end

  def handle_cast(msg, state) do
    {:noreply, state}
  end
end
