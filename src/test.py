import pyexip

strm = pyexip.EXIStream()

serialize = pyexip.serialize()

serialize.initHeader(strm)
serialize.setHasCookie(strm)

buf_out = pyexip.BinaryBuffer(1024)

serialize.initStream(strm, buf_out)

'''
<?xml version="1.0" encoding="UTF??8"?>
<xp:rootElement xmlns:xp="http://www.ltu.se/exip"
    testAttribute="attribute_value ">
  element_value
</xp:rootElement>
'''

target = pyexip.String("http://www.ltu.se/exip")
empty = pyexip.String("")
rootelem = pyexip.String("rootElement")
testattr = pyexip.String("testAttribute")

serialize.exiHeader(strm)
serialize.startDocument(strm)


qname = pyexip.QName()


qname.uri = target
qname.localName = rootelem
serialize.startElement(strm, qname)


qname.uri = empty
qname.localName = testattr
serialize.attribute(strm, qname)

ch = pyexip.String("")

pyexip.asciiToString("attribute_value", ch, strm)

serialize.stringData(strm, ch)

pyexip.asciiToString("element_value", ch, strm)

serialize.stringData(strm, ch)

serialize.endElement(strm)
serialize.endDocument(strm)

serialize.closeEXIStream(strm)

print buf_out
print "".join(["%02x " % ord(str(buf_out)[i]) for i in range(0, len(buf_out))])

f = open("output.exi", "wb")
for c in str(buf_out):
    if c == 0:
        break
    f.write(c)
f.close()


'''
Parser
'''
OUT_EXI = 0
OUT_XML = 1
MAX_PREFIXES = 10

parser = pyexip.Parser()
buf_in = pyexip.BinaryBuffer(1024)



def lookupPrefix(aData, ns):
    prefixIndex = 0
    prxHit = 0
    error = 0
    for i in range(0, aData.prefixesCount):
        if ns == aData.prefixes[i]:
            prefixIndex = i
            prxHit = 1
            return 0, prxHit, prefixIndex

    if aData.prefixesCount == MAX_PREFIXES:
        return 0, prxHit, prefixIndex
    else:
        aData.prefixes.append(ns)
        prefixIndex = len(aData) - 1
        aData.prefixesCount = len(aData)
        prxHit = 0
        return 0, prxHit, prefixIndex
    
class appData:
    def __init__(self):
        self.outputFormat = ""
        self.expectAttributeData = 0
        self.nameBuf = ""
        self.stack = []
        self.unclosedElement = 0
        self.prefixes = []
        self.prefixesCount = 0



def samplefatalError(code, msg):
    print "\n%d : FATAL ERROR: %s\n" % (code, msg)
    return pyexip.EXIP_HANDLER_STOP;

def sample_startDocument(app_data):
    if app_data.outputFormat == OUT_EXI:
        print "SD\n",
    elif app_data.outputFormat == OUT_XML:
        print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
    return pyexip.EXIP_HANDLER_OK
    
def sample_endDocument(app_data):
    if app_data.outputFormat == OUT_EXI:
        print "ED\n",
    elif app_data.outputFormat == OUT_XML:
        print "\n",
    return pyexip.EXIP_HANDLER_OK

def sample_startElement(qname, app_data):
    if app_data.outputFormat == OUT_EXI:
        print "SE ", qname.uri, " ", qname.localName, "\n",

    elif app_data.outputFormat == OUT_XML:
        error = 0
        prefixIndex = 0
        prxHit = 1
        t=0

        if len(qname.uri) != 0:
            error, prxHit, prefixIndex = lookupPrefix(app_data, qname.uri)
            if(error != 0):
                return pyexip.EXIP_HANDLER_STOP

            app_data.nameBuf = "p%d:" % prefixIndex
            t = len(app_data.nameBuf)
            app_data.nameBuf += qname.localName
        else:
            app_data.nameBuf = qname.localName
        app_data.stack.insert(0, app_data.nameBuf)
        if app_data.unclosedElement:
            print ">\n",
        print "<%s" % app_data.nameBuf,

        if prxHit == 0:
            app_data.nameBuf = " xmlns:p%d=\"" % prefixIndex
            print app_data.nameBuf, qname.uri, "\"",
        app_data.unclosedElement = 1

    return pyexip.EXIP_HANDLER_OK

def sample_endElement(app_data):
    if app_data.outputFormat == OUT_EXI:
        print "EE\n",
    elif app_data.outputFormat == OUT_XML:
        if app_data.unclosedElement:
            print ">\n",
        app_data.unclosedElement = 0;
        el = app_data.stack.pop()
        print "</%s>\n" % el.name,
    return pyexip.EXIP_HANDLER_OK

def sample_attribute(qname, app_data):
    if app_data.outputFormat == OUT_EXI:
        print "AT ", 
        print qname.uri,
        print " ",
        print qname.localName,
        print "=\"" 
    elif app_data.outputFormat == OUT_XML:
        print " ",
        if qname.uri:
            print qname.uri,
            print ":",
        print qname.localName,
        print "=\"",
    app_data.expectAttributeData = 1

    return pyexip.EXIP_HANDLER_OK

def sample_stringData(value, app_data):
    if app_data.outputFormat == OUT_EXI:
        if app_data.expectAttributeData:
            print value, "\"\n",
            app_data.expectAttributeData = 0
        else:
            print "CH ", value, "\n",

    elif app_data.outputFormat == OUT_XML:
        if app_data.expectAttributeData:
            print value, "\"",
            app_data.expectAttributeData = 0
        else:
            if app_data.unclosedElement:
                print ">\n",
            app_data.unclosedElement = 0;
            print value, "\n",
    return pyexip.EXIP_HANDLER_OK

parser.set_fatalError(samplefatalError)
parser.set_error(samplefatalError)
parser.set_startDocument(sample_startDocument)
parser.set_endDocument(sample_endDocument)
parser.set_startElement(sample_startElement)
parser.set_endElement(sample_endElement)
parser.set_attribute(sample_attribute)
parser.set_stringData(sample_stringData)

app_data = appData()

pyexip.initParser(parser, buf_in, app_data)
print "initParser"
errorcode = pyexip.ERR_OK;
errorcode = pyexip.parseHeader(parser);
print "parseHeader"
count = 0

while errorcode == pyexip.ERR_OK:
    errorcode = pyexip.parseNext(parser)

pyexip.destroyParser(parser)

if errorcode != pyexipd.PARSING_COMPLETE:
    print "\nError during parsing of the EXI stream: %d" % errorcode'''
