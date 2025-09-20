enum ContainerType {
    Switch,
    PowerSystem,
    Fuse,
    DefaultContainer // delete me and process by generic function
}

def get_container_type(container) {
    tags = container.getTags()
    if (tags.contains("switch")) {
        return ContainerType.Switch
    }
    if (tags.contains("power_source")) {
        return ContainerType.PowerSystem
    }
    if (tags.contains("starter")) {
        return ContainerType.DefaultContainer
    }
    if (tags.contains("fuse")) {
        return ContainerType.Fuse
    }

    throw new NoSuchFieldException("Unknown container type [" + container.getName() + "]")
}

def get_outgoing_relationships(component) {
    return component.getRelationships().findAll {relationship ->
        (relationship.getSource().equals(component) && relationship.getDestination().getClass().equals(com.structurizr.model.Component))
    }
}


def get_amper_for_switch(component) {
    max_switch_amper = 0
    extra_ampers = 0

    get_outgoing_relationships(component).each { relationship ->
        if (relationship.getProperties().contains("switch_state")) {
            switch_result = get_amper_for(relationship.getDestination())
            if (switch_result > max_switch_amper) {
                max_switch_amper = switch_result
            }
        }
        else {
            extra_ampers += get_amper_for(relationship.getDestination())
        }
    }

    return max_switch_amper + extra_ampers
}


def get_amper_for_power_system(component) {
    result = 0
    
    get_outgoing_relationships(component).each { relationship ->
        result += get_amper_for(relationship.getDestination())
    }

    return result
}

def get_amper_for_default_container (component) {
    result = 0
    
    get_outgoing_relationships(component).each { relationship ->
        result += get_amper_for(relationship.getDestination())
    }

    return result
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
    container_type = get_container_type(component.getParent())
    switch(container_type) {
    case ContainerType.Switch:
        result = get_amper_for_switch(component)
        break
    
    case ContainerType.PowerSystem:
        result = get_amper_for_power_system(component)
        break

    case ContainerType.DefaultContainer:
        result = get_amper_for_default_container(component)
        break

    case ContainerType.Fuse:
        result = get_amper_for_default_container(component)
        break

    default:
        throw new IllegalStateException("Unknown container type: " + container_type.toString())
    }

    component.addProperty("amper", Integer.toString(result))
    return result
}


def dfs(vertex, parent, path) {
    vertex.addTags("__visited")
    path.add(vertex)

    vertex.getRelationships().each {relationship ->
        dest = relationship.getDestination()
        if (!dest.getTags().contains("__visited")) {
            dfs(dest, parent, path)
        } else if (dest != vertex) {
            reportGraphCycleError(path)
        }
    }
    path.remove(path.size() - 1)
}

def ensureNoCycles(elements) {
    elements.each { element ->
        should_process = true
        element.getRelationships().each {relationship ->
            if (relationship.getDestination() == element) {
                should_process = false
            }
        }

        if (should_process) {
            dfs(element, null, new ArrayList[])
        }
    }


def validateGraph(elements) {
    ensureNoCycles(elements)
    checkReachability(elements)
    ensureNoPathBetweenPowerSourcesAndConsumer(elements)
}


validateGraph()


// Process all power sources
workspace.model.getElements().findAll {element ->
    (element.getTags().contains("power_source"))
}. each { power_source ->
    println("power source: " + power_source.getName())
    amper = get_amper_for(power_source.getComponentWithName("+"))
    println("Amper usage for power source [" + power_source.getName() + "]")
}
