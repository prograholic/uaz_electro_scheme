def getRelationshipName(relationship) {
    return "{" + relationship.getSource().getCanonicalName() + " -> " + relationship.getDestination().getCanonicalName() + "}"
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

    throw new NoSuchFieldException("Unknown element type " + element.getCanonicalName())
}



def ensureCorrectPin2PinConnections(relationships) {
    println("ENSURE CORRECT PIN 2 PIN CONNECTIONS")
    relationships.findAll { relationship ->
        (!relationship.getTags().contains("internal_connection"))
    }.each { relationship ->
        src = relationship.getSource()
        dst = relationship.getDestination()
        // should check for tag presence instead of getElementType
        if (!src.getTags().contains("pin")) {
            throw new IllegalStateException("Non pin element (source) detected: " + src.getCanonicalName() + " for connection: " + getRelationshipName(relationship))
        }
        // should check for tag presence instead of getElementType
        if (!dst.getTags().contains("pin")) {
            throw new IllegalStateException("Non pin element (destination) detected: " + dst.getCanonicalName() + " for connection: " + getRelationshipName(relationship))
        }
    }
}

def ensureNoUnconnectedPins(relationships, pins) {
    println("ENSURE NO UNCONNECTED PINS")

    pins.each { pin ->
        incomingRelationships = relationships.findAll {relationship ->
            (relationship.getDestination() == pin)
        }

        if (incomingRelationships.size() == 0) {
            throw new IllegalStateException("No incoming connections to pin " + pin.getCanonicalName())
        }

        outgoingRelationships = relationships.findAll {relationship ->
            (relationship.getSource() == pin)
        }

        if (outgoingRelationships.size() == 0) {
            throw new IllegalStateException("No outgoing connections to pin " + pin.getCanonicalName())
        }
    }
}

def ensureNoShortCircuitAndSequentialConsumersFor(element, visited, path, consumer_count) {
    if (consumer_count > 1) {
        println(" detected sequential consumers: " + consumer_count + ", element: " + element.getCanonicalName())
        path.each { p ->
            println("  " + p.getCanonicalName())
        }

        throw new IllegalStateException("Sequential consumers detected, see log for details.")
    }
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
                ensureNoShortCircuitAndSequentialConsumersFor(dst, visited, path, consumer_count + 1)
            }
            if (elementType == elementType.Ground) {
                if (consumer_count == 0) {
                    println(" detected short circuit:")
                    path.each {p ->
                        println("  " + p.getCanonicalName())
                    }
                    throw new IllegalStateException("Short circuit detected, see log for details.")
                }
            }
        } else {
            println(" found already visited element: " + dst.getCanonicalName())
            if (consumer_count != visited.get(dst))
            {
                println("  with different consumer count: " + visited.get(dst) + ", expected: " + consumer_count)
                ensureNoShortCircuitAndSequentialConsumersFor(dst, visited, path, Math.min(consumer_count, visited.get(dst)))
            }
        }
    }

    path.remove(path.size() - 1)
}

def ensureNoShortCircuitAndSequentialConsumers(power_sources) {
    println("ENSURE NO SHORT CIRCUIT AND SEQUENTIAL CONSUMERS")

    visited = new HashMap<com.structurizr.model.Element, Integer>()
    power_sources.each {power_source ->
        path = new ArrayList<com.structurizr.model.Element>()
        ensureNoShortCircuitAndSequentialConsumersFor(power_source, visited, path, 0)
    }
}


def validateOfflineGraph(relationships, elements, pins) {
    ensureCorrectPin2PinConnections(relationships)
    ensureNoUnconnectedPins(relationships, pins)
    ensureNoShortCircuitAndSequentialConsumers(power_sources)
}

def deduceAmperageToPowerSource(relationships, relationship, amper, isIncoming) {
    currentAmper = relationship.getProperties().getOrDefault("amper", "0").toFloat() + amper
    println(" props(" + isIncoming + "): " + getRelationshipName(relationship) + relationship.getProperties() + ", current amper: " + currentAmper)
    
    relationship.addProperty("amper", currentAmper.toString())

    relationshipsForElement = null
    if (isIncoming) {
        relationshipsForElement = relationships.findAll { incomingRelationship ->
            ((incomingRelationship.getDestination() == relationship.getSource()) && (getElementType(relationship.getSource()) != ElementType.PowerSource))
        }
    } else {
        relationshipsForElement = relationships.findAll { outgoingRelationship ->
            ((outgoingRelationship.getSource() == relationship.getDestination()) && (getElementType(relationship.getDestination()) != ElementType.PowerSource))
        }
    }

    def newAmper = amper / relationshipsForElement.size()
    relationshipsForElement.each { relationshipForElement ->
        if (relationshipForElement.getTags().contains("switch_ctr")) {
            container = relationshipForElement.getSource().getParent()

            active_switch_state = container.getProperties().getOrDefault("active_switch_state", "0")
            rel_switch_state = relationshipForElement.getProperties().getOrDefault("switch_state", "0")

            if (active_switch_state == rel_switch_state) {
                println("  enabled switch state " + active_switch_state + " for " + container.getCanonicalName())
                deduceAmperageToPowerSource(relationships, relationshipForElement, newAmper, isIncoming)
            } else {
                ////
            }
        } else {
            deduceAmperageToPowerSource(relationships, relationshipForElement, newAmper, isIncoming)
        }
    }
}


def findShortestPath(start, finish, relationships, connectionAllowed, totalElementsCount) {
    //println("FIND SHORTEST PATH from " + start.getCanonicalName() + " to " + finish.getCanonicalName())
    distance = new HashMap<com.structurizr.model.Element, Integer>()
    pathHolder = new HashMap<com.structurizr.model.Element, com.structurizr.model.Element>()
    Queue<com.structurizr.model.Element> queue = new LinkedList<>()

    if (start == finish) {
        throw new IllegalStateException("Cannot find shortest circle!")
    }

    distance.put(start, 0)
    queue.add(start)

    while (!queue.isEmpty()) {
        current = queue.remove()

        relationships.findAll { relationship ->
            ((relationship.getSource() == current) && connectionAllowed(relationship))
        }.each { relationship ->
            next = relationship.getDestination()

            distanceToNext = distance.getOrDefault(next, totalElementsCount)
            distanceToCurrent = distance.getOrDefault(current, totalElementsCount)
            if (distanceToNext > (distanceToCurrent + 1)) {
                pathHolder.put(next, current)
                distance.put(next, distanceToCurrent + 1)
                queue.add(next)
            }
        }
    }

    if (!distance.containsKey(finish)) {
        return null
    }

    res = new ArrayList<com.structurizr.model.Relationship>()
    prev = finish
    curr = pathHolder.get(prev)
    res.add(curr.getRelationships().findAll{it.getDestination() == prev}.first())

    while (pathHolder.containsKey(curr)) {
        prev = curr
        curr = pathHolder.get(prev)

        res.add(curr.getRelationships().findAll{it.getDestination() == prev}.first())
    }

    Collections.reverse(res)
    return res
}

def findActiveCircuits(relationships, elements, consumers, connectionAllowed) {
    println("FIND ACTIVE CIRCUITS")

    def res = new HashMap<com.structurizr.model.Element, ArrayList<com.structurizr.model.Relationship>>()

    consumers.each { consumer ->
        incomingRelationships = relationships.findAll { relationship ->
            (relationship.getDestination() == consumer)
        }

        if (incomingRelationships.size() != 1) {
            println(" Incorrect incoming relationships for consumer " + consumer.getCanonicalName())
            incomingRelationships.each { incomingRelationship ->
                println("  " + getRelationshipName(incomingRelationship))
            }
            throw new IllegalStateException("Incorrect incoming relationships for consumer " + consumer.getCanonicalName() + ", see log for details")
        }

        relationshipWithConsumer = incomingRelationships.first()

        shortestPath = findShortestPath(consumer, relationshipWithConsumer.getSource(), relationships, connectionAllowed, elements.size())
        if (shortestPath != null) {
            shortestPath.add(relationshipWithConsumer)

            println(" Shortest path for " + consumer.getCanonicalName())
            shortestPath.each {
                println("  " + getRelationshipName(it))
            }

            res.put(consumer, shortestPath)
        }
    }

    return res
}

def calculateAmperage(activeCircuits) {
    activeCircuits.each { consumer, activeCircuit ->
        amper = consumer.getProperties().getAt("amper").toFloat()
        activeCircuit.each{ relationship ->
            currentAmper = relationship.getProperties().getOrDefault("amper", "0").toFloat()

            relationship.addProperty("amper", (amper + currentAmper).toString())
        }
    }
}

def ValidateKirchhoffsCurrentLaw(activeCircuits) {
    println("VALIDATE KIRCHHOFF`S CURRENT LAW")

    activeElements = new TreeSet<com.structurizr.model.Element>()
    activeRelationships = new TreeSet<com.structurizr.model.Relationship>()
    
    activeCircuits.each {consumer, circuit ->
        circuit.each { rel ->
            activeElements.add(rel.getSource())
            activeElements.add(rel.getDestination())
            activeRelationships.add(rel)
        }
    }

    activeElements.each { element ->
        incomingAmperage = 0.0
        incomingRelationships = activeRelationships.findAll {relationship ->
            (relationship.getSource() == element)
        }
        
        incomingRelationships.each { relationship ->
            incomingAmperage += relationship.getProperties().getAt("amper").toFloat()
        }

        outgoingAmperage = 0.0
        outgoingRelationships = activeRelationships.findAll {relationship ->
            (relationship.getDestination() == element)
        }
        
        outgoingRelationships.each { relationship ->
            outgoingAmperage += relationship.getProperties().getAt("amper").toFloat()
        }

        if (Math.abs(incomingAmperage - outgoingAmperage) > 0.001) {
            println(" Found incorrect amperage for " + element.getCanonicalName())
            println("  Incoming amperage: " + incomingAmperage)
            incomingRelationships.each { rel ->
                println("   " + getRelationshipName(rel) + rel.getProperties().getAt("amper"))
            }
            println("  Outgoing amperage: " + outgoingAmperage)
            outgoingRelationships.each { rel ->
                println("   " + getRelationshipName(rel) + rel.getProperties().getAt("amper"))
            }

            throw new IllegalStateException("Incorrect amperage for " + element.getCanonicalName() + ", see log for details")
        }
    }
}

def ValidateKirchhoffsVoltageLaw(activeCircuits) {
    println("VALIDATE KIRCHHOFF`S VOLTAGE LAW")
    println("  NOT IMPLEMENTED!!!")
}



def validateOnlineGraph(activeCircuits) {
    ValidateKirchhoffsCurrentLaw(activeCircuits)
    ValidateKirchhoffsVoltageLaw(activeCircuits)
}


/////////////////////////
relationships = workspace.model.getRelationships()
elements = workspace.model.getElements()
pins = elements.findAll {element -> (element.getTags().contains("pin"))}
consumers = elements.findAll {element -> (element.getTags().contains("consumer"))}
switches = elements.findAll {element -> (element.getTags().contains("switch"))}
power_sources = elements.findAll {element -> (element.getTags().contains("power_source"))}


def allowActiveSwitchOnly = { relationship ->
    if (!relationship.getTags().contains("switch_ctr")) {
        return true
    }

    rel_switch_state = relationship.getProperties().getOrDefault("switch_state", "0")
    active_switch_state = relationship.getSource().getParent().getProperties().getOrDefault("active_switch_state", "0")

    if (active_switch_state == rel_switch_state) {
        return true
    }

    return false
}


//try {
    validateOfflineGraph(relationships, elements, pins)
    activeCircuits = findActiveCircuits(relationships, elements, consumers, allowActiveSwitchOnly)
    calculateAmperage(activeCircuits)

    validateOnlineGraph(activeCircuits)
//} catch (Exception e) {
//    println(e)
//}


