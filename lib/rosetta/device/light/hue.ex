defmodule Rosetta.Device.Light.Hue do
    use GenServer
    require Logger

    def start_link(%Rosetta.Device{} = device) do
        GenServer.start_link(__MODULE__, device)
    end

    def on(pid) do
        Logger.info("Hue:on not implemented")
    end

    def off(pid) do
        Logger.info("Hue:off not implemented")
    end

    def set_color(pid, hue, saturation, brightness, kelvin \\ 4000, duration \\ 1000) do
        Logger.info("Hue:set_color not implemented")
    end

    def init(%Rosetta.Device{} = device) do
        {:ok, device}
    end

    def handle_call(:on, _from, state) do
        Lifx.Device.on(state.pid)
        {:reply, :ok, state}
    end

    def handle_call(:off, _from, state) do
        Lifx.Device.off(state.pid)
        {:reply, :ok, state}
    end
end
