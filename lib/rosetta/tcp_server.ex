defmodule Rosetta.TCPServer do

    alias Rosetta.API
    alias Rosetta.Websocket

    @port Application.get_env(:rosetta, :tcp_port)

    def start_link do
        dispatch = :cowboy_router.compile([
            { :_,
                [
                    {"/", :cowboy_static, {:priv_file, :rosetta, "index.html"}},
                    {"/static/[...]", :cowboy_static, {:priv_dir,  :rosetta, "static"}},
                    {"/ws", API.Websocket, []},
                    {"/stream", API.MJPEGHandler, []},
                    {"/nodes", API.Node, []},
            ]}
        ])
        {:ok, _} = :cowboy.start_http(:http,
            100,
            [{:port, @port}],
            [{:env, [{:dispatch, dispatch}]}]
        )
    end
end
