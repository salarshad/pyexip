cimport pyexipd

from libc.stdlib cimport malloc, free
cdef extern from "stdlib.h":
     void *memcpy(void *dst, void *src, long n)

cdef extern from "Python.h":
    object PyString_FromStringAndSize(char *, Py_ssize_t)
    char *PyString_AsString(object)

#cdef struct EXIStream:
#    BinaryBuffer buffer
#    ccEXIheader header
#    StreamContext context
#    ValueTable valueTable
#    EXIGrammarStack * gStack
#    AllocList memList
#    EXIPSchema * schema     

# cdef class __EXI_Header:
#     pass

cdef class EXIStream:
    cdef pyexipd.EXIStream obj
        
    cdef pyexipd.EXIStream * getStream(self):
        return &self.obj
    # def __cinit__(self):
    #     self.header = __EXI_Header(self.obj)

cdef class  String:
    cdef pyexipd.String obj
    cdef char * str_ptr
    def __cinit__(self, the_string):
        self.obj = pyexipd.String()
        self.str_ptr = NULL

        self.obj.str = <pyexipd.CharType*>malloc(len(the_string))
        if self.obj.str is not NULL:
            self.str_ptr = PyString_AsString(the_string)
            memcpy(self.obj.str, self.str_ptr, len(the_string))
            self.obj.length = len(the_string)

    def __dealloc__(self):
        if self.obj.str is not NULL:
            free(self.obj.str)

cdef class QName:
    cdef pyexipd.QName obj

    def __cinit__(self):
        #TODO: property prefix
        self.obj.prefix = NULL
    
    property uri:
        ''' uri '''
        def __set__(self, String value):
            self.obj.uri = &value.obj
        def __del__(self):
            self.obj.uri = NULL   

    property localName:
        ''' local name '''
        def __set__(self, String value):
            self.obj.localName = &value.obj
        def __del__(self):
            self.obj.localName = NULL   



def asciiToString(char * the_string, String ch, EXIStream strm):
    pyexipd.asciiToString(the_string, &ch.obj, &strm.obj.memList, pyexipd.FALSE)


cdef class serialize:
    def __cinit__(self):
        pass
        
    def initHeader(self, EXIStream strm):
        pyexipd.initHeader(&strm.obj)

    def setHasCookie(self, EXIStream strm):
        strm.obj.header.has_options = 1
        strm.obj.header.has_cookie = 1

    def initStream(self, EXIStream strm, BinaryBuffer buffer):
        pyexipd.initStream(&strm.obj, buffer.obj, NULL, pyexipd.SCHEMA_ID_ABSENT, NULL)

    def exiHeader(self, EXIStream strm):
        pyexipd.exiHeader(&strm.obj)

    def startDocument(self, EXIStream strm):
        pyexipd.startDocument(&strm.obj)

    def startElement(self, EXIStream strm, QName qname):
        pyexipd.startElement(&strm.obj, qname.obj)

    def attribute(self, EXIStream strm, QName qname):
        pyexipd.attribute(&strm.obj, qname.obj, pyexipd.VALUE_TYPE_STRING)

    def stringData(self, EXIStream strm, String ch):
        pyexipd.stringData(&strm.obj, ch.obj)

    def endElement(self, EXIStream strm):
        pyexipd.endElement(&strm.obj)

    def endDocument(self, EXIStream strm):
        pyexipd.endDocument(&strm.obj)

    def closeEXIStream(self, EXIStream strm):
        pyexipd.closeEXIStream(&strm.obj)


     
cdef class BinaryBuffer:
    cdef pyexipd.BinaryBuffer obj
    def __cinit__(self, size_t size_in_bytes):
        self.initialize(size_in_bytes)

    def initialize(self, size_t size_in_bytes):
        self.obj.buf = <char*>malloc(size_in_bytes * sizeof(char))
        self.obj.bufLen = size_in_bytes
        self.obj.bufContent = 0
        self.obj.ioStrm.stream = NULL
        
    def __len__(self):
        return self.obj.bufLen
  
    def __dealloc__(self):
        if self.obj.buf is not NULL:
            free(self.obj.buf)

#    cdef struct ccEXIheader:
        # unsigned char has_cookie
        # unsigned char has_options
        # unsigned char is_preview_version
        # int16_t version_number
        # EXIOptions opts

cdef class EXIheader:
    cdef pyexipd.cEXIheader obj
    def __cinit__(self, unsigned char has_cookie, unsigned char has_options):
        memcpy(&self.obj, NULL, sizeof(pyexipd.cEXIheader))

        self.obj.has_cookie = has_cookie
        self.obj.has_options = has_options
        
