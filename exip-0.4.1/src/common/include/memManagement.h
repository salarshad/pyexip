/*==================================================================*\
|                EXIP - Embeddable EXI Processor in C                |
|--------------------------------------------------------------------|
|          This work is licensed under BSD 3-Clause License          |
|  The full license terms and conditions are located in LICENSE.txt  |
\===================================================================*/

/**
 * @file memManagement.h
 * @brief Handles memory operations - allocation, deallocation etc.
 * Except Data Values (Binary data, DateTime etc.), which are
 * freed after the respective ContentHandler is called, all other
 * allocations are freed at the end of the parsing/serializing.
 *
 * @date Oct 25, 2010
 * @author Rumen Kyusakov
 * @version 0.4
 * @par[Revision] $Id: memManagement.h 218 2012-10-16 07:21:10Z kjussakov $
 */

#ifndef MEMMANAGEMENT_H_
#define MEMMANAGEMENT_H_

#include "errorHandle.h"
#include "procTypes.h"

/**
 * @brief Initial setup of an AllocList
 *
 * @param[in, out] list a memory list to be setup
 * @return Error handling code
 */
errorCode initAllocList(AllocList* list);

/**
 * @brief Allocate a memory block with size size and store a copy of
 * the pointer in a linked list for freeing it at the end.
 *
 * @param[in, out] list A list storing the memory allocations
 * @param[in] size the size of the memory block to be allocated
 * @return pointer to the allocated memory if successful. NULL otherwise
 */
void* memManagedAllocate(AllocList* list, size_t size);

/**
 * @brief Frees all the managed memory for a particular EXI stream.
 * It should be called after an error in the processing occur or at the
 * end of the parsing/serializing if the processing is successful.
 * Frees the memory in the allocation list and the hashtables used.
 *
 * @param[in, out] strm EXI stream for which the allocations were made
 */
void freeAllMem(EXIStream* strm);

/**
 * @brief Frees a particular Allocation list
 *
 * @param[in, out] list Allocation list to be freed
 * @return Error handling code
 */
void freeAllocList(AllocList* list);

#endif /* MEMMANAGEMENT_H_ */
