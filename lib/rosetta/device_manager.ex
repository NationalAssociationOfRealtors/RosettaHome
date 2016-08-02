defmodule Rosetta.DeviceManager do
    use GenServer
    require Logger
    alias Lifx.Device.State, as: Device

    defmodule State do
        defstruct devices: [],
            events: nil
    end

    defmodule LifxHandler do
        use GenEvent
        require Logger

        def init do
            {:ok, []}
        end

        def handle_event(%Device{} = device, parent) do
            send(parent, device)
            {:ok, parent}
        end
    end

    defmodule SSDPHandler do
        use GenEvent
        require Logger
        alias Lifx.Device.State, as: Device

        def init do
            {:ok, []}
        end

        def handle_event({:device, device} = obj, parent) do
            send(parent, obj)
            {:ok, parent}
        end
    end

    def start_link do
        GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
        {:ok, events} = GenEvent.start_link([{:name, Rosetta.DeviceManager.Events}])
        Lifx.Client.add_handler(LifxHandler)
        SSDP.Client.add_handler(SSDPHandler)
        {:ok, %State{ :events => events}}
    end

    def handle_info({:device, device}, state) do
        Logger.info("Got SSDP device #{inspect device}")
        {:noreply, state}
    end

    def handle_info(%Device{} = device, state) do
        Logger.info("Got LIFX device #{inspect device}")
        {:noreply, state}
    end


end
