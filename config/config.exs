# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
config :rosetta, multicast_address: {239, 255, 41, 11}
config :rosetta, name: "LAB"
config :rosetta, tty: "/dev/ttyUSB0"
config :movi, speed: 9600
config :movi, callsign: "ROSETTA"
config :lifx, tcp_server: false, tcp_port: 8800

config :ex_aws, region: "us-west-2"

import_config "words.exs"
import_config "device_types.exs"
#
# And access this configuration in your application as:
#
#     Application.get_env(:rosetta, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
