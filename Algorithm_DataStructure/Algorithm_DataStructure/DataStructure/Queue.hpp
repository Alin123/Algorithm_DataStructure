//
//  Queue.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/21.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Queue_hpp
#define Queue_hpp

#include <stdio.h>
#include "List.hpp"

template <typename T>
class Queue: public List<T> {
public:
    void enqueue(T const& e) {
        List<T>::insertAsLast(e);
    }
    T dequeue() {
        return List<T>::remove(List<T>::first());
    }
    T& font() {
        return List<T>::first()->data;
    }
};


#endif /* Queue_hpp */
