//
//  ALStack.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/10/2.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef ALStack_hpp
#define ALStack_hpp

#include <stdio.h>

class ALStack {
public:
    ALStack(int capacity);
    ~ALStack();
    bool stackEmpty();
    bool stackFull();
    void clearStack();
    int stackLength();
    bool pushStack(char);
    bool popStack(char *);
    void stackTraverse(void (*func)(char));
    void printStack(bool fromBtm, char sep);
private:
    char *charBuffer;  //字符数组，charBuffer是数组首地址，[x]下标运算符：取序号为x的字符
    int capacity;
    int top;
};

#endif /* ALStack_hpp */
