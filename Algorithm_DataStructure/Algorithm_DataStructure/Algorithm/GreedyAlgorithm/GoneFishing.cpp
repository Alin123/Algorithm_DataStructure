//
//  GoneFishing.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/12.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "GoneFishing.hpp"
#include <algorithm>
#include <iostream>

Lake test_all_lake[LAKE_AMOUNT] = {
    {1, 0, 20, 2},
    {2, 5, 30, 3},
    {3, 3, 25, 2},
    {4, 1, 20, 2},
    {5, 4, 30, 3},
    {6, 6, 25, 2},
};

Slice all_slice_temp[HOUR * 12 * LAKE_AMOUNT] = {
    {0, 0, 0},
};
Slice all_slice_result[HOUR * 12 * LAKE_AMOUNT] = {
    {0, 0, 0},
};



int max_fish_stop_at(Lake array[], int index, int allHour, int &fishSliceAmount) {
    int amount = allHour * 12;
    for (int i = 0; i <= index; i ++) {
        amount -= array[i].t;
    }
    for (int i = 0; i <= index; i ++) {
        Lake &lake = array[i];
        for (int j = 0; j < amount; j ++) {
            Slice &sli = all_slice_temp[index * amount + j];
            sli.lakeNo = lake.No;
            sli.sliceNum = j + 1;
            sli.F = lake.f - lake.d * j;
            sli.F = sli.F > 0 ? sli.F : 0;
        }
    }
    std::sort(all_slice_temp, all_slice_temp + amount * (index + 1));
    
    int fish = 0;
    for (int i = 0; i < amount; i ++) {
        Slice &sli = all_slice_temp[i];
        fish += sli.F;
    }
    fishSliceAmount = amount;
    return fish;
}

bool aggregationByLakeNo(Slice &s1, Slice &s2) {
    if (s1.lakeNo == s2.lakeNo) {
        return s1.sliceNum < s2.sliceNum;
    }
    return s1.lakeNo < s2.lakeNo;
}

int max_fish_amount(Lake array[], int amount, int hour) {
    int max = 0;
    int fishSliceAmount = 0;
    int index = 0;
    while (index < amount) {
        int time = 0;
        int fishAtIndex = max_fish_stop_at(array, index, hour, time);
        if (max < fishAtIndex) {
            max = fishAtIndex;
            fishSliceAmount = time;
            for (int i = 0; i < fishSliceAmount; i ++) {
                all_slice_result[i] = all_slice_temp[i];
            }
        }
        index ++;
    }
    std::sort(all_slice_result, all_slice_result + fishSliceAmount, aggregationByLakeNo);
    for (int i = 0; i < fishSliceAmount; i ++) {
        std::cout << all_slice_result[i].lakeNo << ' ' << all_slice_result[i].sliceNum << ' ' << all_slice_result[i].F << '\n';
    }
    return max;
}

