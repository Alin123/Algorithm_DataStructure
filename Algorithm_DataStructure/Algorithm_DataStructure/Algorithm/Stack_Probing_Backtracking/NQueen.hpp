//
//  NQueen.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/21.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef NQueen_hpp
#define NQueen_hpp

#include <stdio.h>
#include "Stack.hpp"

typedef struct Queen {
    int x;  //row
    int y;  //column
    Queen(int xx = 0, int yy = 0) {
        x = xx;
        y = yy;
    };
    bool operator==(Queen& other) {
        return (x == other.x) ||
               (y == other.y) ||
               (x + y == other.x + other.y) ||
               (x - y == other.x - other.y);
    }
    bool operator!=(Queen& other) {
        return !(*this == other);
    }
}Queen;

bool isValidQueen(Queen& q, Stack<Queen>& stack);

void printValidQueen(Queen& q);

void printAllValidNQueenCouple(int n);

#endif /* NQueen_hpp */
