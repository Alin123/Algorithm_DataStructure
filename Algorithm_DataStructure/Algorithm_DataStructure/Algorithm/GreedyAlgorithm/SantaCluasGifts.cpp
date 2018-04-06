//
//  SantaCluasGifts.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/10.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "SantaCluasGifts.hpp"

Gift test_gift_array[] = {
    {100, 4},//25
    {412, 8},//51.5
    {266, 7},//35
    {591, 2},//295.5
};

void swap(Gift & a, Gift & b) {
    Gift temp = a;
    a = b;
    b = temp;
}

bool is_expensive(Gift & a, Gift & b) {
    if ((float(a.worth) / a.weight - float(b.worth) / b.weight) > 1e-6) {
        return true;
    }
    return false;
}

void quick_sort(Gift array[], int start, int end) {
    if (start >= end) {
        return;
    }
    int i = start;
    int j = end;
    Gift k = array[i];
    while (i <= j) {
        while (j >= i && !is_expensive(array[j], k)) {
            j --;
        }
        swap(array[i], array[j]);
        while (i <= j && is_expensive(array[i], k)) {
            i ++;
        }
        swap(array[i], array[j]);
    }
    quick_sort(array, start, i - 1);
    quick_sort(array, i + 1, end);
}

float max_worth_full_sled(Gift candyArray[], int kindAmount, int sledCapacity) {
    quick_sort(candyArray, 0, kindAmount - 1);
    for (int i = 0; i < kindAmount; i ++) {
        printf("%d, %d\n", candyArray[i].worth, candyArray[i].weight);
    }
    int i = 0;
    int remainCapacity = sledCapacity;
    float maxWorth = 0.0f;
    while (i < kindAmount && remainCapacity > 0) {
        if (candyArray[i].weight <= remainCapacity) {
            maxWorth += float(candyArray[i].worth);
            remainCapacity -= candyArray[i].weight;
        } else {
            maxWorth += float(candyArray[i].worth) / candyArray[i].weight * remainCapacity;
            remainCapacity = 0;
        }
    }
    return maxWorth;
}
