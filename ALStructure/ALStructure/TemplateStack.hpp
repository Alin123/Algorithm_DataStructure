//
//  TemplateStack.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef TemplateStack_hpp
#define TemplateStack_hpp

#include <stdio.h>

template <typename T> class StackIterator;//前置声明
template <typename T>
class Stack {
public:
    Stack():top(0) {
        array[0] = T();
    }
    
    friend class StackIterator<T>;
    
    void push(const T& val);
    T pop();
    
private:
    enum {SIZE = 100};
    T array[SIZE];
    int top;
};

template <typename T>
void Stack<T>::push(const T& val) {
    if(top < SIZE) {
        array[top++] = val;
    } else {
        printf("Stack is full!");
    }
}

template <typename T>
T Stack<T>::pop() {
    if (top > 0) {
        return array[--top];
    }
    return array[0];
}

template <typename T>
class StackIterator {
public:
    StackIterator(Stack<T>& val):stack(val),index(0) {
        
    }
    T& operator++(int) {
        int ret = index;
        if (index < stack.top - 1) {
            index++;
        }
        return stack.array[ret];
    }
private:
    Stack<T>& stack;
    int index;
};

#endif /* TemplateStack_hpp */
