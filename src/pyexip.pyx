cimport pyexipd

from libc.stdlib cimport malloc, calloc, free
cdef extern from "stdlib.h":
     void *memcpy(void *dst, void *src, long n)
     
cdef extern from "stdlib.h":
     void *memset( void * ptr, int value, size_t num)  

cdef extern from "Python.h":
    object PyString_FromStringAndSize(char *, Py_ssize_t)
    char *PyString_AsString(object)

cdef class EXIStream:
    cdef pyexipd.EXIStream obj
        
    cdef pyexipd.EXIStream * getStream(self):
        return &self.obj
    # def __cinit__(self):
    #     self.header = __EXI_Header(self.obj)

# Available Constants
EXIP_HANDLER_OK = pyexipd.EXIP_HANDLER_OK
EXIP_HANDLER_STOP = pyexipd.EXIP_HANDLER_STOP
ERR_OK = pyexipd.ERR_OK
    
cdef class String:
    cdef pyexipd.String obj
    cdef char * str_ptr
    cdef int malloced
    def __cinit__(self, the_string):
        self.malloced = 0
        self.obj = pyexipd.String()
        self.str_ptr = NULL

        if len(the_string) > 0:
            self.obj.str = <char*>calloc(len(the_string) + 1, sizeof(char))
            if self.obj.str is not NULL:
                self.malloced = 1
                self.str_ptr = PyString_AsString(the_string)
                memset(self.obj.str, 0, len(the_string) + 1)
                memcpy(self.obj.str, self.str_ptr, len(the_string))
                self.obj.length = len(the_string)
        else:
            self.obj.str = NULL
            self.obj.length = 0

    def __dealloc__(self):
        if self.obj.str is not NULL and self.malloced == 1:
            #print " ---- __dealloc__ (%d) %s" % (self.obj.length, self.obj.str)
            free(self.obj.str)
            self.obj.str = NULL
          
cdef class QName:
    cdef pyexipd.QName obj

    def __cinit__(self):
        self.obj.uri = NULL
        self.obj.localName = NULL
        self.obj.prefix = NULL
    
    property uri:
        def __get__(self):
            return self.obj.uri.str
        def __set__(self, String value):
            self.obj.uri = &value.obj
        def __del__(self):
            self.obj.uri = NULL   

    property localName:
        def __set__(self, String value):
            self.obj.localName = &value.obj
        def __del__(self):
            self.obj.localName = NULL 

    property prefix:
        def __set__(self, String value):
            self.obj.prefix = &value.obj
        def __del__(self):
            self.obj.prefix = NULL 

#define SET_STRICT(p)                 ((p) = (p) | STRICT)
# def SET_STRICT(int):
#     pass

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
        #pyexipd.SET_STRICT(strm.obj.header.opts.enumOpt)

    def initStream(self, EXIStream strm, BinaryBuffer buffer):
        pyexipd.initStream(&strm.obj, buffer.obj, NULL, pyexipd.SCHEMA_ID_ABSENT, NULL)

    def exiHeader(self, EXIStream strm):
        pyexipd.encodeHeader(&strm.obj)

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

callback_fatalError = None
callback_error = None
callback_startDocument = None
callback_endDocument = None
callback_startElement = None
callback_attribute = None
callback_endElement = None

cdef char sample_fatalError(char code, char* msg, void* app_data):
    (<object>callback_fatalError)(code, msg)
cdef char sample_error(char code, char* msg, void* app_data):
    (<object>callback_error)(code, msg)        
cdef char sample_startDocument(void* app_data):
    (<object>callback_startDocument)()
cdef char sample_endDocument(void* app_data):
    (<object>callback_endDocument)()    
cdef char sample_startElement(pyexipd.QName qname, void * app_data):
    cdef QName qname_temp = QName()
    qname_temp.obj = qname
    (<object>callback_startElement)(qname_temp)
cdef char sample_attribute(pyexipd.QName qname, void * app_data):
    cdef QName qname_temp = QName()
    qname_temp.obj = qname
    (<object>callback_attribute)(qname_temp)    
cdef char sample_stringData(pyexipd.String string, void * app_data):
    cdef Py_ssize_t length = string.length
    cdef bytes py_string = string.str[:length]
    cdef String string_temp = String(py_string)
    (<object>callback_stringData)(string_temp)
cdef char sample_endElement(void * app_data):
    (<object>callback_endElement)()


# cdef class handler:
    # cdef pyexipd.Parser * p
    # def __cinit__(self, pyexipd.Parser * parser):
        # self.p = pyexipd.Parser()
        # self.p = parser
    
cdef class Parser:
    cdef pyexipd.Parser obj
    def __cinit__(self):
        self.obj = pyexipd.Parser()
        
    def set_fatalError(self, f):
        global callback_fatalError
        callback_fatalError = f
        self.obj.handler.fatalError = sample_fatalError
    def set_error(self, f):
        global callback_error
        callback_error = f
        self.obj.handler.error = sample_error    
    def set_startDocument(self, f):
        global callback_startDocument
        callback_startDocument = f
        self.obj.handler.startDocument = sample_startDocument 
    def set_endDocument(self, f):
        global callback_endDocument
        callback_endDocument = f
        self.obj.handler.endDocument = sample_endDocument 
    def set_startElement(self, f):
        global callback_startElement
        callback_startElement = f
        self.obj.handler.startElement = sample_startElement 
    def set_attribute(self, f):
        global callback_attribute
        callback_attribute = f
        self.obj.handler.attribute = sample_attribute
    def set_stringData(self, f):
        global callback_stringData
        callback_stringData = f
        self.obj.handler.stringData = sample_stringData
    def set_endElement(self, f):
        global callback_endElement
        callback_endElement = f
        self.obj.handler.endElement = sample_endElement


cdef class ApplicationData:
    cdef pyexipd.applicationData obj
    def __cinit__(self):
        self.obj.elementCount = 0
        self.obj.nestingLevel = 0  

    property elementCount:
        def __get__(self):
            return self.obj.elementCount
        def __set__(self, int value):
            self.obj.elementCount = value
        def __del__(self):
            self.obj.elementCount = 0

    property nestingLevel:
        def __get__(self):
            return self.obj.nestingLevel
        def __set__(self, int value):
            self.obj.nestingLevel = value
        def __del__(self):
            self.obj.nestingLevel = 0  
    
def initParser(Parser parser, BinaryBuffer buffer, app_data):
    if app_data is None:
        pyexipd.initParser(&parser.obj, buffer.obj, NULL, NULL)
    else:
        pyexipd.initParser(&parser.obj, buffer.obj, NULL, <void*>app_data)
    
def parseHeader(Parser parser):
    return pyexipd.parseHeader(&parser.obj)
    
def parseNext(Parser parser):
    return pyexipd.parseNext(&parser.obj)
    
def destroyParser(Parser parser):
    pyexipd.destroyParser(&parser.obj)

cdef class BinaryBuffer:
    cdef pyexipd.BinaryBuffer obj
    def __cinit__(self, size_t size_in_bytes):
        self.initialize(size_in_bytes)

    def initialize(self, size_t size_in_bytes):
        self.obj.buf = <char*>calloc(size_in_bytes * sizeof(char), sizeof(char))
        self.obj.bufLen = size_in_bytes
        self.obj.bufContent = 0
        self.obj.ioStrm.stream = NULL
        self.obj.ioStrm.readWriteToStream = NULL

    def content(self):
        return self.obj.bufContent
        
    def __len__(self):
        return self.obj.bufLen
        
    def __repr__(self):
        cdef Py_ssize_t length = self.obj.bufLen
        cdef bytes py_string = self.obj.buf[:length]
        return py_string
        
    def __dealloc__(self):
        if self.obj.buf is not NULL:
            free(self.obj.buf)
            self.obj.buf = NULL

cdef class EXIheader:
    cdef pyexipd.EXIheader obj
    def __cinit__(self, unsigned char has_cookie, unsigned char has_options):
        memset(&self.obj, 0, sizeof(pyexipd.EXIheader))

        self.obj.has_cookie = has_cookie
        self.obj.has_options = has_options
        
