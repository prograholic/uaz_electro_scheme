all_views = workspace.getViews()


// Create component views
workspace.model.getSoftwareSystems().each {
    ss = it
    println("Software system: " + ss.getName())
    ss.getContainers().each { container ->
        println("  Container: " + container.getName())
        if (container.getComponents().size() > 0) {
            componentView = workspace.views.createComponentView(container, container.getName() + "_direct_neighbours", "")
            componentView.enableAutomaticLayout(com.structurizr.view.AutomaticLayout.RankDirection.LeftRight, 300, 300, 0, true)
        }
    }
}



// Fill component views with data
workspace.views.views.findAll {it instanceof com.structurizr.view.ComponentView && it.getKey().endsWith("_direct_neighbours")}.each {
    //componentView.
    componentView = it
    println("Processing component view: " + componentView.getName())
    container = componentView.getContainer()
    println("  Container name: " + container.getName())
    println("  Components count: " + container.getComponents().size())
    container.getComponents().each {component ->
        componentView.add(component, true)
        componentView.addNearestNeighbours(component, com.structurizr.model.Component.class)
        componentView.addNearestNeighbours(component, com.structurizr.model.Container.class)
        println("  Add [" + component.getName() + "] to view")
    }
}


// Create group views
groups = new HashMap<String, ArrayList<com.structurizr.model.Container>>()
workspace.model.getSoftwareSystems().each { ss ->
    println("Software system: " + ss.getName())
    ss.getContainers().each { container ->
        groupName = container.getGroup()
        if (groupName != null) {
            if (!groups.containsKey(groupName)) {
                groups.put(groupName, new ArrayList<com.structurizr.model.Container>())
            }

            groups.get(groupName).add(container)
        }
    }
}

groups.each {
    println("Group: " + it.key)
    view = workspace.views.createComponentView(it.value[0], it.key + "_group", "")
    view.enableAutomaticLayout(com.structurizr.view.AutomaticLayout.RankDirection.LeftRight, 300, 300, 0, true)
    it.value.each { container ->
        container.getComponents().each {component ->
            view.add(component, true)
            view.addNearestNeighbours(component, com.structurizr.model.Component.class)
            view.addNearestNeighbours(component, com.structurizr.model.Container.class)
        }

    }
}
