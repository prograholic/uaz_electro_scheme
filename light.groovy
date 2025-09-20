plus = element.getComponentWithName("+")
minus = element.getComponentWithName("-")

rel = plus.uses(minus, new String())
rel.addTags("pwr", "light_pwr", "consumer")
rel.addProperty("amper", element.getProperties().get("amper"))
