defmodule Rosetta.VoiceEvents do
    use GenEvent
    require Logger

    def start_link() do
        GenEvent.start_link([{:name, __MODULE__}])
    end

end
