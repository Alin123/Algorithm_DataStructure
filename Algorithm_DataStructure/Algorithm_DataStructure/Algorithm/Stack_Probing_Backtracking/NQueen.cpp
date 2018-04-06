//
//  NQueen.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/21.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "NQueen.hpp"

bool isValidQueen(Queen& q, Stack<Queen>& stack) {
    for (int i = 0; i < stack.size(); i++) {
        if (stack[i] == q) {
            return false;
        }
    }
    return true;
}

void printValidQueen(Queen& q) {
    printf("第%d行，第%d列", q.x, q.y);
}

void printAllValidNQueenCouple(int n) {
    
}
