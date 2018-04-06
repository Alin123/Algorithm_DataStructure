//
//  LinearTimeSelect.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/14.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef LinearTimeSelect_hpp
#define LinearTimeSelect_hpp

#include <stdio.h>
#include "Swap.hpp"

template <typename T>
T findMinRank(int k, T array[], int start, int end) {//k == 1表示找最小的，k>=1且k<=(end-start+1)
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
    if (i - start == (k - 1)) {
        return array[i];
    } else if (i - start < (k - 1)) {
        return findMinRank(k - (i - start) - 1, array, i + 1, end);
    } else {
        return findMinRank(k, array, start, i - 1);
    }
}

#endif /* LinearTimeSelect_hpp */
