workspace.model.getRelationships().each {rel ->
    amper = rel.getProperties().getOrDefault("amper", "0").toFloat()
    desc = rel.getDescription()
    if (desc.size() != 0) {
        desc += ", "
    }
    rel.setDescription(desc + "amper: " + String.format("%.2f", amper))

    square = "0.5"
    if (amper < 3.6) {
        square = "0.5"
    }
    if (amper < 4.75) {
        square = "0.75"
    }
    if (amper < 5.7) {
        square = "1"
    }
    if (amper < 7.22) {
        square = "1.5"
    }
    if (amper < 9.88) {
        square = "2.5"
    }
    if (amper < 13.49) {
        square = "4"
    }
    if (amper < 17.86) {
        square = "6"
    }
    if (amper < 33.63) {
        square = "16"
    }


    //rel.addTags("square_" + square)
}
