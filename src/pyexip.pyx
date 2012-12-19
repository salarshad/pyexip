cdef extern from "../exip-0.4.1/include/grammarGenerator.h":
    ctypedef long unsigned int size_t
    ctypedef size_t Index
    cdef struct cioStream "ioStream":
        size_t(*readWriteToStream)(void *, size_t, void *)
        void * stream

    ctypedef cioStream IOStream
    
    cdef struct BinaryBuffer :
        char * buf
        Index bufLen
        Index bufContent
        IOStream ioStrm
    
    cdef struct allocBlock:
        void * * allocation
        allocBlock * nextBlock
    ctypedef size_t SmallIndex
    cdef struct allocList:
        allocBlock * firstBlock
        allocBlock * lastBlock
        SmallIndex currAllocSlot
    ctypedef allocList AllocList
    ctypedef short unsigned int uint16_t
    cdef struct dynArray:
        size_t entrySize
        uint16_t chunkEntries
        uint16_t arrayEntries
    ctypedef dynArray DynArray
    cdef struct VxEntry:
        Index globalId
    ctypedef VxEntry VxEntry
    cdef struct VxTable:
        DynArray dynArray
        VxEntry * vx
        Index count
    ctypedef VxTable VxTable
    ctypedef char CharType
    cdef struct StringType:
        CharType * str
        Index length
    ctypedef StringType String
    cdef struct LnEntry:
        VxTable vxTable
        String lnStr
        Index elemGrammar
        Index typeGrammar
    ctypedef LnEntry LnEntry
    cdef struct LnTable:
        DynArray dynArray
        LnEntry * ln
        Index count
    ctypedef LnTable LnTable
    cdef struct PfxTable:
        SmallIndex count
        String * pfxStr
    ctypedef PfxTable PfxTable
    cdef struct UriEntry:
        LnTable lnTable
        PfxTable * pfxTable
        String uriStr
    ctypedef UriEntry UriEntry
    cdef struct UriTable:
        DynArray dynArray
        UriEntry * uri
        SmallIndex count
    ctypedef UriTable UriTable
    cdef enum:
        EVENT_SD = 0
    cdef enum:
        EVENT_ED = 1
    cdef enum:
        EVENT_SE_QNAME = 5
    cdef enum:
        EVENT_SE_URI = 6
    cdef enum:
        EVENT_SE_ALL = 7
    cdef enum:
        EVENT_EE = 8
    cdef enum:
        EVENT_AT_QNAME = 2
    cdef enum:
        EVENT_AT_URI = 3
    cdef enum:
        EVENT_AT_ALL = 4
    cdef enum:
        EVENT_CH = 9
    cdef enum:
        EVENT_NS = 10
    cdef enum:
        EVENT_CM = 11
    cdef enum:
        EVENT_PI = 12
    cdef enum:
        EVENT_DT = 13
    cdef enum:
        EVENT_ER = 14
    cdef enum:
        EVENT_SC = 15
    cdef enum:
        EVENT_VOID = 16
    cdef enum EventType:
        EVENT_SD = 0
        EVENT_ED = 1
        EVENT_SE_QNAME = 5
        EVENT_SE_URI = 6
        EVENT_SE_ALL = 7
        EVENT_EE = 8
        EVENT_AT_QNAME = 2
        EVENT_AT_URI = 3
        EVENT_AT_ALL = 4
        EVENT_CH = 9
        EVENT_NS = 10
        EVENT_CM = 11
        EVENT_PI = 12
        EVENT_DT = 13
        EVENT_ER = 14
        EVENT_SC = 15
        EVENT_VOID = 16
    ctypedef EventType EventType
    cdef struct QNameID:
        SmallIndex uriId
        Index lnId
    ctypedef QNameID QNameID
    cdef struct Production:
        EventType eventType
        Index typeId
        QNameID qnameId
        SmallIndex nonTermID
    ctypedef Production Production
    cdef struct GrammarRulePart:
        Production * prod
        Index count
        unsigned char bits
    ctypedef GrammarRulePart GrammarRulePart
    cdef struct GrammarRule:
        GrammarRulePart * part
    ctypedef GrammarRule GrammarRule
    cdef struct EXIGrammar:
        GrammarRule * rule
        SmallIndex count
        unsigned char props
        SmallIndex contentIndex
    ctypedef EXIGrammar EXIGrammar
    cdef enum:
        VALUE_TYPE_NONE = 1
    cdef enum:
        VALUE_TYPE_STRING = 2
    cdef enum:
        VALUE_TYPE_FLOAT = 3
    cdef enum:
        VALUE_TYPE_DECIMAL = 4
    cdef enum:
        VALUE_TYPE_DATE_TIME = 5
    cdef enum:
        VALUE_TYPE_BOOLEAN = 6
    cdef enum:
        VALUE_TYPE_BINARY = 7
    cdef enum:
        VALUE_TYPE_LIST = 8
    cdef enum:
        VALUE_TYPE_QNAME = 9
    cdef enum:
        VALUE_TYPE_UNTYPED = 10
    cdef enum:
        VALUE_TYPE_INTEGER = 20
    cdef enum:
        VALUE_TYPE_SMALL_INTEGER = 21
    cdef enum:
        VALUE_TYPE_NON_NEGATIVE_INT = 22
    cdef enum EXIType:
        VALUE_TYPE_NONE = 1
        VALUE_TYPE_STRING = 2
        VALUE_TYPE_FLOAT = 3
        VALUE_TYPE_DECIMAL = 4
        VALUE_TYPE_DATE_TIME = 5
        VALUE_TYPE_BOOLEAN = 6
        VALUE_TYPE_BINARY = 7
        VALUE_TYPE_LIST = 8
        VALUE_TYPE_QNAME = 9
        VALUE_TYPE_UNTYPED = 10
        VALUE_TYPE_INTEGER = 20
        VALUE_TYPE_SMALL_INTEGER = 21
        VALUE_TYPE_NON_NEGATIVE_INT = 22
    ctypedef EXIType EXIType
    ctypedef long int int64_t
    ctypedef unsigned int uint32_t
    cdef struct SimpleType:
        EXIType exiType
        uint16_t facetPresenceMask
        int64_t max
        int64_t min
        uint32_t length
    ctypedef SimpleType SimpleType
    cdef struct SimpleTypeTable:
        DynArray dynArray
        SimpleType * sType
        Index count
    ctypedef SimpleTypeTable SimpleTypeTable
    cdef struct SchemaGrammarTable:
        DynArray dynArray
        EXIGrammar * grammar
        Index count
    ctypedef SchemaGrammarTable SchemaGrammarTable
    cdef struct enumDefinition:
        Index typeId
        void * values
        SmallIndex count
    ctypedef enumDefinition EnumDefinition
    cdef struct EnumTable:
        DynArray dynArray
        EnumDefinition * enumDef
        Index count
    ctypedef EnumTable EnumTable
    cdef struct EXIPSchema:
        AllocList memList
        UriTable uriTable
        EXIGrammar docGrammar
        SimpleTypeTable simpleTypeTable
        SchemaGrammarTable grammarTable
        Index staticGrCount
        EnumTable enumTable
    ctypedef EXIPSchema EXIPSchema
    ctypedef char errorCode
    errorCode generateSchemaInformedGrammars(BinaryBuffer *, unsigned int, unsigned char, EXIPSchema *)
    void destroySchema(EXIPSchema *)


cdef extern from "../exip-0.4.1/include/EXISerializer.h":
    ctypedef char errorCode
    cdef enum:
        VALUE_TYPE_NONE = 1
    cdef enum:
        VALUE_TYPE_STRING = 2
    cdef enum:
        VALUE_TYPE_FLOAT = 3
    cdef enum:
        VALUE_TYPE_DECIMAL = 4
    cdef enum:
        VALUE_TYPE_DATE_TIME = 5
    cdef enum:
        VALUE_TYPE_BOOLEAN = 6
    cdef enum:
        VALUE_TYPE_BINARY = 7
    cdef enum:
        VALUE_TYPE_LIST = 8
    cdef enum:
        VALUE_TYPE_QNAME = 9
    cdef enum:
        VALUE_TYPE_UNTYPED = 10
    cdef enum:
        VALUE_TYPE_INTEGER = 20
    cdef enum:
        VALUE_TYPE_SMALL_INTEGER = 21
    cdef enum:
        VALUE_TYPE_NON_NEGATIVE_INT = 22
    cdef enum EXIType:
        VALUE_TYPE_NONE = 1
        VALUE_TYPE_STRING = 2
        VALUE_TYPE_FLOAT = 3
        VALUE_TYPE_DECIMAL = 4
        VALUE_TYPE_DATE_TIME = 5
        VALUE_TYPE_BOOLEAN = 6
        VALUE_TYPE_BINARY = 7
        VALUE_TYPE_LIST = 8
        VALUE_TYPE_QNAME = 9
        VALUE_TYPE_UNTYPED = 10
        VALUE_TYPE_INTEGER = 20
        VALUE_TYPE_SMALL_INTEGER = 21
        VALUE_TYPE_NON_NEGATIVE_INT = 22
    ctypedef EXIType EXIType
    ctypedef long unsigned int size_t
    ctypedef size_t Index
    cdef struct ioStream:
        size_t(*readWriteToStream)(void *, size_t, void *)
        void * stream
    ctypedef ioStream IOStream
    cdef struct BinaryBuffer:
        char * buf
        Index bufLen
        Index bufContent
        IOStream ioStrm
    ctypedef BinaryBuffer BinaryBuffer
    ctypedef short int int16_t
    ctypedef char CharType
    cdef struct StringType:
        CharType * str
        Index length
    ctypedef StringType String
    cdef struct DatatypeRepresentationMap:
        void * TODO
    ctypedef DatatypeRepresentationMap DatatypeRepresentationMap
    ctypedef unsigned int uint32_t
    cdef struct EXIOptions:
        unsigned char enumOpt
        unsigned char preserve
        String schemaID
        DatatypeRepresentationMap * drMap
        uint32_t blockSize
        Index valueMaxLength
        Index valuePartitionCapacity
        void * user_defined_data
    ctypedef EXIOptions EXIOptions
    cdef struct EXIheader:
        unsigned char has_cookie
        unsigned char has_options
        unsigned char is_preview_version
        int16_t version_number
        EXIOptions opts
    ctypedef EXIheader EXIheader
    ctypedef size_t SmallIndex
    cdef struct QNameID:
        SmallIndex uriId
        Index lnId
    ctypedef QNameID QNameID
    cdef struct StreamContext:
        Index bufferIndx
        unsigned char bitPointer
        SmallIndex currNonTermID
        QNameID currElem
        QNameID currAttr
        unsigned int expectATData
        Index attrTypeId
    ctypedef StreamContext StreamContext
    ctypedef short unsigned int uint16_t
    cdef struct dynArray:
        size_t entrySize
        uint16_t chunkEntries
        uint16_t arrayEntries
    ctypedef dynArray DynArray
    cdef struct N10ValueEntry4DOT_24E:
        QNameID forQNameId
        Index vxEntryId
    cdef struct ValueEntry:
        N10ValueEntry4DOT_24E locValuePartition
        String valueStr
    ctypedef ValueEntry ValueEntry
    cdef struct hashtable:
        pass
    cdef struct ValueTable:
        DynArray dynArray
        ValueEntry * value
        Index count
        hashtable * hashTbl
        Index globalId
    ctypedef ValueTable ValueTable
    cdef enum:
        EVENT_SD = 0
    cdef enum:
        EVENT_ED = 1
    cdef enum:
        EVENT_SE_QNAME = 5
    cdef enum:
        EVENT_SE_URI = 6
    cdef enum:
        EVENT_SE_ALL = 7
    cdef enum:
        EVENT_EE = 8
    cdef enum:
        EVENT_AT_QNAME = 2
    cdef enum:
        EVENT_AT_URI = 3
    cdef enum:
        EVENT_AT_ALL = 4
    cdef enum:
        EVENT_CH = 9
    cdef enum:
        EVENT_NS = 10
    cdef enum:
        EVENT_CM = 11
    cdef enum:
        EVENT_PI = 12
    cdef enum:
        EVENT_DT = 13
    cdef enum:
        EVENT_ER = 14
    cdef enum:
        EVENT_SC = 15
    cdef enum:
        EVENT_VOID = 16
    cdef enum EventType:
        EVENT_SD = 0
        EVENT_ED = 1
        EVENT_SE_QNAME = 5
        EVENT_SE_URI = 6
        EVENT_SE_ALL = 7
        EVENT_EE = 8
        EVENT_AT_QNAME = 2
        EVENT_AT_URI = 3
        EVENT_AT_ALL = 4
        EVENT_CH = 9
        EVENT_NS = 10
        EVENT_CM = 11
        EVENT_PI = 12
        EVENT_DT = 13
        EVENT_ER = 14
        EVENT_SC = 15
        EVENT_VOID = 16
    ctypedef EventType EventType
    cdef struct Production:
        EventType eventType
        Index typeId
        QNameID qnameId
        SmallIndex nonTermID
    ctypedef Production Production
    cdef struct GrammarRulePart:
        Production * prod
        Index count
        unsigned char bits
    ctypedef GrammarRulePart GrammarRulePart
    cdef struct GrammarRule:
        GrammarRulePart * part
    ctypedef GrammarRule GrammarRule
    cdef struct EXIGrammar:
        GrammarRule * rule
        SmallIndex count
        unsigned char props
        SmallIndex contentIndex
    ctypedef EXIGrammar EXIGrammar
    cdef struct GrammarStackNode:
        EXIGrammar * grammar
        SmallIndex lastNonTermID
        GrammarStackNode * nextInStack
    ctypedef GrammarStackNode EXIGrammarStack
    cdef struct allocBlock:
        void * * allocation
        allocBlock * nextBlock
    cdef struct allocList:
        allocBlock * firstBlock
        allocBlock * lastBlock
        SmallIndex currAllocSlot
    ctypedef allocList AllocList
    cdef struct VxEntry:
        Index globalId
    ctypedef VxEntry VxEntry
    cdef struct VxTable:
        DynArray dynArray
        VxEntry * vx
        Index count
    ctypedef VxTable VxTable
    cdef struct LnEntry:
        VxTable vxTable
        String lnStr
        Index elemGrammar
        Index typeGrammar
    ctypedef LnEntry LnEntry
    cdef struct LnTable:
        DynArray dynArray
        LnEntry * ln
        Index count
    ctypedef LnTable LnTable
    cdef struct PfxTable:
        SmallIndex count
        String * pfxStr
    ctypedef PfxTable PfxTable
    cdef struct UriEntry:
        LnTable lnTable
        PfxTable * pfxTable
        String uriStr
    ctypedef UriEntry UriEntry
    cdef struct UriTable:
        DynArray dynArray
        UriEntry * uri
        SmallIndex count
    ctypedef UriTable UriTable
    ctypedef long int int64_t
    cdef struct SimpleType:
        EXIType exiType
        uint16_t facetPresenceMask
        int64_t max
        int64_t min
        uint32_t length
    ctypedef SimpleType SimpleType
    cdef struct SimpleTypeTable:
        DynArray dynArray
        SimpleType * sType
        Index count
    ctypedef SimpleTypeTable SimpleTypeTable
    cdef struct SchemaGrammarTable:
        DynArray dynArray
        EXIGrammar * grammar
        Index count
    ctypedef SchemaGrammarTable SchemaGrammarTable
    cdef struct enumDefinition:
        Index typeId
        void * values
        SmallIndex count
    ctypedef enumDefinition EnumDefinition
    cdef struct EnumTable:
        DynArray dynArray
        EnumDefinition * enumDef
        Index count
    ctypedef EnumTable EnumTable
    cdef struct EXIPSchema:
        AllocList memList
        UriTable uriTable
        EXIGrammar docGrammar
        SimpleTypeTable simpleTypeTable
        SchemaGrammarTable grammarTable
        Index staticGrCount
        EnumTable enumTable
    ctypedef EXIPSchema EXIPSchema
    cdef struct EXIStream:
        BinaryBuffer buffer
        EXIheader header
        StreamContext context
        ValueTable valueTable
        EXIGrammarStack * gStack
        AllocList memList
        EXIPSchema * schema
    ctypedef EXIStream EXIStream
    cdef struct QName:
        String * uri
        String * localName
        String * prefix
    ctypedef QName QName
    errorCode attribute(EXIStream *, QName, EXIType)
    cdef struct tm:
        int tm_sec
        int tm_min
        int tm_hour
        int tm_mday
        int tm_mon
        int tm_year
        int tm_wday
        int tm_yday
        int tm_isdst
        long int tm_gmtoff
        char * tm_zone
    cdef struct fractionalSecs:
        unsigned char offset
        unsigned int value
    ctypedef fractionalSecs FractionalSecs
    cdef struct EXIPDateTime:
        tm dateTime
        FractionalSecs fSecs
        uint16_t presenceMask
    ctypedef EXIPDateTime EXIPDateTime
    errorCode dateTimeData(EXIStream *, EXIPDateTime)
    errorCode processingInstruction(EXIStream *)
    errorCode endElement(EXIStream *)
    errorCode selfContained(EXIStream *)
    ctypedef int64_t Integer
    errorCode intData(EXIStream *, Integer)
    errorCode booleanData(EXIStream *, unsigned char)
    errorCode binaryData(EXIStream *, char *, Index)
    ctypedef float Decimal
    errorCode decimalData(EXIStream *, Decimal)
    errorCode startElement(EXIStream *, QName)
    errorCode listData(EXIStream *, unsigned int)
    errorCode startDocument(EXIStream *)
    void initHeader(EXIStream *)
    errorCode initStream(EXIStream *, BinaryBuffer, EXIPSchema *, unsigned char, String *)
    errorCode closeEXIStream(EXIStream *)
    cdef struct EXIFloat:
        int64_t mantissa
        int16_t exponent
    ctypedef EXIFloat Float
    errorCode floatData(EXIStream *, Float)
    errorCode namespaceDeclaration(EXIStream *, String, String, unsigned char)
    errorCode stringData(EXIStream *, String)
    errorCode endDocument(EXIStream *)
    errorCode serializeEvent(EXIStream *, unsigned char, Index, QName *)


cdef extern from "../exip-0.4.1/include/EXIParser.h":
    ctypedef char errorCode
    ctypedef long unsigned int size_t
    ctypedef size_t Index
    cdef struct ioStream:
        size_t(*readWriteToStream)(void *, size_t, void *)
        void * stream
    ctypedef ioStream IOStream
    cdef struct BinaryBuffer:
        char * buf
        Index bufLen
        Index bufContent
        IOStream ioStrm
    ctypedef BinaryBuffer BinaryBuffer
    ctypedef short int int16_t
    ctypedef char CharType
    cdef struct StringType:
        CharType * str
        Index length
    ctypedef StringType String
    cdef struct DatatypeRepresentationMap:
        void * TODO
    ctypedef DatatypeRepresentationMap DatatypeRepresentationMap
    ctypedef unsigned int uint32_t
    cdef struct EXIOptions:
        unsigned char enumOpt
        unsigned char preserve
        String schemaID
        DatatypeRepresentationMap * drMap
        uint32_t blockSize
        Index valueMaxLength
        Index valuePartitionCapacity
        void * user_defined_data
    ctypedef EXIOptions EXIOptions
    cdef struct EXIheader:
        unsigned char has_cookie
        unsigned char has_options
        unsigned char is_preview_version
        int16_t version_number
        EXIOptions opts
    ctypedef EXIheader EXIheader
    ctypedef size_t SmallIndex
    cdef struct QNameID:
        SmallIndex uriId
        Index lnId
    ctypedef QNameID QNameID
    cdef struct StreamContext:
        Index bufferIndx
        unsigned char bitPointer
        SmallIndex currNonTermID
        QNameID currElem
        QNameID currAttr
        unsigned int expectATData
        Index attrTypeId
    ctypedef StreamContext StreamContext
    ctypedef short unsigned int uint16_t
    cdef struct dynArray:
        size_t entrySize
        uint16_t chunkEntries
        uint16_t arrayEntries
    ctypedef dynArray DynArray

    cdef struct N10ValueEntry4DOT_24E:
        QNameID forQNameId
        Index vxEntryId


    cdef struct ValueEntry:
        N10ValueEntry4DOT_24E locValuePartition
        String valueStr


    ctypedef ValueEntry ValueEntry


    cdef struct hashtable:
        pass
    cdef struct ValueTable:
        DynArray dynArray
        ValueEntry * value
        Index count
        hashtable * hashTbl
        Index globalId
    ctypedef ValueTable ValueTable
    cdef enum:
        EVENT_SD = 0
    cdef enum:
        EVENT_ED = 1
    cdef enum:
        EVENT_SE_QNAME = 5
    cdef enum:
        EVENT_SE_URI = 6
    cdef enum:
        EVENT_SE_ALL = 7
    cdef enum:
        EVENT_EE = 8
    cdef enum:
        EVENT_AT_QNAME = 2
    cdef enum:
        EVENT_AT_URI = 3
    cdef enum:
        EVENT_AT_ALL = 4
    cdef enum:
        EVENT_CH = 9
    cdef enum:
        EVENT_NS = 10
    cdef enum:
        EVENT_CM = 11
    cdef enum:
        EVENT_PI = 12
    cdef enum:
        EVENT_DT = 13
    cdef enum:
        EVENT_ER = 14
    cdef enum:
        EVENT_SC = 15
    cdef enum:
        EVENT_VOID = 16
    cdef enum EventType:
        EVENT_SD = 0
        EVENT_ED = 1
        EVENT_SE_QNAME = 5
        EVENT_SE_URI = 6
        EVENT_SE_ALL = 7
        EVENT_EE = 8
        EVENT_AT_QNAME = 2
        EVENT_AT_URI = 3
        EVENT_AT_ALL = 4
        EVENT_CH = 9
        EVENT_NS = 10
        EVENT_CM = 11
        EVENT_PI = 12
        EVENT_DT = 13
        EVENT_ER = 14
        EVENT_SC = 15
        EVENT_VOID = 16
    ctypedef EventType EventType
    cdef struct Production:
        EventType eventType
        Index typeId
        QNameID qnameId
        SmallIndex nonTermID
    ctypedef Production Production
    cdef struct GrammarRulePart:
        Production * prod
        Index count
        unsigned char bits
    ctypedef GrammarRulePart GrammarRulePart
    cdef struct GrammarRule:
        GrammarRulePart * part
    ctypedef GrammarRule GrammarRule
    cdef struct EXIGrammar:
        GrammarRule * rule
        SmallIndex count
        unsigned char props
        SmallIndex contentIndex
    ctypedef EXIGrammar EXIGrammar
    cdef struct GrammarStackNode:
        EXIGrammar * grammar
        SmallIndex lastNonTermID
        GrammarStackNode * nextInStack
    ctypedef GrammarStackNode EXIGrammarStack
    cdef struct allocBlock:
        void * * allocation
        allocBlock * nextBlock
    cdef struct allocList:
        allocBlock * firstBlock
        allocBlock * lastBlock
        SmallIndex currAllocSlot
    ctypedef allocList AllocList
    cdef struct VxEntry:
        Index globalId
    ctypedef VxEntry VxEntry
    cdef struct VxTable:
        DynArray dynArray
        VxEntry * vx
        Index count
    ctypedef VxTable VxTable
    cdef struct LnEntry:
        VxTable vxTable
        String lnStr
        Index elemGrammar
        Index typeGrammar
    ctypedef LnEntry LnEntry
    cdef struct LnTable:
        DynArray dynArray
        LnEntry * ln
        Index count
    ctypedef LnTable LnTable
    cdef struct PfxTable:
        SmallIndex count
        String * pfxStr
    ctypedef PfxTable PfxTable
    cdef struct UriEntry:
        LnTable lnTable
        PfxTable * pfxTable
        String uriStr
    ctypedef UriEntry UriEntry
    cdef struct UriTable:
        DynArray dynArray
        UriEntry * uri
        SmallIndex count
    ctypedef UriTable UriTable
    cdef enum:
        VALUE_TYPE_NONE = 1
    cdef enum:
        VALUE_TYPE_STRING = 2
    cdef enum:
        VALUE_TYPE_FLOAT = 3
    cdef enum:
        VALUE_TYPE_DECIMAL = 4
    cdef enum:
        VALUE_TYPE_DATE_TIME = 5
    cdef enum:
        VALUE_TYPE_BOOLEAN = 6
    cdef enum:
        VALUE_TYPE_BINARY = 7
    cdef enum:
        VALUE_TYPE_LIST = 8
    cdef enum:
        VALUE_TYPE_QNAME = 9
    cdef enum:
        VALUE_TYPE_UNTYPED = 10
    cdef enum:
        VALUE_TYPE_INTEGER = 20
    cdef enum:
        VALUE_TYPE_SMALL_INTEGER = 21
    cdef enum:
        VALUE_TYPE_NON_NEGATIVE_INT = 22
    cdef enum EXIType:
        VALUE_TYPE_NONE = 1
        VALUE_TYPE_STRING = 2
        VALUE_TYPE_FLOAT = 3
        VALUE_TYPE_DECIMAL = 4
        VALUE_TYPE_DATE_TIME = 5
        VALUE_TYPE_BOOLEAN = 6
        VALUE_TYPE_BINARY = 7
        VALUE_TYPE_LIST = 8
        VALUE_TYPE_QNAME = 9
        VALUE_TYPE_UNTYPED = 10
        VALUE_TYPE_INTEGER = 20
        VALUE_TYPE_SMALL_INTEGER = 21
        VALUE_TYPE_NON_NEGATIVE_INT = 22
    ctypedef EXIType EXIType
    ctypedef long int int64_t
    cdef struct SimpleType:
        EXIType exiType
        uint16_t facetPresenceMask
        int64_t max
        int64_t min
        uint32_t length
    ctypedef SimpleType SimpleType
    cdef struct SimpleTypeTable:
        DynArray dynArray
        SimpleType * sType
        Index count
    ctypedef SimpleTypeTable SimpleTypeTable
    cdef struct SchemaGrammarTable:
        DynArray dynArray
        EXIGrammar * grammar
        Index count
    ctypedef SchemaGrammarTable SchemaGrammarTable
    cdef struct enumDefinition:
        Index typeId
        void * values
        SmallIndex count
    ctypedef enumDefinition EnumDefinition
    cdef struct EnumTable:
        DynArray dynArray
        EnumDefinition * enumDef
        Index count
    ctypedef EnumTable EnumTable
    cdef struct EXIPSchema:
        AllocList memList
        UriTable uriTable
        EXIGrammar docGrammar
        SimpleTypeTable simpleTypeTable
        SchemaGrammarTable grammarTable
        Index staticGrCount
        EnumTable enumTable
    ctypedef EXIPSchema EXIPSchema
    cdef struct EXIStream:
        BinaryBuffer buffer
        EXIheader header
        StreamContext context
        ValueTable valueTable
        EXIGrammarStack * gStack
        AllocList memList
        EXIPSchema * schema
    ctypedef EXIStream EXIStream
    cdef struct QName:
        String * uri
        String * localName
        String * prefix
    ctypedef QName QName
    ctypedef int64_t Integer
    cdef struct EXIFloat:
        int64_t mantissa
        int16_t exponent
    ctypedef EXIFloat Float
    cdef struct tm:
        int tm_sec
        int tm_min
        int tm_hour
        int tm_mday
        int tm_mon
        int tm_year
        int tm_wday
        int tm_yday
        int tm_isdst
        long int tm_gmtoff
        char * tm_zone
    cdef struct fractionalSecs:
        unsigned char offset
        unsigned int value
    ctypedef fractionalSecs FractionalSecs
    cdef struct EXIPDateTime:
        tm dateTime
        FractionalSecs fSecs
        uint16_t presenceMask
    ctypedef EXIPDateTime EXIPDateTime
    ctypedef float Decimal
    cdef struct ContentHandler:
        char(*startDocument)(void *)
        char(*endDocument)(void *)
        char(*startElement)(QName, void *)
        char(*endElement)(void *)
        char(*attribute)(QName, void *)
        char(*intData)(Integer, void *)
        char(*booleanData)(unsigned char, void *)
        char(*stringData)(String, void *)
        char(*floatData)(Float, void *)
        char(*binaryData)(char *, Index, void *)
        char(*dateTimeData)(EXIPDateTime, void *)
        char(*decimalData)(Decimal, void *)
        char(*listData)(EXIType, unsigned int, void *)
        char(*processingInstruction)(void *)
        char(*namespaceDeclaration)(String, String, unsigned char, void *)
        char(*warning)(char, char *, void *)
        char(*error)(char, char *, void *)
        char(*fatalError)(char, char *, void *)
        char(*selfContained)(void *)
    ctypedef ContentHandler ContentHandler
    cdef struct Parser:
        EXIStream strm
        ContentHandler handler
        void * app_data
    ctypedef Parser Parser
    errorCode parseHeader(Parser *)
    void destroyParser(Parser *)
    errorCode parseNext(Parser *)
    errorCode initParser(Parser *, BinaryBuffer, EXIPSchema *, void *)

#cdef struct EXIStream:
#    BinaryBuffer buffer
#    EXIheader header
#    StreamContext context
#    ValueTable valueTable
#    EXIGrammarStack * gStack
#    AllocList memList
#    EXIPSchema * schema

from libc.stdlib cimport malloc, free
cdef extern from "stdlib.h":
     void *memcpy(void *dst, void *src, long n)

cdef class PyBinaryBuffer:
    cdef BinaryBuffer obj
    def __cinit__(self, size_t size_in_bytes):
        
        self.obj.buf = <char*>malloc(size_in_bytes * sizeof(char))
        self.obj.bufLen = size_in_bytes
        self.obj.bufContent = 0

        self.obj.ioStrm.stream = NULL

    def __len__(self):
        return self.obj.bufLen
  
    def __dealloc__(self):
        if self.obj.buf is not NULL:
            free(self.obj.buf)

#    cdef struct EXIheader:
        # unsigned char has_cookie
        # unsigned char has_options
        # unsigned char is_preview_version
        # int16_t version_number
        # EXIOptions opts

cdef class PyEXIheader:
    cdef EXIheader obj
    def __cinit__(self, unsigned char has_cookie, unsigned char has_options):
        memcpy(&self.obj, NULL, sizeof(EXIheader))

        self.obj.has_cookie = has_cookie
        self.obj.has_options = has_options
        
