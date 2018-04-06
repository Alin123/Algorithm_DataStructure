//
//  ALStack.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/10/2.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "ALStack.hpp"
#include <iostream>

ALStack::ALStack(int size) {
    capacity = size;
    charBuffer = new char[capacity];
    top = 0;
}

ALStack::~ALStack() {
    delete []charBuffer;
}

bool ALStack::stackEmpty() {
    return top == 0;
}

bool ALStack::stackFull() {
    return top == capacity;
}

void ALStack::clearStack() {
    top = 0;
}
int ALStack::stackLength() {
    return top;
}
bool ALStack::pushStack(char c) {
    if (stackFull()) {
        return false;
    }
    charBuffer[top] = c;
    top ++;
    return true;
}

bool ALStack::popStack(char *c) {
    if (stackEmpty()) {
        return false;
    }
    top --;
    *c = charBuffer[top];
    return true;
}
void ALStack::stackTraverse(void (*func)(char)) {
    for (int i = 0; i < top; i ++) {
        char c = charBuffer[i];
        (*func)(c);
    }
}

void ALStack::printStack(bool fromBtm, char sep) {
    for (int i = 0; i < top; i ++) {
        int index = i;
        if (!fromBtm) {
            index = top - i - 1;
        }
        char c = charBuffer[index];
        std::cout << c << sep;
    }
}

