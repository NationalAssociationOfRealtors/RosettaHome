defmodule Rosetta do
    use Application
    require Logger
    alias :mnesia, as: Mnesia

    @name __MODULE__

    defmodule Message do
        defstruct [:id, :type, :data, :ip, :port]
    end

    defmodule Event do
        defstruct [:type, :value, :id]
    end

    def start(_type, _args) do
        {:ok, pid} = Rosetta.Supervisor.start_link
        Movi.add_handler(Rosetta.Voice.Handler)
        train_voice_recognition
        {:ok, pid}
    end

    def train_voice_recognition do
        :timer.sleep(100)
        Movi.callsign(Application.get_env(:movi, :callsign))
        :timer.sleep(100)
        train_list(Application.get_env(:movi, :verbs))
        train_list(Application.get_env(:movi, :combinators))
        train_list(Application.get_env(:movi, :descriptors))
        train_list(Application.get_env(:movi, :locations))
        train_list(Application.get_env(:movi, :things))
        train_list(Application.get_env(:movi, :numbers))
        Movi.trainsentences
    end

    defp train_list(list) do
        Enum.each(list, fn(sentence) ->
            Movi.addsentence(sentence)
            :timer.sleep(100)
        end)
    end

end
