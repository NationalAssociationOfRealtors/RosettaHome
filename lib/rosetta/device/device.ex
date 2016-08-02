defmodule Rosetta.Device do
    defstruct name: nil,
        pid: nil,
        group: nil,
        uri: %URI{},
        icon: nil,
        uuid: nil,
        events: nil
end
