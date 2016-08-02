defmodule Rosetta.Device.Light.Lifx do
    use GenServer

    def start_link(%Rosetta.Device{} = device) do
        GenServer.start_link(__MODULE__, device)
    end

    def on(pid) do
        GenServer.call(pid, :on)
    end

    def off(pid) do
        GenServer.call(pid, :off)
    end

    def set_color(pid, hue, saturation, brightness, kelvin \\ 4000, duration \\ 1000) do
        Lifx.Device.set_color(pid, %Lifx.Protocol.HSBK{
            :hue => hue,
            :saturation => saturation,
            :brightness => brightness,
            :kelvin => kelvin,
        }, duration)
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
