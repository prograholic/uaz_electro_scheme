// https://www.uazbuka.ru/electro.htm#secpr
// https://xn----jtbncduncbo1j.xn--p1ai/articles/provoda-dlya-avtomobilnoy-provodki/



// FIZME: copy-paste from graph_validators
def getRelationshipName(relationship) {
    return "{" + relationship.getSource().getCanonicalName() + " -> " + relationship.getDestination().getCanonicalName() + ", tags: " + relationship.getTags().toString() + ", props: " + relationship.getProperties().toString() + "}"
}


def getSquareForTemp20Meter05(amper, rel) {
    if (amper < 6) {
        return "0.5"
    }
    if (amper < 8) {
        return "0.75"
    }
    if (amper < 10) {
        return "1"
    }
    if (amper < 15) {
        return "1.5"
    }
    if (amper < 20) {
        return "2.5"
    }
    if (amper < 30) {
        return "4"
    }
    if (amper < 50) {
        return "6"
    }
    if (amper < 75) {
        return "10"
    }
    if (amper < 100) {
        return "16"
    }
    if (amper < 200) {
        return "50"
    }

    throw new IllegalStateException("Too high amperage for 0.5 meter: " + String.format("%.2f", amper) + " for " + getRelationshipName(rel))
}

def getSquareForTemp20Meter1(amper, rel) {
    if (amper < 2) {
        return "0.5"
    }
    if (amper < 4) {
        return "0.75"
    }
    if (amper < 6) {
        return "1"
    }
    if (amper < 10) {
        return "1.5"
    }
    if (amper < 15) {
        return "2.5"
    }
    if (amper < 25) {
        return "4"
    }
    if (amper < 30) {
        return "6"
    }
    if (amper < 40) {
        return "10"
    }
    if (amper < 50) {
        return "16"
    }
    if (amper < 100) {
        return "25"
    }
    if (amper < 150) {
        return "50"
    }
    if (amper < 200) {
        return "75"
    }

    throw new IllegalStateException("Too high amperage for 1 meter: " + String.format("%.2f", amper) + " for " + getRelationshipName(rel))
}

def getSquareForTemp20Meter2(amper, rel) {
    if (amper < 1) {
        return "0.5"
    }
    if (amper < 2) {
        return "0.75"
    }
    if (amper < 3) {
        return "1"
    }
    if (amper < 4) {
        return "1.5"
    }
    if (amper < 8) {
        return "2.5"
    }
    if (amper < 10) {
        return "4"
    }
    if (amper < 20) {
        return "6"
    }
    if (amper < 30) {
        return "10"
    }
    if (amper < 50) {
        return "16"
    }
    if (amper < 100) {
        return "35"
    }
    if (amper < 150) {
        return "50"
    }
    if (amper < 200) {
        return "75"
    }

    throw new IllegalStateException("Too high amperage for 2 meter: " + String.format("%.2f", amper) + " for " + getRelationshipName(rel))
}

def getSquareForTemp20Meter3(amper, rel) {
    if (amper < 1) {
        return "0.75"
    }
    if (amper < 2) {
        return "1"
    }
    if (amper < 3) {
        return "1.5"
    }
    if (amper < 4) {
        return "2.5"
    }
    if (amper < 8) {
        return "4"
    }
    if (amper < 10) {
        return "6"
    }
    if (amper < 20) {
        return "10"
    }
    if (amper < 30) {
        return "16"
    }
    if (amper < 50) {
        return "25"
    }
    if (amper < 100) {
        return "50"
    }
    if (amper < 150) {
        return "75"
    }
    if (amper < 200) {
        return "100"
    }

    throw new IllegalStateException("Too high amperage for 3 meter: " + String.format("%.2f", amper) + " for " + getRelationshipName(rel))
}

def getSquareForTemp20Meter5(amper, rel) {
    if (amper < 1) {
        return "1"
    }
    if (amper < 2) {
        return "1.5"
    }
    if (amper < 3) {
        return "2.5"
    }
    if (amper < 4) {
        return "4"
    }
    if (amper < 8) {
        return "6"
    }
    if (amper < 10) {
        return "10"
    }
    if (amper < 20) {
        return "16"
    }
    if (amper < 30) {
        return "25"
    }
    if (amper < 50) {
        return "50"
    }
    if (amper < 100) {
        return "75"
    }
    if (amper < 140) {
        return "100"
    }

    throw new IllegalStateException("Too high amperage for 5 meter: " + String.format("%.2f", amper) + " for " + getRelationshipName(rel))
}

def getSquareForTemp20(amper, length, rel) {
    if (length <= 0.5) {
        return getSquareForTemp20Meter05(amper, rel)
    }
    if (length <= 1) {
        return getSquareForTemp20Meter1(amper, rel)
    }
    if (length <= 2) {
        return getSquareForTemp20Meter2(amper, rel)
    }
    if (length <= 3) {
        return getSquareForTemp20Meter3(amper, rel)
    }
    if (length <= 5) {
        return getSquareForTemp20Meter5(amper, rel)
    }

    throw new IllegalStateException("Too long distance: " + String.format("%.2f", length) + " for " + getRelationshipName(rel))
}

def getTemperatureCoefficient(temperature, rel) {
    if (temperature <= 20) {
        return  1.0
    }
    if (temperature <= 30) {
        return 0.95
    }
    if (temperature <= 50) {
        return 0.86
    }
    if (temperature <= 80) {
        return 0.66
    }

    throw new IllegalStateException("Incorrect temperature: " + String.format("%.2f", temperature) + " for " + getRelationshipName(rel))
}


def getSquare(amper, temperature, length, rel) {

    tempCoeff = getTemperatureCoefficient(temperature, rel)
    return getSquareForTemp20(amper / tempCoeff, length, rel)
}


workspace.model.getRelationships().findAll {rel ->
    ((rel.getProperties().containsKey("amper")) && !rel.getTags().contains("internal_connection"))
}.each {rel ->
    relProps = rel.getProperties()
    def amper = relProps.getAt("amper").toFloat()
    
    if (!relProps.containsKey("length_to_power_source")) {
        throw new IllegalStateException("relationship " + getRelationshipName(rel) + " does not contains `length_to_power_source` property!")
    }
    def length = relProps.getAt("length_to_power_source").toFloat()

    def temperature = relProps.getOrDefault("temperature", "30").toFloat()

    println(" relationship: " + getRelationshipName(rel) + ", amper: " + amper + ", temp: " + temperature)

    square = getSquare(amper, temperature, length, rel)
    
    desc = rel.getDescription()
    if (desc.size() != 0) {
        desc += ", "
    }
    rel.setDescription(desc + String.format("%.2f", amper) + "A" + "\n" + square + " мм2")




    rel.addTags("square_" + square)
    rel.addTags("powered")
}
