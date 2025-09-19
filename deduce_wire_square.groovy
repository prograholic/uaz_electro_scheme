
def get_amper_for_switch(switch_container, component) {

}


def get_amper_for(component) {

    println("get_amper_for: " + component.getParent().getName() + "." + component.getName())

    properties = component.getProperties()
    amper = properties.get("amper")
    if (amper != null)
    {
        return amper.toInteger()
    }

    result = 0

    component.getRelationships().findAll {relationship ->
        (relationship.getSource().equals(component) && relationship.getDestination().getClass().equals(com.structurizr.model.Component))
    }.each { relationship ->
        result += get_amper_for(relationship.getDestination())
    }

    if (result != 0) {
        component.addProperty("amper", Integer.toString(result))
        return result
    } else {
        throw new NoSuchFieldException("Property \"amper\" is missing for component [" + component.getName() + "]")
    }
}

// Process all power sources
workspace.model.getElements().findAll {element ->
    (element.getTags().contains("power_source"))
}. each { power_source ->
    println("power source: " + power_source.getName())
    amper = get_amper_for(power_source.getComponentWithName("+"))
    println("Amper usage for power source [" + power_source.getName() + "]")
}
