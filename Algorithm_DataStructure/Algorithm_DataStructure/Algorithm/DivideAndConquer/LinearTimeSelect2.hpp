//
//  LinearTimeSelect2.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/14.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef LinearTimeSelect2_hpp
#define LinearTimeSelect2_hpp

#include <stdio.h>
#include "Swap.hpp"

template <typename T>
void findSmallerBefore(int k, T array[], int start, int end) {
    if (end - start + 1 == k) {
        return;
    }
    int i = start;
    int j = end;
    int standard = array[start];
    while (i != j) {
        while (j > i && array[j] >= standard) {
            j --;
        }
        swap(array[i], array[j]);
        while (i < j && array[i] <= standard) {
            i ++;
        }
        swap(array[i], array[j]);
    }
    int leftAmount = i - start + 1;
    if (leftAmount == k) {
        return;
    } else if (leftAmount < k) {
        findSmallerBefore(k - leftAmount, array, i + 1, end);
    } else {
        findSmallerBefore(k, array, start, i - 1);
    }
}


#endif /* LinearTimeSelect2_hpp */
