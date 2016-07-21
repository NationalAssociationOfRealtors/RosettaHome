defmodule Rosetta.Voice.Handler do
    use GenEvent
    require Logger
    alias Movi.Event

    @verbs Application.get_env(:movi, :verbs)
    @combinators Application.get_env(:movi, :combinators)
    @descriptors Application.get_env(:movi, :descriptors)
    @locations Application.get_env(:movi, :locations)
    @things Application.get_env(:movi, :things)
    @numbers Application.get_env(:movi, :numbers)

    def handle_event(event = %Event{:message => message}, state) when message != nil do
        IO.inspect event
        acc = %{:verbs => [], :combinators => [], :descriptors => [], :locations => [], :things => [], :numbers => []}
        new_acc = Enum.reduce(message, acc, fn(word, acc) ->
            cond do
                Enum.any?(@verbs, fn(x) -> x == word end) ->
                    %{acc | :verbs => List.insert_at(acc.verbs, -1, word)}
                Enum.any?(@combinators, fn(x) -> x == word end) ->
                    %{acc | :combinators => List.insert_at(acc.combinators, -1, word)}
                Enum.any?(@descriptors, fn(x) -> x == word end) ->
                    %{acc | :descriptors => List.insert_at(acc.descriptors, -1, word)}
                Enum.any?(@locations, fn(x) -> x == word end) ->
                    %{acc | :locations => List.insert_at(acc.locations, -1, word)}
                Enum.any?(@things, fn(x) -> x == word end) ->
                    %{acc | :things => List.insert_at(acc.things, -1, word)}
                Enum.any?(@numbers, fn(x) -> x == word end) ->
                    %{acc | :numbers => List.insert_at(acc.numbers, -1, word)}
                true ->
                    acc
            end
        end)
        new_acc |> IO.inspect
        {:ok, state}
    end

end
