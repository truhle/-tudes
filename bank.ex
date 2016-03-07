defmodule Bank do
  require Logger

  def account(balance) do
    atm(balance)
  end

  def atm(balance) do
    action = IO.gets("D)eposit, W)ithdraw, B)alance, Q)uit: ")
             |> String.strip() |> String.at(0) |> String.upcase()
    case action do
      "D" ->
        amount = get_number("Amount to deposit: ")
        handle_transaction("D", amount, balance)
      "W" ->
        amount = get_number("Amount to withdraw: ")
        handle_transaction("W", amount, balance)
      "B" ->
        IO.puts("Your current balance is $#{balance}")
        Logger.info("Balance inquiry $#{balance}")
        atm(balance)
      "Q" ->
        nil
    end
  end

  defp handle_transaction(action, amount, balance) when amount >= 0 do
    new_balance = case action do
      "D" when amount >= 15000 ->
        IO.puts("Your deposit of $#{amount} may be subject to hold.")
        Logger.warn("Large deposit $#{amount}")
        amount + balance
      "D" ->
        Logger.info("Successful deposit $#{amount}")
        amount + balance
      "W" ->
        cond do
          balance - amount < 0 ->
            IO.puts("You cannot withdraw more than your current balance of $#{balance}")
            Logger.error("Overdraw $#{amount} from $#{balance}")
            balance
          true ->
            Logger.info("Successful withdrawl $#{amount}")
            balance - amount
        end
    end
    IO.puts("Your new balance is $#{new_balance}")
    atm(new_balance)
  end

  defp handle_transaction(action, amount, balance) when amount < 0 do
    type = case action do
      "D" -> "Deposit"
      "W" -> "Withdrawl"
    end
    IO.puts("#{type}s may not be less than zero")
    Logger.error("Negative #{String.downcase(type)} amount $#{amount}")
    atm(balance)
  end

  def get_number(prompt) do
    input = IO.gets(prompt) |> String.strip
    cond do
      Regex.match?(~r/^[+-]?\d+$/, input) ->
        String.to_integer(input)
      Regex.match?(~r/^[+-]?\d+\.\d+([Ee][+-]?\d+)?$/, input) ->
        String.to_float(input)
      true ->
        :error
    end
  end
end
