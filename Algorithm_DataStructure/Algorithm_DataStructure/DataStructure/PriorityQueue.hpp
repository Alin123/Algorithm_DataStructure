//
//  PriorityQueue.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/4/1.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef PriorityQueue_hpp
#define PriorityQueue_hpp

#include <stdio.h>

template <typename T>
class PriorityQueue {
public:
    virtual int size() {
        return 0;
    }
    bool empty() {
        return !size();
    }
    virtual void insert(T) {
        
    }
    virtual T getMax() {
        return NULL;
    }
    virtual T delMax() {
        return NULL;
    }
};

#endif /* PriorityQueue_hpp */
