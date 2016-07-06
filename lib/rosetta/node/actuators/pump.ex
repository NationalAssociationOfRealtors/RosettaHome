defmodule Rosetta.Node.Actuator.Pump do
    use Rosetta.Node.Trigger.Frequency,
        frequency: 900,
        runtime: 180,
        on_callback: "pumpon",
        off_callback: "pumpoff",
        thing: "pump"
end
