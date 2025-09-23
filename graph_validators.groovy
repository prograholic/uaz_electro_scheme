def getElementName(element) {
    if (element.getParent() != null) {
        return "[" + element.getParent().getName() + "." + element.getName() + "]"
    } else {
        return "[<NO_PARENT>." + element.getName() + "]"
    }
}

def getRelationshipName(relationship) {
    return "{" + getElementName(relationship.getSource()) + " -> " + getElementName(relationship.getDestination()) + "}"
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
    Chassis,

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

    if (tags.contains("chassis")) {
        return ElementType.Chassis
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
            throw new IllegalStateException("Incorrect relationship " + getRelationshipName(relationship))
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
        // should check for tag presence instead of getElementType
        if (!src.getTags().contains("pin")) {
            throw new IllegalStateException("Non pin element (source) detected: " + getElementName(src) + " for connection: " + getRelationshipName(relationship))
        }
        // should check for tag presence instead of getElementType
        if (!dst.getTags().contains("pin")) {
            throw new IllegalStateException("Non pin element (destination) detected: " + getElementName(dst) + " for connection: " + getRelationshipName(relationship))
        }
    }

    pins = elements.findAll {element ->
        (getElementType(element) == ElementType.Pin)
    }

    pins.each { pin ->
        incomingRelationships = relationships.findAll {relationship ->
            (relationship.getDestination() == pin)
        }

        if (incomingRelationships.size() == 0) {
            throw new IllegalStateException("No incoming connections to  pin " + getElementName(pin))
        }

        outgoingRelationships = relationships.findAll {relationship ->
            (relationship.getSource() == pin)
        }

        if (outgoingRelationships.size() == 0) {
            throw new IllegalStateException("No outgoing connections to  pin " + getElementName(pin))
        }
    }
}


def validatePowerSources(relationships, elements, pins) {
    println("VALIDATE POWER SOURCES")

    power_sources = elements.findAll{power_source ->
        (getElementType(power_source) == ElementType.PowerSource)
    }

    println(" power sources: ")
    power_sources.each {power_source ->
        println("  " + getElementName(power_source))
    }

    return power_sources
}

def validateGraph(relationships, elements) {
    pins = validatePinConnections(relationships, elements)
    power_sources = validatePowerSources(relationships, elements, pins)
    
    checkDirections(power_sources)

    consumers = elements.findAll { element ->
        (getElementType(element) == ElementType.Consumer)
    }

    grounds = elements.findAll { element ->
        (getElementType(element) == ElementType.Ground)
    }

    return [power_sources, pins, consumers, grounds]
}


def deduceAmperageToPowerSourceMinus(relationships, relationship, amper) {
    currentAmper = relationship.getProperties().getOrDefault("amper", "0").toFloat() + amper

    println(" props(minus): " + getRelationshipName(relationship) + relationship.getProperties() + ", current amper: " + currentAmper)
    
    relationship.addProperty("amper", currentAmper.toString())

    outgoingRelationships = relationships.findAll { outgoingRelationship ->
        ((outgoingRelationship.getSource() == relationship.getDestination()) && (getElementType(relationship.getDestination()) != ElementType.PowerSource))
    }
    def newAmper = amper / outgoingRelationships.size()
    println ("  rels size: " + outgoingRelationships.size() + ", newAmper: " + newAmper)
    
    outgoingRelationships.each { outgoingRelationship ->
        deduceAmperageToPowerSourceMinus(relationships, outgoingRelationship, newAmper)
    }
}

def deduceAmperageToPowerSourcePlus(relationships, relationship, amper) {
    currentAmper = relationship.getProperties().getOrDefault("amper", "0").toFloat() + amper
    println(" props(plus): " + getRelationshipName(relationship) + relationship.getProperties() + ", current amper: " + currentAmper)
    
    relationship.addProperty("amper", currentAmper.toString())

    incomingRelationships = relationships.findAll { incomingRelationship ->
        ((incomingRelationship.getDestination() == relationship.getSource()) && (getElementType(relationship.getSource()) != ElementType.PowerSource))
    }

    def newAmper = amper / incomingRelationships.size()
    println ("  rels size: " + incomingRelationships.size() + ", newAmper: " + newAmper)
    
    incomingRelationships.each { incomingRelationship ->
        deduceAmperageToPowerSourcePlus(relationships, incomingRelationship, newAmper)
    }
}

def validateAmperage(relationships, pins) {
    println("VALIDATE AMPERAGE")
    pins.each { pin ->
        println(" pin: " + getElementName(pin))
        incomingRelationships = relationships.findAll { relationship ->
            (relationship.getDestination() == pin)
        }
        outgoingRelationships = relationships.findAll { relationship ->
            (relationship.getSource() == pin)
        }

        incomingAmperage = 0.0
        incomingRelationships.each { incomingRelationship ->
            println("  incomingRelationship: " + getRelationshipName(incomingRelationship) + incomingRelationship.getProperties())
            incomingAmperage += incomingRelationship.getProperties().getAt("amper").toFloat()
        }

        outgoingAmperage = 0.0
        outgoingRelationships.each { outgoingRelationship ->
            println("  outgoingRelationship: " + getRelationshipName(outgoingRelationship) + outgoingRelationship.getProperties())
            outgoingAmperage += outgoingRelationship.getProperties().getAt("amper").toFloat()
        }

        if (Math.abs(incomingAmperage - outgoingAmperage) > 0.001) {
            println(" Found incorrect amperage for " + getElementName(pin))
            println("  Incoming amperage: " + incomingAmperage)
            incomingRelationships.each { rel ->
                println("   " + getRelationshipName(rel) + rel.getProperties().getAt("amper"))
            }
            println("  Outgoing amperage: " + outgoingAmperage)
            outgoingRelationships.each { rel ->
                println("   " + getRelationshipName(rel) + rel.getProperties().getAt("amper"))
            }

            throw new IllegalStateException("Incorrect amperage for " + getElementName(pin) + ", see log for details")
        }
    }
}

def deduceAmperage(relationships, consumers, pins) {
    println("DEDUCE AMPERAGE")
    consumers.each { consumer ->
        if (!consumer.getProperties().containsKey("amper")) {
            throw new IllegalStateException("Consumer " + getElementName(consumer) + " should has `amper` property")
        }
        amper = consumer.getProperties().get("amper").toFloat()
        relationships.findAll {relationship ->
            (relationship.getSource() == consumer)
        }.each { relationship ->
            deduceAmperageToPowerSourceMinus(relationships, relationship, amper)
        }

        relationships.findAll {relationship ->
            (relationship.getDestination() == consumer)
        }.each { relationship ->
            deduceAmperageToPowerSourcePlus(relationships, relationship, amper)
        }
    }

    validateAmperage(relationships, pins)
}

/////////////////////////

try {
    def (power_sources, pins, consumers, grounds) = validateGraph(workspace.model.getRelationships(), workspace.model.getElements())

    deduceAmperage(workspace.model.getRelationships(), consumers, pins)
} catch (Exception e) {
    println(e)
}


