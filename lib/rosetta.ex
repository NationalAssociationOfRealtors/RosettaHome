defmodule Rosetta do
    use Application
    require Logger
    alias Rosetta.VoiceEvents

    def start(_type, _args) do
        {:ok, pid} = Rosetta.Supervisor.start_link
        Movi.Client.add_handler(Rosetta.Voice.MoviHandler)
        GenEvent.add_mon_handler(VoiceEvents, Rosetta.Voice.Events, [])
        #train_voice_recognition
        {:ok, pid}
    end

    def train_voice_recognition do
        :timer.sleep(100)
        Movi.Client.callsign(Application.get_env(:movi, :callsign))
        :timer.sleep(100)
        train_list(Application.get_env(:movi, :verbs))
        train_list(Application.get_env(:movi, :combinators))
        train_list(Application.get_env(:movi, :descriptors))
        train_list(Application.get_env(:movi, :locations))
        train_list(Application.get_env(:movi, :things))
        train_list(Application.get_env(:movi, :numbers))
        Movi.Client.trainsentences
    end

    defp train_list(list) do
        Enum.each(list, fn(sentence) ->
            Movi.Client.addsentence(sentence)
            :timer.sleep(100)
        end)
    end

end
