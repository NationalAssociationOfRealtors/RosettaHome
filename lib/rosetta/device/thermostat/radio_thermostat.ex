defmodule Rosetta.Device.Thermostat.RadioThermostat do
    use GenServer
    require Logger

    def start_link(%Rosetta.Device{} = device) do
        GenServer.start_link(__MODULE__, device)
    end

    def init(%Rosetta.Device{} = device) do
        {:ok, device}
    end
end
