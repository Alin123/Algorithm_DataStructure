//
//  BinarySearch.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/13.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef BinarySearch_hpp
#define BinarySearch_hpp

#include <stdio.h>

template <class Type>
int BinarySearch(Type array[], const Type& target, int start, int end) {
    if (start > end) {
        return -1;
    }
    int mid = end + (start - end) / 2;
    if (target == array[mid]) {
        return mid;
    } else if (target > array[mid]) {
        return BinarySearch(array, target, mid + 1, end);
    } else {
        return BinarySearch(array, target, start, mid - 1);
    }
}


template <class Type>
int BinarySearch(Type array[], const Type& target, int n) {
    return BinarySearch(array, target, 0, n - 1);
}


template <class T>
int BinarySearchLoop(T array[], const T& target, int start, int end) {
    int i = start, j = end;
    while (i <= j) {
        int mid = j + (i - j) / 2;
        if (target == array[mid]) {
            return mid;
        } if (target > array[mid]) {
            i = mid + 1;
        } else {
            j = mid - 1;
        }
    }
    return -1;
}

template <class T>
int BinarySearchLoop(T array[], const T& target, int n) {
    BinarySearchLoop(array, target, 0, n - 1);
}

#endif /* BinarySearch_hpp */
