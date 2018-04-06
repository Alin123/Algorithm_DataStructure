//
//  BracketMatching.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/21.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "BracketMatching.hpp"
#include "Stack.hpp"

bool bracketMatching(char array[]) {
    Stack<char> s = Stack<char>();
    for (int i = 0; array[i] != '\0'; i ++) {
        char c = array[i];
        if (c == '(') {
            s.push(c);
        } else if (c == ')') {
            if (!s.empty() && s.pop() == '(') {
                continue;
            } else {
                return false;
            }
        }
    }
    return s.empty();
}
