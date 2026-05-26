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
    def __init__(self, token):
        self._token = token

    def get(self):
        return self._token

class StringArgumentInfo(ArgumentInfo):
    def __init__(self, token):
        super().__init__('"' + token + '"')
    

class ContainerInfo:
    def __init__(self, variableName: str, type: str, ctorArgs: list[ArgumentInfo]):
        self.variableName = variableName
        self.type = type
        #self.tags: list[str]
        self.ctorArgs = ctorArgs

class ComponentInfo:
    def __init__(self, variableName):
        self.variableName = variableName

class RelationshipInfo:
    def __init__(self, srcId: str, dstId: str, length: float, square: float, color: str, internalConnection: bool):
        self.srcId = srcId
        self.dstId = dstId
        self.length = length
        self.square = square
        self.color = color
        self.internalConnection = internalConnection


CONTAINERS: dict[str, ContainerInfo] = {
}

COMPONENTS: dict[str, ComponentInfo] = {
}

RELATIONSHIPS: dict[str: RelationshipInfo] = {
}

def getVariableName(element):
    properties = element['properties']
    return properties['structurizr.dsl.identifier'].removeprefix('es.')

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
        length = float(props.get('length', 1000))
        square = float(props.get('square', 1000))
        colorId = int(props.get('color', 0))
        RELATIONSHIPS[id] = RelationshipInfo(srcId, dstId, length, square, 'COLOR.' + list(COLOR)[colorId].value, False)


def parseComponent(component):
    id = component['id']
    variableName = getVariableName(component)
    COMPONENTS[id] = ComponentInfo(variableName)


def fillRelationshipsAndComponents(container):
    print('fill relationships')
    for component in container.get('components', []):
        parseComponent(component)
        rels = component.get('relationships', [])
        for rel in rels:
            if 'linkedRelationshipId' in rel:
                print(f'Skip rel with id `{rel["id"]}`')
            else:
                parseRelationship(rel)

def parseRelay(id, name, variableName, container):
    type = 'Relay'
    if 'relay5' in container['tags']:
        type = 'Relay5'
    
    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    
def parseFuse(id, name, variableName, container):
    type = 'Fuse'
    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseSwitch(id, name, variableName, container):
    type = 'SimpleSwitch'
    tags = container['tags'].split(',')
    if 'switch_3states_6slots' in tags:
        type = 'Switch3States6Pins'

    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)


def parseAkb(id, name, variableName, container):
    type = 'Akb'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('12.0')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseStarter(id, name, variableName, container):
    type = 'Starter'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('300'), ArgumentInfo('20')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseStarter: search for components and get amper properties')

def parseGenerator(id, name, variableName, container):
    type = 'Generator'
    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseChassis(id, name, variableName, container):
    type = 'Ground'
    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseSplitter(id, name, variableName, container):
    type = 'Pin'
    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseWinch(id, name, variableName, container):
    type = 'Winch'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('300')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseFan(id, name, variableName, container):
    type = 'Fan'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('8')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseFan: search for component with suffix .motor and get amper property')

def parseSensor(id, name, variableName, container):
    type = 'Sensor'
    ctorArgs = [StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseCarHorn(id, name, variableName, container):
    type = 'CarHorn'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseLight(id, name, variableName, container):
    type = 'Light'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseLight: search for component with suffix .lamp and get amper property')

def parseElectricPump(id, name, variableName, container):
    type = 'ElectricPump'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseElectricPump: search for component with suffix .motor and get amper property')

def parseHeater(id, name, variableName, container):
    type = 'Heater'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseHeater: search for component with suffix .motor and get amper property')

def parseResistor(id, name, variableName, container):
    type = 'Resistor'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseWipers(id, name, variableName, container):
    type = 'Wipers'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseWipers: search for component with suffix .motor and get amper property')

def parseWindshieldWasher(id, name, variableName, container):
    type = 'WinshieldWasher'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseWindshieldWasher: search for component with suffix .motor and get amper property')

def SkipTag(id, name, variableName, container):
    print(f'Skipping container with id `{id}`...')

def parseGauge(id, name, variableName, container):
    type = 'Gauge'
    ctorArgs = [StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    print('TODO: parseGauge: search for component with suffix .motor and get amper property')

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
    'electric_pump': parseElectricPump,
    'heater': parseHeater,
    'resistor': parseResistor,
    'wipers': parseWipers,
    'windshield_washer': parseWindshieldWasher,
    'transmitter': SkipTag,
    'car_radio': SkipTag,
    'usb_charger': SkipTag,
    'gauge': parseGauge
}

def parseContainer(container):
    tags = container['tags'].split(',')
    for tag in tags:
        if tag in CONTAINER_PARSERS:
            id = container['id']
            name = container['name']
            variableName = getVariableName(container)
            CONTAINER_PARSERS[tag](id, name, variableName, container)
            fillRelationshipsAndComponents(container)
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


print('')
for id, object in CONTAINERS.items():
    print(f'{object.variableName} = {object.type}(uaz, {', '.join(arg.get() for arg in object.ctorArgs)})')

print('')
for id, rel in RELATIONSHIPS.items():
    srcVarName = COMPONENTS[rel.srcId].variableName
    dstVarName = COMPONENTS[rel.dstId].variableName
    print(f'{dstVarName}.addConnectionTo({srcVarName}, {rel.length}, {rel.square}, {rel.color})')
    #print(f'rel {srcVarName} -> {dstVarName}, length: `{rel.length}`, square: `{rel.square}`, color: `{rel.color}`, internal: {rel.internalConnection}')
