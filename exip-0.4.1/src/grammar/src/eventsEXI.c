/*==================================================================*\
|                EXIP - Embeddable EXI Processor in C                |
|--------------------------------------------------------------------|
|          This work is licensed under BSD 3-Clause License          |
|  The full license terms and conditions are located in LICENSE.txt  |
\===================================================================*/

/**
 * @file eventsEXI.c
 * @brief Defines events related functions
 * @date Sep 13, 2010
 * @author Rumen Kyusakov
 * @version 0.4
 * @par[Revision] $Id: eventsEXI.c 205 2012-09-04 11:19:04Z kjussakov $
 */

#include "eventsEXI.h"
#include "streamEncode.h"
#include "stringManipulate.h"

errorCode writeEventCode(EXIStream* strm, GrammarRule* currentRule, unsigned char codeLength, Index codeLastPart)
{
	errorCode tmp_err_code = UNEXPECTED_ERROR;
	unsigned char i = 0;
	for(i = 0; i < codeLength - 1; i++)
	{
		tmp_err_code = encodeNBitUnsignedInteger(strm, currentRule->part[i].bits, (unsigned int) currentRule->part[i].count);
		if(tmp_err_code != ERR_OK)
			return tmp_err_code;
	}

	tmp_err_code = encodeNBitUnsignedInteger(strm, currentRule->part[codeLength - 1].bits, (unsigned int) codeLastPart);
	if(tmp_err_code != ERR_OK)
		return tmp_err_code;

	return ERR_OK;
}

unsigned char valueTypeClassesEqual(EXIType t1, EXIType t2)
{
	return t1 == t2 || (t1 >= VALUE_TYPE_INTEGER && t1 >= VALUE_TYPE_INTEGER);
}
