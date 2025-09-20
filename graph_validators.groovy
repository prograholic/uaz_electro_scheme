def reportGraphCycleError(path) {
    println("Cycle detected:")
    path.each { element ->
        println("  " + element.getParent().getName() + "." + element.getName() + " ->")
    }
    throw new IllegalStateException("Cycle detected! See logs for details")
}

def ensureNoCyclesImpl(element, parent, path, visited) {
    visited.put(element, 1)
    path.add(element)

    element.getRelationships().each {relationship ->
        dest = relationship.getDestination()
        v = visited.get(dest)
        if (visited == null) {
            ensureNoCyclesImpl(dest, element, path, visited)
        } else if (visited == 1) {
            reportGraphCycleError(path)
        }
    }
    path.remove(path.size() - 1)
    visited.put(element, 2)
}

def ensureNoCycles(elements) {
    elements.each { element ->
        println("ensureNoCycles: " + element.getParent() + element)
        ensureNoCyclesImpl(element, null, new ArrayList(), new HashMap<com.structurizr.model.Element, Integer>())
    }
}




def checkReachabilityBetween(element, finish, visited) {
    visited.add(element)

    for (relationship in element.getRelationships()) {
        dest = relationship.getDestination()
        if (dest == finish) {
            return true
        }
        if (!visited.contains(dest)) {
            if (checkReachabilityBetween(dest, finish, visited)) {
                return true
            }
        }
    }

    return false
}

def checkReachability(elements) {
    power_sources = elements.findAll {element -> 
        (element.getTags().contains("power_source"))
    }

    grounds = elements.findAll {element ->
        (element.getTags().contains("ground"))
    }

    power_sources.each {power_source ->
        connected = false
        for (ground in grounds) {
            if (checkReachabilityBetween(power_source, ground, new TreeSet<com.structurizr.model.Element>())) {
                connected = true
                break
            }
        }

        if (!connected) {
            println("power source " + power_source.getParent() + power_source + " is not connected to any ground")
            throw new IllegalStateException("Found power source without ground! See log for details")
        }
    }
}

def reportSequentialConsumerError(path) {
    println("Detected sequential consumers:")
    path.each { element ->
        println("  " + element.getParent().getName() + "." + element.getName() + " ->")
    }
    throw new IllegalStateException("Detected sequential consumers! See logs for details")
}

def ensureNoSequentialConsumers(element, visited, path, gotConsumer) {
    visited.add(element)

    if (gotConsumer) {
        path.add(element)
    }

    element.getRelationships().each { relationship ->
        dest = relationship.getDestination()

        newGotConsumer = gotConsumer
        if (relationship.getTags().contains("consumer")) {
            if (gotConsumer) {
                reportSequentialConsumerError(path)
            }
            newGotConsumer = true
        }

        if (!visited.contains(dest)) {
            ensureNoSequentialConsumers(dest, visited, path, newGotConsumer)
        }
    }

    if (gotConsumer) {
        path.remove(path.size() - 1)
    }
}

def ensureNoSequentialConsumers(elements) {
    power_sources = elements.findAll {element -> 
        (element.getTags().contains("power_source"))
    }

    power_sources.each {power_source ->
        ensureNoSequentialConsumers(power_source, new TreeSet<com.structurizr.model.Element>(), new ArrayList(), false)
    }
}


def validateGraph(elements) {
    ensureNoCycles(elements)
    checkReachability(elements)
    ensureNoSequentialConsumers(elements)
}


validateGraph(workspace.model.getElements())
