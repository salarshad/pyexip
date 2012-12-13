'''
Public interface

Python version: 2.6 and above

WARNING: This is currently only for concept demonstration. This code does not work!
'''

import c_pyexip

class Serialize:
    ''' Encode XML to EXI '''

    def __init__(self, input, schema=None, options=None, output_file=None):
        self.input = input
        self.stream = c_pyexip.EXIStream()
        self.output_file = output_file

        c_pyexip.initHeader(self.stream)

        self.set_options(options)
        self.__initialize_buffer()

    def encode(self):
        '''
        iterate over input xml.etree.Elementree structure (or XML string ?)
        and call the necessary functions
        '''
        c_pyexip.exiHeader(self.stream)
        c_pyexip.startDocument(self.stream)

        uri = self.__get_uri(input)
        local_name = self.__get_local_name(input)
        prefix = self.__get_prefix(input)

        qname = c_pyexip.Qname()
        qname.uri = uri
        qname.localName = local_name
        qname.prefix = prefix

        c_pyexip.startElement(self.stream, qname)

        qname.uri = ""
        qname.localName = "some_attribute"

        c_pyexip.attribute(self.stream, qname, c_pyexip.VALUE_TYPE_STRING)

        ch = c_pyexip.String()
        c_pyexip.asciiToString("some_attribute_value", ch, self.stream.memList, False)

        c_pyexip.stingData(self.stream, ch)

        c_pyexip.endElement(self.stream)

        c_pyexip.endDocument(self.stream)

        c_pyexip.closeEXIStream(self.stream)


    def set_options(self, options):
        if options is not None:
            self.stream.has_options = options["has_options"]
            self.stream.has_cookie = options["has_cookie"]
            if options["strict"]:
                c_pyexip.SET_STRICT(self.stream.header.opts.enumOpt)

            #TODO: add more options

    def __initialize_buffer(self):
        self.buffer = c_pyexip.BinaryBuffer()
        self.buffer.buf = ""
        self.buffer.bufLen = 0
        self.buffer.bufContent = 0
        if self.output_file is not None:
            self.buffer.ioStrm.readWriteToStream = self.writeToFileOutputStream
            self.buffer.ioStrm.stream = open(self.output_file, "wb")

        else:
            self.buffer.ioStrm.readWriteToStream = None
            self.buffer.ioStrm.stream = None

    





