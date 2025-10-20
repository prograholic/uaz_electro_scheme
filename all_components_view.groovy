// Create group views
groups = new HashMap<String, ArrayList<com.structurizr.model.Container>>()
groupDelimiter = workspace.model.getProperties().getAt("structurizr.groupSeparator")

workspace.model.getSoftwareSystems().each { ss ->
    //println("Software system: " + ss.getName())
    ss.getContainers().each { container ->
        fullGroupName = container.getGroup()
        if (fullGroupName != null) {
            relativeGroupName = ""
            fullGroupName.split(groupDelimiter).each { subGroupName ->
                if (relativeGroupName.isEmpty()) {
                    relativeGroupName = subGroupName
                } else {
                    relativeGroupName = relativeGroupName + groupDelimiter + subGroupName
                }
                if (!groups.containsKey(relativeGroupName)) {
                    groups.put(relativeGroupName, new ArrayList<com.structurizr.model.Container>())
                }

                groups.get(relativeGroupName).add(container)
            }
        }
    }
}

groups.each {
    //println("Group: " + it.key)
    view = workspace.views.createComponentView(it.value[0], it.key + "_group", "")
    view.enableAutomaticLayout(com.structurizr.view.AutomaticLayout.RankDirection.TopBottom)
    it.value.each { container ->
        container.getComponents().each {component ->
            view.add(component, true)
            view.addNearestNeighbours(component, com.structurizr.model.Component.class)
            view.addNearestNeighbours(component, com.structurizr.model.Container.class)
        }
    }
}

/*
// Create outgoing relationships for each component
workspace.model.getSoftwareSystems().each { ss ->
    //println("OR: Software system: " + ss.getName())
    ss.getContainers().findAll{container ->
        (
            container.getTags().contains("relay") or
            container.getTags().contains("fuse") or
            container.getTags().contains("akb") or 
            container.getTags().contains("starter") or
            container.getTags().contains("generator") or
            container.getTags().contains("splitter")
        )
    }.each { container ->
        //println("  Container: " + container.getName())

        visitedElements = new TreeSet<com.structurizr.model.Element>()
        visitedRelationships = new TreeSet<com.structurizr.model.Relationship>()

        container.getComponents().each { component ->
            relationships = component.getRelationships().findAll { relationship ->
                (relationship.getSource().equals(component) && relationship.getDestination().getClass().equals(com.structurizr.model.Component))
            }

            visitedElements.add(component)
            visitedRelationships.addAll(relationships)

            //println("    Component(" + component.getName() + ") outgoing relationships: " + relationships.size() + ", total: " + component.getRelationships().size())
            //relationships.each { relationship -> println("      Outgoing rel: " + relationship.getDescription()) }

            while (relationships.size() > 0) {
                pendingRelationships = new TreeSet<com.structurizr.model.Relationship>()

                relationships.each { relationship ->
                    dest = relationship.getDestination()

                    if (!visitedElements.contains(dest)) {
                        pendingRelationshipsForDestination = dest.getRelationships().findAll { innerRelationship ->
                            (innerRelationship.getSource().equals(dest) and innerRelationship.getDestination().getClass().equals(com.structurizr.model.Component))
                        }
                        pendingRelationships.addAll(pendingRelationshipsForDestination)
                        visitedElements.add(dest)
                    }
                }
                relationships = pendingRelationships
                visitedRelationships.addAll(relationships)
            }
        }

        if (visitedElements.size() > 5 && visitedRelationships.size() > 5) {
            componentView = workspace.views.createComponentView(container, container.getName() + "__outgoing_relationships", "")
            componentView.enableAutomaticLayout(com.structurizr.view.AutomaticLayout.RankDirection.LeftRight)

            println("Create outgoing view for " + container.getName() + ", components: " + visitedElements.size() + ", relationships: " + visitedRelationships.size())

            visitedElements.each { element ->
                componentView.add(element, false)
            }
            visitedRelationships.each {relationship ->
                componentView.add(relationship)
            }
        }
    }
}


// Create component views
workspace.model.getSoftwareSystems().each {
    ss = it
    //println("Software system: " + ss.getName())
    ss.getContainers().each { container ->
        //("  Container: " + container.getName())
        if (container.getComponents().size() > 0) {
            componentView = workspace.views.createComponentView(container, container.getName() + "_direct_neighbours", "")
            componentView.enableAutomaticLayout(com.structurizr.view.AutomaticLayout.RankDirection.LeftRight)
        }
    }
}



// Fill component views with data
workspace.views.views.findAll {it instanceof com.structurizr.view.ComponentView && it.getKey().endsWith("_direct_neighbours")}.each {
    //componentView.
    componentView = it
    println("Processing component view: " + componentView.getName())
    container = componentView.getContainer()
    //println("  Container name: " + container.getName())
    //("  Components count: " + container.getComponents().size())
    container.getComponents().each {component ->
        componentView.add(component, true)
        componentView.addNearestNeighbours(component, com.structurizr.model.Component.class)
        componentView.addNearestNeighbours(component, com.structurizr.model.Container.class)
        //println("  Add [" + component.getName() + "] to view")
    }
}
*/
