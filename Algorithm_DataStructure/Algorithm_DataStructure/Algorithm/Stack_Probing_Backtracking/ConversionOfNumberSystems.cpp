//
//  ConversionOfNumberSystems.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/20.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "ConversionOfNumberSystems.hpp"

void convert_recursion(Stack<char>& s, int n, int base) {
    if (n > 0) {
        char digit[] = {'0', '1', '2', '3', '4', '5', '6', '7',
                        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        s.push(digit[n % base]);
        n = n / base;
        convert_recursion(s, n, base);
    }
}
void convert_iteration(Stack<char>& s, int n, int base) {
    char digit[] = {'0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    while (n > 0) {
        s.push(digit[n % base]);
        n /= base;
    }
}
