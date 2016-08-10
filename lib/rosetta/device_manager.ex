defmodule Rosetta.DeviceManager do
    use GenServer
    require Logger
    alias Lifx.Device.State, as: Device

    @googlecast :"_googlecast._tcp.local"

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
            send(parent, {:lifx, device})
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
            send(parent, {:ssdp, device})
            {:ok, parent}
        end
    end

    defmodule MDNSHandler do
        use GenEvent
        require Logger

        def init do
            {:ok, []}
        end

        def handle_event(obj, parent) do
            send(parent, obj)
            {:ok, parent}
        end
    end

    def start_link do
        GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
        {:ok, events} = GenEvent.start_link([{:name, Rosetta.DeviceManager.Events}])
        Mdns.Client.add_handler(MDNSHandler)
        Mdns.Client.query(Atom.to_string(@googlecast))
        Process.send_after(self(), :devices, 100)
        {:ok, %State{:events => events}}
    end

    def handle_info(:devices, state) do
        Process.send_after(self(), :devices, 1000)
        {:noreply, state}
    end

    def handle_info({@googlecast, device}, state) do
        Logger.debug("Google Cast Device: #{inspect device}")
        {:noreply, state}
    end

end
