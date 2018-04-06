//
//  QuickSort.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/14.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef QuickSort_hpp
#define QuickSort_hpp

#include <stdio.h>
#include "Swap.hpp"

//最坏的情况O(n^2)
//最好和平均平均情况是O(nlogn)，这取决于每次取的基准，按基准一次排序后基准左右元素的数量是否相当。
template <typename T>
void QuickSort(T array[], int start, int end) {
    if (start >= end) {
        return;
    }
    int i = start;
    int j = end;
    int k = array[i];
    while (i != j) {
        while (j > i && array[j] >= k) {
            j --;
        }
        swap(array[i], array[j]);
        while (i < j && array[i] <= k) {
            i ++;
        }
        swap(array[i], array[j]);
    }
    QuickSort<T>(array, start, i - 1);
    QuickSort<T>(array, i + 1, end);
}


#endif /* QuickSort_hpp */
