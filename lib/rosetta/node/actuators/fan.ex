defmodule Rosetta.Node.Actuator.Fan do
    use GenEvent
    alias Rosetta.Event

    def handle_event(_event = %Event{}, state) do
        {:ok, state}
    end
end
