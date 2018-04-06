//
//  Stack.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/20.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Stack_hpp
#define Stack_hpp

#include <stdio.h>
#include "Vector.hpp"

template <typename T>
class Stack: public Vector<T> {
public:
    void push(T const& e) {
        Vector<T>::insert(Vector<T>::size(), e);
    }
    T pop() {
        return Vector<T>::remove(Vector<T>::size() - 1);
    }
    T& top() {
        return ((Vector<T>)*this)[Vector<T>::size() - 1];
    }
};

#endif /* Stack_hpp */
