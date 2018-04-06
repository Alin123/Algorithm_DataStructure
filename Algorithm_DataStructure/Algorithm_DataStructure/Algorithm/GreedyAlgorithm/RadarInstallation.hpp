//
//  RadarInstallation.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/12.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef RadarInstallation_hpp
#define RadarInstallation_hpp

#include <stdio.h>

typedef struct Island {
    int x;
    int y;
}Island;

typedef struct Interval {
    float start;
    float end;
    bool operator<(const Interval &i) const {
        return start < i.start;
    }
}Interval;

#define D 50

extern Island text_all_island_positions[10];
extern Interval island_corresponding_interval[10];

int min_radar_amount(Island array[], int amount, Interval tempArray[]);

#endif /* RadarInstallation_hpp */
