use Mix.Config

alias Rosetta.Device

config :rosetta, device_types: %{
    "Lifx.Device": Device.Light.Lifx,
    "urn:schemas-upnp-org:device:Basic:1": Device.Light.Hue,
    "urn:dial-multiscreen-org:device:dial:1": Device.Screen.Chromecast,
    "urn:Belkin:device:insight:1": Device.Switch.WemoInsight,
    "urn:wink-com:device:hub:2": Device.Hub.Wink,
    "urn:Belkin:device:lightswitch:1": Device.Switch.WemoLightSwitch,
    "urn:schemas-upnp-org:device:Basic:1.0": Device.Camera.DlinkDCS930L,
    "com.marvell.wm.system:1.0": Device.Thermostat.RadioThermostat,
    "urn:schemas-wifialliance-org:device:WFADevice:1": Device.Router.WFADevice,
    "urn:schemas-upnp-org:device:InternetGatewayDevice:1": Device.Router.InternetGateway,
}
