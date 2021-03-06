/*==================================================================*\
|                EXIP - Embeddable EXI Processor in C                |
|--------------------------------------------------------------------|
|          This work is licensed under BSD 3-Clause License          |
|  The full license terms and conditions are located in LICENSE.txt  |
\===================================================================*/

/**
 * @file ASCII_stringManipulate.c
 * @brief String manipulation functions used for UCS <-> ASCII transformations
 *
 * @date Sep 3, 2010
 * @author Rumen Kyusakov
 * @version 0.4
 * @par[Revision] $Id: ASCII_stringManipulate.c 216 2012-10-11 14:29:14Z kjussakov $
 */

#include "stringManipulate.h"
#include "memManagement.h"

#define PARSING_STRING_MAX_LENGTH 100

errorCode allocateStringMemory(CharType** str, Index UCSchars)
{
	*str = EXIP_MALLOC(sizeof(CharType)*UCSchars);
	if((*str) == NULL)
		return MEMORY_ALLOCATION_ERROR;
	return ERR_OK;
}

errorCode allocateStringMemoryManaged(CharType** str, Index UCSchars, AllocList* memList)
{
	(*str) = (CharType*) memManagedAllocate(memList, sizeof(CharType)*UCSchars);
	if((*str) == NULL)
		return MEMORY_ALLOCATION_ERROR;
	return ERR_OK;
}

/**
 * Simple translation working only for ASCII characters
 */
errorCode writeCharToString(String* str, uint32_t code_point, Index* writerPosition)
{
	if(*writerPosition >= str->length)
		return OUT_OF_BOUND_BUFFER;
	str->str[*writerPosition] = (CharType) code_point;
	*writerPosition += 1;
	return ERR_OK;
}

void getEmptyString(String* emptyStr)
{
	emptyStr->length = 0;
	emptyStr->str = NULL;
}

char isStringEmpty(const String* str)
{
	if(str == NULL || str->length == 0)
		return 1;
	return 0;
}

errorCode asciiToString(const char* inStr, String* outStr, AllocList* memList, unsigned char clone)
{
	outStr->length = strlen(inStr);
	if(outStr->length > 0)  // If == 0 -> empty string
	{
		if(clone == FALSE)
		{
			outStr->str = (CharType*) inStr;
			return ERR_OK;
		}
		else
		{
			outStr->str = (CharType*) memManagedAllocate(memList, sizeof(CharType)*(outStr->length));
			if(outStr->str == NULL)
				return MEMORY_ALLOCATION_ERROR;
			memcpy(outStr->str, inStr, outStr->length);
			return ERR_OK;
		}
	}
	else
		outStr->str = NULL;
	return ERR_OK;
}

char stringEqual(const String str1, const String str2)
{
	if(str1.length != str2.length)
		return 0;
	else if(str1.length == 0)
		return 1;
	else // The strings have the same length
	{
		Index i;
		for(i = 0; i < str1.length; i++)
		{
			if(str1.str[i] != str2.str[i])
				return 0;
		}
		return 1;
	}
}

char stringEqualToAscii(const String str1, const char* str2)
{
	if(str1.length != strlen(str2))
		return 0;
	else // The strings have the same length
	{
		Index i;
		for(i = 0; i < str1.length; i++)
		{
			if(str1.str[i] != str2[i])
				return 0;
		}
		return 1;
	}
}

int stringCompare(const String str1, const String str2)
{
	/* Check for NULL string pointers */
	if(str1.str == NULL)
	{
		if(str2.str == NULL)
			return 0;
		return -1;
	}
	else if(str2.str == NULL)
		return 1;
	else // None of the strings is NULL
	{
		int diff;
		Index i;
		for(i = 0; i < str1.length && i < str2.length; i++)
		{
			diff = str1.str[i] - str2.str[i];
			if(diff)
				return diff; // There is a difference in the characters at index i
		}
		/* Up to index i the strings have the same characters and might differ only in length*/
		return str1.length - str2.length;
	}
}

// TODO: consider removing the OUT_OF_BOUND_BUFFER check: the length of the string must be valid
// => return void

errorCode readCharFromString(const String* str, Index* readerPosition, uint32_t* UCScp)
{
	if(*readerPosition >= str->length)
		return OUT_OF_BOUND_BUFFER;
	*UCScp = (uint32_t) str->str[*readerPosition];
	*readerPosition += 1;
	return ERR_OK;
}

errorCode cloneString(const String* src, String* newStr)
{
	if(newStr == NULL)
		return NULL_POINTER_REF;
	newStr->str = EXIP_MALLOC(sizeof(CharType)*src->length);
	if(newStr->str == NULL)
		return MEMORY_ALLOCATION_ERROR;
	newStr->length = src->length;
	memcpy(newStr->str, src->str, src->length);
	return ERR_OK;
}

errorCode cloneStringManaged(const String* src, String* newStr, AllocList* memList)
{
	if(newStr == NULL)
		return NULL_POINTER_REF;
	newStr->str = memManagedAllocate(memList, sizeof(CharType)*src->length);
	if(newStr->str == NULL)
		return MEMORY_ALLOCATION_ERROR;
	newStr->length = src->length;
	memcpy(newStr->str, src->str, src->length);
	return ERR_OK;
}

Index getIndexOfChar(const String* src, CharType sCh)
{
	Index i;

	for(i = 0; i < src->length; i++)
	{
		if(src->str[i] == sCh)
			return i;
	}
	return INDEX_MAX;
}

errorCode stringToInteger(const String* src, int* number)
{
	char buff[PARSING_STRING_MAX_LENGTH];
	long result;
	char *endPointer;

	if(src->length == 0 || src->length >= PARSING_STRING_MAX_LENGTH)
		return INVALID_STRING_OPERATION;

	memcpy(buff, src->str, src->length);
	buff[src->length] = '\0';

	result = strtol(buff, &endPointer, 10);

	if(result == LONG_MAX || result == LONG_MIN || *src->str == *endPointer)
		return INVALID_STRING_OPERATION;

	if(result >= INT_MAX || result <= INT_MIN)
		return OUT_OF_BOUND_BUFFER;

	*number = (int) result;

	return ERR_OK;
}

errorCode stringToInt64(const String* src, int64_t* number)
{
	char buff[PARSING_STRING_MAX_LENGTH];
	long long result;
	char *endPointer;

	if(src->length == 0 || src->length >= PARSING_STRING_MAX_LENGTH)
		return INVALID_STRING_OPERATION;

	memcpy(buff, src->str, src->length);
	buff[src->length] = '\0';

	result = EXIP_STRTOLL(buff, &endPointer, 10);

	if(result == LLONG_MAX || result == LLONG_MIN || *src->str == *endPointer)
		return INVALID_STRING_OPERATION;

	if(result >= LLONG_MAX || result <= LLONG_MIN)
		return OUT_OF_BOUND_BUFFER;

	*number = (int64_t) result;

	return ERR_OK;
}

#if EXIP_DEBUG == ON

void printString(const String* inStr)
{
	Index i = 0;
	if(inStr->length == 0)
		return;
	for(i = 0; i < inStr->length; i++)
	{
		DEBUG_CHAR_OUTPUT(inStr->str[i]);
	}
}

#endif /* EXIP_DEBUG */
