defmodule Rosetta.SSDPClient do
    use GenServer
    require Logger

    import SweetXml

    @port 1900
    @multicast_group {239,255,255,250}

    def discover_messages do
        ["M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: ssdp:all\r\n\r\n",
        "TYPE: WM-DISCOVER\r\nVERSION: 1.0\r\n\r\nservices:com.marvell.wm.system*\r\n\r\n",]
    end

    def start_link do
        GenServer.start(__MODULE__, @port, name: __MODULE__)
    end

    def discover do
        Process.send_after(self, :discover, 100)
    end

    def init(port) do
        udp_options = [
            :binary,
            add_membership:  { @multicast_group, {0,0,0,0} },
            multicast_if:    {0,0,0,0},
            multicast_loop:  false,
            multicast_ttl:   2,
            reuseaddr:       true
        ]
        discover
        {:ok, udp} = :gen_udp.open(port, udp_options)
    end

    def handle_info(:discover, state) do
        Enum.each(discover_messages, fn(m) ->
            Logger.info "Sending Discovery: #{m}"
            :gen_udp.send(state, @multicast_group, @port, m)
        end)
        Process.send_after(self, :discover, 60000)
        {:noreply, state}
    end

    def handle_info({:udp, _s, ip, port, <<"M-SEARCH * HTTP/1.1", rest :: binary>>}, state) do
        Logger.info "#{inspect ip} is looking for clients"
        {:noreply, state}
    end

    def handle_info({:udp, _s, ip, port, <<"HTTP/1.1 200 OK", rest :: binary>>}, state) do
        Logger.info "HTTP OK"
        parse_xml(rest)
        {:noreply, state}
    end

    def handle_info({:udp, _s, ip, port, <<"NOTIFY * HTTP/1.1", rest :: binary>>}, state) do
        Logger.info "NOTIFY"
        parse_xml(rest)
        {:noreply, state}
    end

    def handle_info({:udp, _s, ip, port, <<"TYPE: WM-NOTIFY", rest:: binary>>}, state) do
        Logger.info "WM"
        IO.inspect parse_keys(rest)
        {:noreply, state}
    end

    def handle_info({:udp, _s, ip, port, rest}, state) do
        Logger.info "HUH"
        IO.inspect parse_keys(rest)
        {:noreply, state}
    end

    #def handle_info({:udp, _s, _ip, _port, _}, state), do: {:noreply, state}
    def handle_info({:udp_passive, _}, state), do: {:noreply, state}

    def parse_keys(rest) do
        raw_params = String.split(rest, ["\r\n", "\n"])
        mapped_params = Enum.map raw_params, fn(x) ->
            case String.split(x, ":", parts: 2) do
                [k, v] -> {String.to_atom(String.downcase(k)), String.strip(v)}
                _ -> nil
            end
        end
        Enum.reject mapped_params, &(&1 == nil)
    end

    def parse_xml(rest) do
        IO.inspect rest
        resp = parse_keys(rest)
        case HTTPoison.get(Dict.get(resp, :location), [], hackney: [:insecure]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                IO.inspect body
                f_name = body |> xpath(~x"//device/friendlyName/text()")
                m_name = body |> xpath(~x"//device/modelName/text()")
                Logger.info "Found #{f_name} (#{m_name}) on local network"
            {:ok, %HTTPoison.Response{status_code: 404}} ->
                IO.puts "Not found :("
            {:ok, %HTTPoison.Response{body: body}} ->
                IO.puts "error #{body}"
            {:error, %HTTPoison.Error{reason: reason}} ->
                IO.inspect reason
        end
    end
end
