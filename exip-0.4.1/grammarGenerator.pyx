Item not handled for cy_generate <ctypeslib.codegen.typedesc.ArrayType object at 0x25c6e10>
Item not handled for cy_generate <ctypeslib.codegen.typedesc.ArrayType object at 0x25d0850>
Item not handled for cy_generate <ctypeslib.codegen.typedesc.ArrayType object at 0x25c7d90>
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

