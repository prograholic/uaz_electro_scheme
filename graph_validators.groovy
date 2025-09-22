def getElementName(element) {
    if (element.getParent() != null) {
        return "[" + element.getParent().getName() + "." + element.getName() + "]"
    } else {
        return "[<NO_PARENT>." + element.getName() + "]"
    }
}

enum ElementType {
    ElectricSystem,

    Akb,
    Starter,
    Generator,
    Winch,
    Ventilator,
    Light,
    Relay,
    Splitter,

    Switch,
    PowerSource,
    Consumer,
    Fuse,
    Sensor,
    Ground,
    Pin
}


def getElementType(element) {
    tags = element.getTags()

    if (tags.contains("electric_system")) {
        return ElementType.ElectricSystem
    }

    if (tags.contains("akb")) {
        return ElementType.Akb
    }
    if (tags.contains("starter")) {
        return ElementType.Akb
    }
    if (tags.contains("generator")) {
        return ElementType.Generator
    }
    if (tags.contains("splitter")) {
        return ElementType.Splitter
    }
    if (tags.contains("winch")) {
        return ElementType.Winch
    }
    if (tags.contains("vent")) {
        return ElementType.Ventilator
    }
    if (tags.contains("light")) {
        return ElementType.Light
    }
    if (tags.contains("relay")) {
        return ElementType.Relay
    }

    if (tags.contains("switch")) {
        return ElementType.Switch
    }
    if (tags.contains("power_source")) {
        return ElementType.PowerSource
    }
    if (tags.contains("consumer")) {
        return ElementType.Consumer
    }
    if (tags.contains("fuse")) {
        return ElementType.Fuse
    }
    if (tags.contains("sensor")) {
        return ElementType.Sensor
    }
    if (tags.contains("ground")) {
        return ElementType.Ground
    }

    if (tags.contains("pin")) { // should be last
        return ElementType.Pin
    }

    throw new NoSuchFieldException("Unknown element type " + getElementName(element))
}


def checkDirectionsFor(element, visited, path, consumer_count) {
    visited.put(element, consumer_count)
    path.add(element)

    element.getRelationships().each {relationship ->
        dst = relationship.getDestination()
        if (dst == element) {
            throw new IllegalStateException("Incorrect relationship " + getElementName(relationship.getSource()) + " -> " + getElementName(relationship.getDestination()))
        }

        if (!visited.containsKey(dst)) {
            elementType = getElementType(dst)
            if (elementType == ElementType.Consumer) {
                checkDirectionsFor(dst, visited, path, consumer_count + 1)
            }
            if (elementType == elementType.Ground) {
                if (consumer_count == 0) {
                    println(" detected short circuit:")
                    path.each {p ->
                        println("  " + getElementName(p))
                    }
                    throw new IllegalStateException("Short circuit detected, see log for details.")
                }
            }
        } else {
            println(" found already visited element: " + getElementName(dst))
            if (consumer_count != visited.get(dst))
            {
                println("  with different consumer count: " + visited.get(dst) + ", expected: " + consumer_count)
                checkDirectionsFor(dst, visited, path, Math.min(consumer_count, visited.get(dst)))
            }
        }
    }

    path.remove(path.size() - 1)
}

def checkDirections(power_sources) {
    println("CHECK DIRECTIONS")

    visited = new HashMap<com.structurizr.model.Element, Integer>()
    power_sources.each {power_source ->
        path = new ArrayList<com.structurizr.model.Element>()
        checkDirectionsFor(power_source, visited, path, 0)
    }
}


def validatePinConnections(relationships, elements) {
    println("VALIDATE PIN CONNECTIONS")
    relationships.findAll { relationship ->
        (!relationship.getTags().contains("internal_connection"))
    }.each { relationship ->
        src = relationship.getSource()
        dst = relationship.getDestination()
        if (!src.getTags().contains("pin")) {
            throw new IllegalStateException("Non pin element (source) detected: " + getElementName(src) + " for connection: " + relationship.toString())
        }
        if (!dst.getTags().contains("pin")) {
            throw new IllegalStateException("Non pin element (destination) detected: " + getElementName(dst) + " for connection: " + relationship.toString())
        }
    }

    return elements.findAll {element ->
        (getElementType(element) == ElementType.Pin)
    }
}


def validatePowerSources(relationships, pins) {
    println("VALIDATE POWER SOURCES")
    roots = new TreeSet<com.structurizr.model.Element>(pins.findAll {pin -> (!pin.getTags().contains("non_root"))})
    relationships.each {relationship ->
        if (roots.contains(relationship.getDestination())) {
            roots.remove(relationship.getDestination())
        }
    }

    power_sources = pins.findAll{power_source ->
        (getElementType(power_source) == ElementType.PowerSource)
    }.toSet()

    if (roots != power_sources) {
        println("power sources: ")
        power_sources.each {power_source ->
            println("  " + getElementName(power_source))
        }

        println("extra roots: ")
        roots.findAll { root ->
            (!power_sources.contains(root))
        }.each {root ->
            println("  " + getElementName(root))
        }

        println("non root power sources: ")
        power_sources.findAll { power_source ->
            (!roots.contains(power_source))
        }.each {power_source ->
            println("  " + getElementName(power_source))
        }

        throw new IllegalStateException("Incorrect power source declarations! See logs for details") 
    }

    return power_sources
}

def validateGraph(relationships, elements) {
    pins = validatePinConnections(relationships, elements)
    power_sources = validatePowerSources(relationships, pins)
    
    checkDirections(power_sources)

    consumers = elements.findAll { element ->
        (getElementType(element) == ElementType.Consumer)
    }

    grounds = elements.findAll { element ->
        (getElementType(element) == ElementType.Ground)
    }

    return [power_sources, pins, consumers, grounds]
}

def deduceAmperage(relationships, consumers) {

}

def (power_sources, pins, consumers, grounds) = validateGraph(workspace.model.getRelationships(), workspace.model.getElements())

deduceAmperage(workspace.model.getRelationships(), consumers)
