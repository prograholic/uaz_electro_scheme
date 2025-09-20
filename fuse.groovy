in = element.getComponentWithName("in")
out = element.getComponentWithName("out")

rel = in.uses(out, new String())
rel.addTags("pwr", "fuse_pwr")
//rel.addProperty("max_amper", element.getProperties().get("max_amper"))
