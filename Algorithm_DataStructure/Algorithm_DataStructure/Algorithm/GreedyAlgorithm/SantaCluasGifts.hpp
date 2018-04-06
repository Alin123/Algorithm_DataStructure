//
//  SantaCluasGifts.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/10.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef SantaCluasGifts_hpp
#define SantaCluasGifts_hpp

#include <stdio.h>

typedef struct Gift {
    int worth;
    int weight;
}Gift;

#define GIFT_KIND_COUNT 4
#define SLED_CAPACITY 15

extern Gift test_gift_array[GIFT_KIND_COUNT];

void quick_sort(Gift array[], int start, int end);
float max_worth_full_sled(Gift candyArray[], int kindAmount, int sledCapacity);

#endif /* SantaCluasGifts_hpp */
