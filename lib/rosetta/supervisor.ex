defmodule Rosetta.Supervisor do
    use Supervisor

    @name __MODULE__
    @tty Application.get_env(:rosetta, :tty)

    def start_link do
        Supervisor.start_link(__MODULE__, :ok, name: @name)
    end

    def init(:ok) do
        children = [
            worker(Movi, [@tty]),
            worker(Rosetta.SSDPClient, []),
            worker(Rosetta.VoiceEvents, []),
        ]
        supervise(children, strategy: :one_for_one)
    end
end
