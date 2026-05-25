import json
from enum import StrEnum


class COLOR(StrEnum):
    Black = 'black'
    Red = 'red'
    Blue = 'blue'
    White = 'white'
    Green = 'green'
    Yellow = 'yellow'
    Brown = 'brown'
    Orange = 'orange'
    Pink = 'pink'
    Violet = 'violet'
    Grey = 'grey'


class ArgumentInfo:
    def __init__(self):
        self.variableName = ''
        self.id = ''
        self.initialized = False

    @classmethod
    def fromArgument(cls, variableName):
        res = cls()
        res.variableName = variableName
        res.initialized = True

        return res

    @classmethod
    def fromId(cls, id):
        res = cls()
        res.id = id
        res.initialized = False

        return res


class ObjectInfo:
    def __init__(self, variableName: str, type: str, ctorArgs: list[ArgumentInfo]):
        self.variableName = variableName
        self.type = type
        #self.tags: list[str]
        self.ctorArgs = ctorArgs



class RelationshipInfo:
    def __init__(self, srcId: str, dstId: str, length: float, square: float, color: str, internalConnection: bool):
        self.srcId = srcId
        self.dstId = dstId
        self.length = length
        self.square = square
        self.color = color
        self.internalConnection = internalConnection


OBJECTS: dict[str, ObjectInfo] = {
}


RELATIONSHIPS: dict[str: RelationshipInfo] = {

}


def parseRelationship(rel):
    id = rel['id']
    print(f'parse rel with id `{id}`...')
    srcId = rel['sourceId']
    dstId = rel['destinationId']
    tags = rel['tags'].split(',')
    if 'internal_connection' in tags:
        RELATIONSHIPS[id] = RelationshipInfo(srcId, dstId, 0, 0, 'COLOR.Black', True)
    else:
        props = rel['properties']
        length = float(props['length'])
        square = float(props['square'])
        colorId = int(props['color'])
        RELATIONSHIPS[id] = RelationshipInfo(srcId, dstId, length, square, 'COLOR.' + list(COLOR)[colorId].value, False)


def fillRelationships(container):
    print('fill relationships')
    for component in container['components']:
        rels = component['relationships']
        for rel in rels:
            if 'linkedRelationshipId' in rel:
                print(f'Skip rel with id `{rel["id"]}`')
            else:
                parseRelationship(rel)



def getVariableName(container):
    properties = container['properties']
    return properties['structurizr.dsl.identifier'].removeprefix('es.').replace('.', '_')



def parseRelay(id, name, variableName, container):
    if 'relay5' in container['tags']:
        return parseRelay5(container)
    
    type = 'Relay'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)
    
def parseFuse(id, name, variableName, container):
    type = 'Fuse'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseSwitch(id, name, variableName, container):
    type = 'SimpleSwitch'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    print('TODO: parseSwitch: add arguments for connected pins')
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)


def parseAkb(id, name, variableName, container):
    type = 'Akb'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('12.0')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseStarter(id, name, variableName, container):
    type = 'Starter'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('300'), ArgumentInfo.fromArgument('20')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseGenerator(id, name, variableName, container):
    type = 'Generator'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseChassis(id, name, variableName, container):
    type = 'Ground'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseSplitter(id, name, variableName, container):
    type = 'Pin'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseWinch(id, name, variableName, container):
    type = 'Winch'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('300')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseFan(id, name, variableName, container):
    type = 'Fan'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('8 или 2')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)
    print('TODO: parseFan: search for component with suffix .motor and get amper property')

def parseSensor(id, name, variableName, container):
    type = 'Sensor'
    ctorArgs = [ArgumentInfo.fromArgument(name)]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)
    print('TODO: parseSensor: add arguments for connected pins')

def parseCarHorn(id, name, variableName, container):
    type = 'CarHorn'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('15')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)

def parseLight(id, name, variableName, container):
    type = 'Light'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('15')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)
    print('TODO: parseLight: search for component with suffix .lamp and get amper property')

def parseElectricPump(id, name, variableName, container):
    type = 'ElectricPump'
    ctorArgs = [ArgumentInfo.fromArgument(name), ArgumentInfo.fromArgument('15')]
    OBJECTS[id] = ObjectInfo(variableName, type, ctorArgs)
    print('TODO: parseElectricPump: search for component with suffix .motor and get amper property')   

CONTAINER_PARSERS = {
    'relay': parseRelay,
    'fuse': parseFuse,
    'switch': parseSwitch,
    'chassis': parseChassis,
    'akb': parseAkb,
    'starter': parseStarter,
    'generator': parseGenerator,
    'splitter': parseSplitter,
    'winch': parseWinch,
    'relay': parseRelay,
    'fan': parseFan,
    'sensor': parseSensor,
    'car_horn': parseCarHorn,
    'light': parseLight,
    'electric_pump': parseElectricPump
}

def parseContainer(container):
    tags = container['tags'].split(',')
    for tag in tags:
        if tag in CONTAINER_PARSERS:
            id = container['id']
            name = container['name']
            variableName = getVariableName(container)
            CONTAINER_PARSERS[tag](id, name, variableName, container)
            fillRelationships(container)
            return

    raise Exception(f'Cannot find parser for container with tags: {tags}')



with open('../workspace.json') as f:
    obj = json.load(f)
    model = obj['model']
    softwareSystems = model['softwareSystems']
    for ss in softwareSystems:
        print(f'processing software system `{ss["name"]}` ...')
        containers = ss['containers']
        for container in containers:
            print(f'processing container `{container["name"]}` ...')
            parseContainer(container)



for id, object in OBJECTS.items():
    print(f'{object.variableName} = {object.type}({", ".join(object.ctorArgs)})')