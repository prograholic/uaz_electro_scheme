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
/*
// Process all power sources
workspace.model.getElements().findAll {element ->
    (element.getTags().contains("power_source"))
}. each { power_source ->
    println("power source: " + power_source.getName())
    amper = get_amper_for(power_source.getComponentWithName("+"))
    println("Amper usage for power source [" + power_source.getName() + "]")
}

*/

def get_shortest_path(start, finish) {
    distance = new HashMap<com.structurizr.model.Element, Integer>()
    distance.put(start, 0)

    pathHolder = new HashMap<com.structurizr.model.Element, com.structurizr.model.Element>()

    Queue<com.structurizr.model.Element> queue = new LinkedList<>();
    queue.offer(start)
    //println(" start: " + start.getParent().getName() + "." + start.getName())
    //println(" finish: " + finish.getParent().getName() + "." + finish.getName())

    while (!queue.isEmpty()) {
        current = queue.poll()
        //println("  current: " + current.getParent().getName() + "." + current.getName())

        current.getRelationships().each { relationship ->
            next = relationship.getDestination()
            if (next == current) {
                next = relationship.getSource()
            }
            //println("  next: " + next.getParent().getName() + "." + next.getName())
            //println("  distance: " + distance)

            if (!distance.containsKey(next) || (distance.get(next) > (distance.get(current) + 1))) {
                pathHolder.put(next, current)
                distance.put(next, distance.get(current) + 1)
                queue.push(next)
            }
        }
    }

    if (!distance.containsKey(finish)) {
        //println(" return NULL")
        return null
    }

    pathHolder.each {entry ->
        //println(" element in path holder: " + entry.key.getParent().getName() + "." + entry.key.getName() + " -> " + entry.value.getParent().getName() + "." + entry.value.getName())
    }

    elementsInPath = new ArrayList<com.structurizr.model.Element>()

    while (finish != null) {
        elementsInPath.add(finish)
        //println(" add to pathHolder: " + finish.getParent().getName() + "." + finish.getName())
        finish = pathHolder.getOrDefault(finish, null)
        //println(" new finish: " + finish)
    }
    Collections.reverse(elementsInPath)

    elementsInPath.each { element ->
        //println(" element in shortest path: " + element.getParent().getName() + "." + element.getName())
    }

    //it = elementsInPath.iterator()
    //while (it.hasNext()) {
    //    println(it.next())
    //}

    return elementsInPath
}

def get_shortest_path_for_group(consumer, final_elements) {
    result = null

    final_elements.each {final_element ->
        res = get_shortest_path(consumer, final_element)
        if (res != null) {
            if (result == null) {
                result = res
            } else {
                if (res.size() < result.size()) {
                    result = res
                }
            }
        }
    }

    println("Shortest path for " + consumer.getParent().getName() + "." + consumer.getName() + " is: ")
    result.each { element ->
        println("  " + element.getParent().getName() + "." + element.getName())
    }

    return result
}


// Process all power sources
power_sources = workspace.model.getElements().findAll {element ->
    (element.getTags().contains("power_source"))
}

grounds = workspace.model.getElements().findAll {element ->
    (element.getTags().contains("ground"))
}

consumers = workspace.model.getRelationships().findAll {relationship ->
    (relationship.getTags().contains("consumer"))
}


println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

consumers.each { consumer ->
    get_shortest_path_for_group(consumer.getSource(), grounds)
}
