//
//  RadarInstallation.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/12.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "RadarInstallation.hpp"
#include <math.h>
#include <algorithm>

Island text_all_island_positions[10] = {
    {-50, 45},
    {-40, 38},
    {-35, 39},
    {-25, 19},
    {0, 26},
    {70, 28},
    {48, 48},
    {52, 36},
    {4, 47},
    {330, 37},
};

Interval island_corresponding_interval[10] = {
    {0.0, 0.0},
};

float radar_x[10];

int min_radar_amount(Island array[], int amount, Interval tempArray[]) {
    int index = 0;
    while (index < amount) {
        Island &island = array[index];
        float distance = sqrt(D * D - island.y * island.y);
        Interval &interval = tempArray[index];
        interval.start = float(island.x) - distance;
        interval.end = float(island.x) + distance;
        index ++;
    }
    std::sort(tempArray, tempArray + amount);
    
    index = 0;
    while (index < amount) {
        printf("%.2f %.2f\n", tempArray[index].start, tempArray[index].end);
        index ++;
    }
    
    int min = 0;
    
    float start = tempArray[0].start;
    float end = tempArray[0].end;
    
    index = 1;
    while (index < amount) {
        Interval &interval = tempArray[index];
        printf("%d \n", index);
        if (interval.start <= end) {
            start = interval.start;
            end = std::min(end, interval.end);
        } else {
            radar_x[min] = tempArray[index - 1].start;
            min += 1;
            start = interval.start;
            end = interval.end;
        }
        index ++;
    }
    radar_x[min] = tempArray[index - 1].start;
    min += 1;
    return min;
}
