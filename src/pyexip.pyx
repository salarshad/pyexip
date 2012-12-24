cimport pyexipd

from libc.stdlib cimport malloc, calloc, free
cdef extern from "stdlib.h":
     void *memcpy(void *dst, void *src, long n)
     
cdef extern from "stdlib.h":
     void *memset( void * ptr, int value, size_t num)  

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


     
cdef class BinaryBuffer:
    cdef pyexipd.BinaryBuffer obj
    def __cinit__(self, size_t size_in_bytes):
        self.initialize(size_in_bytes)

    def initialize(self, size_t size_in_bytes):
        self.obj.buf = <char*>calloc(size_in_bytes * sizeof(char), sizeof(char))
        self.obj.bufLen = size_in_bytes
        self.obj.bufContent = 0
        self.obj.ioStrm.stream = NULL

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
            
    

#    cdef struct ccEXIheader:
        # unsigned char has_cookie
        # unsigned char has_options
        # unsigned char is_preview_version
        # int16_t version_number
        # EXIOptions opts

cdef class EXIheader:
    cdef pyexipd.EXIheader obj
    def __cinit__(self, unsigned char has_cookie, unsigned char has_options):
        memset(&self.obj, 0, sizeof(pyexipd.EXIheader))

        self.obj.has_cookie = has_cookie
        self.obj.has_options = has_options
        
