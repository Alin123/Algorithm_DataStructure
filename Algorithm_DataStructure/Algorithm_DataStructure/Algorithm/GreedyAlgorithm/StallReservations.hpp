//
//  StallReservations.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/11.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef StallReservations_hpp
#define StallReservations_hpp

#include <stdio.h>

typedef struct Cow {
    int start;
    int end;
    int No;
    int stallNo;
    bool operator<(const Cow &c) const {
        return start < c.start;
    }
}Cow;

typedef struct Stall {
    int end;
    int No;
    bool operator<(Stall const &s) const {
        return end > s.end;
    }
    Stall(int e, int n):end(e),No(n) {}
}Stall;

extern Cow all_cow_array[10];

int min_stall_reservations(Cow cows[], int amount);

#endif /* StallReservations_hpp */
