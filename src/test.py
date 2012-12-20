import pyexip

strm = pyexip.EXIStream()

serialize = pyexip.serialize()

serialize.initHeader(strm)
serialize.setHasCookie(strm)

buf = pyexip.BinaryBuffer(1024)

serialize.initStream(strm, buf)


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

print buf
print "".join(["%02x " % ord(str(buf)[i]) for i in range(0, len(buf))])

f = open("output.exi", "wb")
for c in str(buf):
    if c == 0:
        break
    f.write(c)
f.close()

