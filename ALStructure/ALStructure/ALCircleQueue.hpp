//
//  ALCircleQueue.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/10/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef ALCircleQueue_hpp
#define ALCircleQueue_hpp

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

class ALCircleQueue {
public:
    ALCircleQueue(int queueCapacity);
    virtual ~ALCircleQueue();
    
    void ClearQueue();
    
    bool QueueEmpty() const;
    bool QueueFull() const;
    
    int QueueLength() const;
    
    bool EnQueue(int elemet);
    bool DeQueue(int *element);
    
    void QueueTraverse();
private:
    int *m_pQueue;       //队列数组指针
    int m_iQueueLen;     //队列元素个数
    int m_iQueueCapacity;//队列数组容量
    
    int m_iHead;
    int m_iTail;
};

#endif /* ALCircleQueue_hpp */
