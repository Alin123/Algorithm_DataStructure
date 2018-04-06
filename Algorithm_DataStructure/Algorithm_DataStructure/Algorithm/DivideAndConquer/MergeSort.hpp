//
//  MergeSort.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/13.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef MergeSort_hpp
#define MergeSort_hpp

#include <stdio.h>

template <typename T>
void Merge(T source[], int left, int mid, int right, T target[]) {
    int i = left;
    int j = mid + 1;
    int k = 0;
    while (i <= mid && j <= right) {
        if (source[i] < source[j]) {
            target[k++] = source[i++];
        } else {
            target[k++] = source[j++];
        }
    }
    while (i <= mid) {
        target[k++] = source[i++];
    }
    while (j <= right) {
        target[k++] = source[j++];
    }
}

template <typename T>
void CopyTo(T target[], int start, int end, T source[]) {
    for (int i = start; i <= end; i ++) {
        target[i] = source[i - start];
    }
}

template <typename T>
void MergeSort_interval(T array[], int start, int end) {
    if (start >= end) {
        return;
    }
    int mid = (start + end) / 2;
    MergeSort_interval(array, start, mid);
    MergeSort_interval(array, mid + 1, end);
    T* transfer = new T[end - start + 1];
    Merge(array, start, mid, end, transfer);
    CopyTo(array, start, end, transfer);
    delete [] transfer;
}

template <typename T>
void MergeSort(T array[], int n) {
    MergeSort_interval(array, 0, n - 1);
}

template <typename T>
void MergeSortLoop(T array[], int start, int end) {
    int length = end - start + 1;
    int* transfer = new int[length];
    int step = 1;
    int subsectionLength = 1;
    while (step < length) {
        for (int i = start; i + subsectionLength < length; i += subsectionLength * 2) {
            int right = i + subsectionLength * 2 - 1;
            right = right > end ? end : right;
            Merge(array, i, i + subsectionLength - 1, right, transfer);
            CopyTo(array, i, right, transfer);
        }
        step *= 2;
        subsectionLength *= 2;
    }
    delete [] transfer;
}


#endif /* MergeSort_hpp */
