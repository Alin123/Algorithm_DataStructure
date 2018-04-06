//
//  GoneFishing.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/12.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef GoneFishing_hpp
#define GoneFishing_hpp

#include <stdio.h>

typedef struct Lake {
    int No;
    int t;
    int f;
    int d;
}Lake;

typedef struct Slice {
    int F;
    int lakeNo;
    int sliceNum;
    bool operator<(const Slice &s) const {
        if(F == s.F) {
            return lakeNo < s.lakeNo;
        }
        return F > s.F;
    }
}Slice;

#define HOUR 4
#define LAKE_AMOUNT 6

extern Lake test_all_lake[LAKE_AMOUNT];
extern Slice all_slice_temp[HOUR * 12 * LAKE_AMOUNT];
extern Slice all_slice_result[HOUR * 12 * LAKE_AMOUNT];

int max_fish_amount(Lake array[], int amount, int hour);

#endif /* GoneFishing_hpp */
