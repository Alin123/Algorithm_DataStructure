//
//  HalfNumberSet.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/15.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "HalfNumberSet.hpp"

int halfNumberSet(int n) {
    if (n <= 1) {
        return 1;
    }
    int sum = 0;
    for (int i = 0; i <= n / 2; i ++) {
        sum += halfNumberSet(i);
    }
    return sum;
}

int halfNumberSetDynamicPrograming(int n) {
    int* array = new int[n + 1];
    array[0] = 1;array[1] = 1;
    for (int i = 1; i < n; i ++) {
        int sum = 0;
        for (int j = i / 2; j >= 0; j --) {
            sum += array[i];
        }
        array[i + 1] = sum;
    }
    int amount = array[n];
    delete [] array;
    return amount;
}


int halfNumberSetWithoutRepeat(int n) {
    if (n <= 1) {
        return 1;
    }
    int sum = 0;
    for (int i = 0; i <= n / 2; i ++) {
        sum += halfNumberSet(i);
        if (i > 10 && (i/10 <= (i%10)/2)) {
            sum -= halfNumberSet(i/10);
        }
    }
    return sum;
}

