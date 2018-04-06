//
//  StallReservations.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/11.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "StallReservations.hpp"
#include <algorithm>
#include <queue>
#define NO_START_VALUE 1000
Cow all_cow_array[10] = {
    {1, 2, NO_START_VALUE + 1, -1},
    {1, 3, NO_START_VALUE + 2, -1},
    {2, 4, NO_START_VALUE + 3, -1},
    {2, 4, NO_START_VALUE + 4, -1},
    {3, 7, NO_START_VALUE + 5, -1},
    {1, 5, NO_START_VALUE + 6, -1},
    {6, 8, NO_START_VALUE + 7, -1},
    {4, 9, NO_START_VALUE + 8, -1},
    {5, 8, NO_START_VALUE + 9, -1},
    {2, 3, NO_START_VALUE + 10, -1},
};


int min_stall_reservations(Cow cows[], int amount) {
    std::sort(cows, cows + amount);
    std::priority_queue<Stall> pq;
    int index = 0;
    while (index < amount) {
        Cow &cow = cows[index];
        if (pq.empty()) {
            Stall s = {cow.end, int(pq.size()) + 1};
            pq.push(s);
            cow.stallNo = s.No;
        } else {
            Stall stall = pq.top();
            if (stall.end < cow.start) {
                cow.stallNo = stall.No;
                pq.pop();
                pq.push(Stall(cow.end, stall.No));
            } else {
                Stall s = {cow.end, int(pq.size()) + 1};
                pq.push(s);
                cow.stallNo = s.No;
            }
        }
        index ++;
    }
    return int(pq.size());
}
