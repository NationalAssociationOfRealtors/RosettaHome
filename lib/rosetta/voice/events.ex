defmodule Rosetta.Voice.Events do
    use GenEvent
    require Logger
    alias Rosetta.Voice.MoviHandler.VoiceEvent
    @name Application.get_env(:rosetta, :name)

    def handle_event(%VoiceEvent{:locations => [@name]} = event, state) do
        Logger.info @name
        IO.inspect event
        {:ok, state}
    end

    def handle_event(%VoiceEvent{} = event, state) do
        Logger.info "OTHER"
        IO.inspect event
        {:ok, state}
    end

end
