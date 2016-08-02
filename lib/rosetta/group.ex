defmodule Rosetta.Group do
    use GenServer

    defmodule State do
        defstruct name: nil,
            geohash: nil,
            devices: [],
            groups: []
    end
end
