// https://www.uazbuka.ru/electro.htm#secpr
// https://www.drive2.ru/c/1893545/



// FIZME: copy-paste from graph_validators
def getRelationshipName(relationship) {
    return "{" + relationship.getSource().getCanonicalName() + " -> " + relationship.getDestination().getCanonicalName() + ", tags: " + relationship.getTags().toString() + ", props: " + relationship.getProperties().toString() + "}"
}





/*

// Based on https://xn----jtbncduncbo1j.xn--p1ai/articles/provoda-dlya-avtomobilnoy-provodki/
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


*/


// Based on
//    https://www.drive2.ru/c/1893545/
//    https://elmarts.ru/blog/sovety-pokupatelyam/provoda-dlya-avtomobilnoy-provodki/

MapAmperToLength = [
             /* 0.5,   0.75,  1.0,   1.5,    2.5,    4,      6,      10,    16,     25,     35,     50 ,    75,     100*/
    /*   1A */ [3.5f,  5.25f, 7.0f,  10.91f, 17.65f, 28.57f, 42.86f, 70.6f, 109.1f, 176.5f, 244.9f, 300.0f, 400.0f, 500.0f],
    /*   2A */ [2.0f,  2.76f, 3.53f, 5.45f,  8.82f,  14.29f, 21.4f,  35.3f, 54.5f,  88,2f,  122.4f, 171.4f, 230.0f, 300.0f],
    /*   4A */ [1.2f,  1.48f, 1.76f, 2.73f,  4.41f,  7.7f,   10.7f,  17.6f, 27.3f,  44.1f,  61.2f,  85.7f,  130.0f, 200.0f],
    /*   6A */ [0.9f,  1.04f, 1.18f, 1.82f,  2.94f,  4.76f,  7.1f,   11.7f, 18.2f,  29.4f,  40.8f,  57.1f,  87.0f,  117.6f],
    /*   8A */ [0.65f, 0.76f, 0.88f, 1.36f,  2.2f,   3.47f,  5.4f,   8.8f,  13.6f,  22.0f,  30.6f,  42.9f,  65.25f, 88.2f],
    /*  10A */ [0.5f,  0.6f,  0.71f, 1.0f,   1.76f,  2.86f,  4.3f,   7.1f,  10.9f,  17.7f,  24.5f,  34.3f,  52.2f,  70.6f],
    /*  15A */ [0.35f, 0.42f, 0.5f,  0.73f,  1.18f,  1.9f,   2.9f,   4.7f,  7.3f,   11.8f,  16.3f,  22.9f,  34.8f,  47.1f],
    /*  20A */ [0.0f,  0.1f,  0.3f,  0.5f,   0.88f,  1.43f,  2.1f,   3.5f,  5.5f,   8.8f,   12.2f,  17.1f,  26.1f,  35.3f],
    /*  25A */ [0.0f,  0.0f,  0.1f,  0.35f,  0.6f,   1.14f,  1.7f,   2.8f,  4.4f,   7.1f,   9.8f,   13.7f,  20.9f,  28.2f],
    /*  30A */ [0.0f,  0.0f,  0.0f,  0.1f,   0.4f,   0.9f,   1.4f,   2.4f,  3.6f,   5.9f,   8.2f,   11.4f,  17.4f,  23.5f],
    /*  40A */ [0.0f,  0.0f,  0.0f,  0.0f,   0.1f,   0.6f,   1.0f,   1.8f,  2.7f,   4.4f,   6.1f,   8.5f,   13.0f,  17.6f],
    /*  50A */ [0.0f,  0.0f,  0.0f,  0.0f,   0.0f,   0.3f,   0.6f,   1.2f,  2.2f,   3.5f,   4.9f,   6.9f,   10.4f,  14.1f],
    /* 100A */ [0.0f,  0.0f,  0.0f,  0.0f,   0.0f,   0.0f,   0.0f,   0.4f,  1.2f,   1.7f,   2.4f,   3.4f,   5.2f,   7.1f],
    /* 150A */ [0.0f,  0.0f,  0.0f,  0.0f,   0.0f,   0.0f,   0.0f,   0.0f,  0.4f,   0.6f,   1.0f,   2.3f,   3.5f,   4.7f],
    /* 200A */ [0.0f,  0.0f,  0.0f,  0.0f,   0.0f,   0.0f,   0.0f,   0.0f,  0.0f,   0.0f,   0.5f,   1.0f,   2.6f,   3.5f],
]

MapIndexToSquare = ["0.5", "0.75", "1.0", "1.5", "2.5", "4", "6", "10", "16", "25", "35", "50", "75", "100"]

def getRowForAmper(amper, rel) {
    if (amper <= 1.0f) {
        return 0
    }
    if (amper <= 2.0f) {
        return 1
    }
    if (amper <= 4.0f) {
        return 2
    }
    if (amper <= 6.0f) {
        return 3
    }
    if (amper <= 8.0f) {
        return 4
    }
    if (amper <= 10.0f) {
        return 5
    }
    if (amper <= 15.0f) {
        return 6
    }
    if (amper <= 20.0f) {
        return 7
    }
    if (amper <= 25.0f) {
        return 8
    }
    if (amper <= 30.0f) {
        return 9
    }
    if (amper <= 40.0f) {
        return 10
    }
    if (amper <= 50.0f) {
        return 11
    }
    if (amper <= 100.0f) {
        return 12
    }
    if (amper <= 150.0f) {
        return 13
    }
    if (amper <= 200.0f) {
        return 14
    }

    throw new IllegalStateException("Too high amperage: " + String.format("%.2f", amper) + " for " + getRelationshipName(rel))
}

def getSquareFromLength(row, length, rel) {
    for (int i = 0; i < row.size(); ++i) {
        if (row[i] >= length) {
            return MapIndexToSquare[i]
        }
    }

    throw new IllegalStateException("Too high length: " + String.format("%.2f", length) + " for " + getRelationshipName(rel))
}

def getSquare(amper, temperature, length, rel) {
    def amperRow = getRowForAmper(amper, rel)
    println("row: " + amperRow + ", amper: " + amper + ", rel: " + getRelationshipName(rel))

    def row = MapAmperToLength[amperRow]

    return getSquareFromLength(row, length, rel)
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

    square = getSquare(amper, temperature, length, rel)
    rel.addProperty("square", square)
    
    desc = rel.getDescription()
    if (desc.size() != 0) {
        desc += ", "
    }
    rel.setDescription(desc + String.format("%.2f", amper) + "A" + "\n" + square + " мм2")

    rel.addTags("square_" + square)
    rel.addTags("powered")

    println(" relationship: " + getRelationshipName(rel) + ", amper: " + amper + ", temp: " + temperature)
}


def MapColorIndexToColor = [
    "0": "black",
    "1": "red",
    "2": "blue",
    "3": "white",
    "4": "green",
    "5": "yellow",
    "6": "brown",
    "7": "orange",
    "8": "pink",
    "9": "violet",
    "10": "grey"
]

def WiresTotal = new HashMap<String, TreeSet<String>>()

workspace.model.getRelationships().findAll {rel ->
    (rel.getProperties().containsKey("color"))
}.each {rel ->
    def colorIndex = rel.getProperties().get("color")
    def color = MapColorIndexToColor[colorIndex]
    if (color == null) {
        throw new IllegalStateException("Cannot map color index " + colorIndex + " to color")
    }

    rel.addTags("color_" + color)

    squares = WiresTotal.getOrDefault(color, new TreeSet<String>())
    square = rel.getProperties().get("square")
    if (square != null) {
        squares.add(square)
    }
    WiresTotal.put(color, squares)
}

WiresTotal.each {color, squares ->
    println("COLOR: " + color)
    squares.each {square ->
        println("  " + square + " мм2")
    }
}
