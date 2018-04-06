//
//  ALDynamicArray.c
//  ALStructure
//
//  Created by lianzhandong on 2017/10/3.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "ALDynamicArray.h"

#include <stdlib.h>

ALDynamicArray *dynamicArray_malloc() {
    ALDynamicArray *array = malloc(sizeof(ALDynamicArray));
    return array;
}

void dynamicArray_define(ALDynamicArray *array, int sizeof_elem) {
    memset(array, 0, sizeof(ALDynamicArray));
    // alloc = 0,
    array->size_of_elem = sizeof_elem;
}
#define Relloc_Step 4
void dynamicArray_add_elem(ALDynamicArray *array, void *elem) {
    if (array->elem_count >= array->alloc_count) {
        array->alloc_count += Relloc_Step;
        array->data = (unsigned char *)realloc(array->data, array->alloc_count * array->size_of_elem);
    }
    unsigned char *dst = array->data + (array->elem_count) * array->size_of_elem;
    memcpy(dst, elem, array->size_of_elem);
    array->elem_count ++;
}

void dynamicArray_remove_elem(ALDynamicArray *array, int index, void *deletedElem) {
    if (index < 0 || index >= array->elem_count) {
        deletedElem = NULL;
    } else {
        if (deletedElem != NULL) {
            memcpy(deletedElem, array->data + index * array->size_of_elem, array->size_of_elem);
        }
        if (index == array->elem_count) {// last one
            array->elem_count --;
        } else {//
            memmove(array->data + index * array->size_of_elem, array->data + (index + 1) * array->size_of_elem, (array->elem_count - index - 1) * array->size_of_elem);
            array->elem_count --;
        }
    }
}

void dynamicArray_insert_elem(ALDynamicArray *array, int index, void *insertElem) {
    if (index < 0) {
        index = 0;
    }
    if (index > array->elem_count) {
        index = array->elem_count;
    }
    if (array->elem_count >= array->alloc_count) {
        array->alloc_count += Relloc_Step;
        array->data = realloc(array->data, array->alloc_count * array->size_of_elem);
    }
    if (index == array->elem_count) {
        unsigned char *dst = array->data + index * array->size_of_elem;
        memcpy(dst, insertElem, array->size_of_elem);
        array->elem_count ++;
    } else {
        unsigned char *dst = array->data + index * array->size_of_elem;
        memmove(dst + array->size_of_elem, dst, (array->elem_count - index) * array->size_of_elem);
        memcpy(dst, insertElem, array->size_of_elem);
        array->elem_count ++;
    }
}


void dynamicArray_remove_all(ALDynamicArray *array) {
    array->elem_count = 0;
}



void dynamicArray_clear(ALDynamicArray *array) {
    array ->elem_count = 0;
    array->size_of_elem = 0;
    array->alloc_count = 0;
    if (array->data != NULL) {
        free(array->data);
        array->data = NULL;
    }
}

void dynamicArray_destory(ALDynamicArray *array) {
    if (array->data != NULL) {
        free(array->data);
        array->data = NULL;
    }
    free(array);
    array = NULL;
}

int dynamicArray_length(ALDynamicArray *array) {
    return array->elem_count;
}

void *dynamicArray_elem_at(ALDynamicArray *array, int index) {
    if (index < 0 || index >= array->elem_count) {
        return NULL;
    }
    return array->data + index * array->size_of_elem;
}
