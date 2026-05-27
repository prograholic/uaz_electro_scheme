import json
from enum import StrEnum


class COLOR(StrEnum):
    Black = 'Black'
    Red = 'Red'
    Blue = 'Blue'
    White = 'White'
    Green = 'Green'
    Yellow = 'Yellow'
    Brown = 'Brown'
    Orange = 'Orange'
    Pink = 'Pink'
    Violet = 'Violet'
    Grey = 'Grey'


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
        #RELATIONSHIPS[id] = RelationshipInfo(srcId, dstId, 0, 0, 'COLOR.Black', True)
        print('Skip internal connection')
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

def findComponentPropertiesByName(container, name):
    for component in container['components']:
        props = component['properties']
        if props['structurizr.dsl.identifier'] == 'es.' + name:
            return props
        
    raise Exception(f'Cannot find component with subname `{name}` in container with id `{container["id"]}`')

def parseRelay(id, name, variableName, container):
    type = 'Relay'

    tags = container['tags']
    if 'relay5' in tags:
        type = 'Relay5'

    if 'wipers_relay' in tags:
        type = 'uaz3151.WipersRelay'

    if 'relay950' in tags:
        type = 'uaz3151.TurnSignalRelay950'
    
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)
    
def parseFuse(id, name, variableName, container):
    type = 'Fuse'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo('5')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseSwitch(id, name, variableName, container):
    type = 'SimpleSwitch'
    tags = container['tags'].split(',')
    if 'switch_3states_6slots' in tags:
        type = 'Switch3States6Pins'
    if 'uaz3151_switch' in tags:
        type = 'uaz3151.LightSwitch'
    if 'emer_lght_switch' in tags:
        type = 'uaz3151.EmergencyLightSwitch'
    if 'left_steering_column_turn_signal' in tags:
        type = 'uaz3151.LeftSteeringColumnTurnSignalSwitch'
    if 'right_steering_column' in tags:
        type = 'uaz3151.RightSteeringColumnSwitch'
    if 'left_steering_column_light' in tags:
        type = 'uaz3151.LeftSteeringColumnLightSwitch'

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)


def parseAkb(id, name, variableName, container):
    type = 'Akb'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo('12.0')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseStarter(id, name, variableName, container):
    type = 'Starter'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo('300'), ArgumentInfo('20')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseGenerator(id, name, variableName, container):
    type = 'Generator'

    props = findComponentPropertiesByName(container, variableName + '.v')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo('14.0'), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseChassis(id, name, variableName, container):
    type = 'Pin'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseSplitter(id, name, variableName, container):
    type = 'Pin'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseWinch(id, name, variableName, container):
    type = 'Winch'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo('300')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseFan(id, name, variableName, container):
    type = 'Fan'

    props = findComponentPropertiesByName(container, variableName + '.motor')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)


def parseSensor(id, name, variableName, container):
    type = 'Sensor'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseCarHorn(id, name, variableName, container):
    type = 'CarHorn'

    props = findComponentPropertiesByName(container, variableName + '.horn')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseLight(id, name, variableName, container):
    type = 'Light'

    props = findComponentPropertiesByName(container, variableName + '.lamp')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseElectricPump(id, name, variableName, container):
    type = 'ElectricPump'

    props = findComponentPropertiesByName(container, variableName + '.motor')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)


def parseHeater(id, name, variableName, container):
    type = 'Heater'

    props = findComponentPropertiesByName(container, variableName + '.motor')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)


def parseResistor(id, name, variableName, container):
    type = 'Resistor'
    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo('15')]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseWipers(id, name, variableName, container):
    type = 'Wipers'

    props = findComponentPropertiesByName(container, variableName + '.motor1') # Достаточно одного моторчика, остальное нужно обыграть резистором
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def parseWindshieldWasher(id, name, variableName, container):
    type = 'WindshieldWasher'

    props = findComponentPropertiesByName(container, variableName + '.motor')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)

def SkipTag(id, name, variableName, container):
    print(f'Skipping container with id `{id}`...')

def parseGauge(id, name, variableName, container):
    type = 'Gauge'

    props = findComponentPropertiesByName(container, variableName + '.gauge')
    amperage = props['amper']

    ctorArgs = [ArgumentInfo('uaz'), StringArgumentInfo(name), ArgumentInfo(amperage)]
    CONTAINERS[id] = ContainerInfo(variableName, type, ctorArgs)


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


def updateVarName(varName):
    if varName.endswith('.in'):
        return varName.removesuffix('.in') + '.pin1'

    if varName.endswith('.out'):
        return varName.removesuffix('.out') + '.pin2'
    
    if varName.endswith('.ground'):
        return varName.removesuffix('.ground')
    
    if varName.endswith('splitter.pin'):
        return varName.removesuffix('.pin')

    return varName

def shouldSkip(connectionString: str):
    if connectionString.startswith('ignition.data.'):
        return True
    if connectionString.startswith('starter_relay_fuse.pin2.addConnectionTo(ignition.data'):
        return True

    return False


def modifyConnectionString(connectionString: str):
    if 'control_line_from_ignition_1.pin' in connectionString:
        return connectionString.replace('control_line_from_ignition_1.pin', 'control_line_from_ignition_1')
    if 'control_line_from_ignition_2.pin' in connectionString:
        return connectionString.replace('control_line_from_ignition_2.pin', 'control_line_from_ignition_2')
    
    return connectionString

print('')
for id, object in CONTAINERS.items():
    print(f'{object.variableName} = {object.type}({', '.join(arg.get() for arg in object.ctorArgs)})')

print('')
for id, rel in RELATIONSHIPS.items():
    srcVarName = updateVarName(COMPONENTS[rel.srcId].variableName)
    dstVarName = updateVarName(COMPONENTS[rel.dstId].variableName)

    if srcVarName.endswith('.in'):
        srcVarName.removesuffix('.in')
        srcVarName += '.pin1'

    if srcVarName.endswith('.in'):
        srcVarName.removesuffix('.in')
        srcVarName += '.pin1'

    connectionString = f'{srcVarName}.addConnectionTo({dstVarName}, {rel.length}, {rel.square}, {rel.color})'
    if shouldSkip(connectionString):
        connectionString = '#' + connectionString

    connectionString = modifyConnectionString(connectionString)
    
    print(connectionString)
