//
//  ALDynamicArray.h
//  ALStructure
//
//  Created by lianzhandong on 2017/10/3.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef ALDynamicArray_h
#define ALDynamicArray_h

#include <stdio.h>

typedef struct {
    int alloc_count;    //当前最多存放多少个元素
    unsigned char *data;//指向存储我们的元素的堆上空间的首地址
    int size_of_elem;   //所存储数据的大小
    int elem_count;     //数组中的元素
}ALDynamicArray;

ALDynamicArray *dynamicArray_malloc();

void dynamicArray_define(ALDynamicArray *array, int sizeof_elem);//规定一个数组要存储类型(的大小)

void dynamicArray_add_elem(ALDynamicArray *array, void *elem);//向数组中添加元素

void dynamicArray_remove_elem(ALDynamicArray *array, int index, void *deletedElem);//移除相应位置的元素

void dynamicArray_insert_elem(ALDynamicArray *array, int index, void *insertElem);//将元素插入到指定位置

void dynamicArray_remove_all(ALDynamicArray *array);//清空一个数组中的所有元素

void dynamicArray_clear(ALDynamicArray *array);//清空一个数组中的所有元素，以及它们所占的空间

int dynamicArray_length(ALDynamicArray *array);

void dynamicArray_destory(ALDynamicArray *array);

void *dynamicArray_elem_at(ALDynamicArray *array, int index);

#endif /* ALDynamicArray_h */
