_30 = element.getComponentWithName("30")
_87 = element.getComponentWithName("87")
_88 = element.getComponentWithName("88")

power_rel = _30.uses(_87, new String())
power_rel.addTags("pwr", "relay_pwr")

power_rel_def = _30.uses(_88, new String())
power_rel.addTags("pwr", "relay_pwr", "relay_pwr_default_connected")


_85 = element.getComponentWithName("85")
_86 = element.getComponentWithName("86")

ctr_rel = _85.uses(_86, new String())
ctr_rel.addTags("ctr", "relay_pwr", "consumer")

ctr_rel.addProperty("amper", element.getProperties().get("ctr_amper"))
