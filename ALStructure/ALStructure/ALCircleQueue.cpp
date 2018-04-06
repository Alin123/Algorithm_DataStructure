//
//  ALCircleQueue.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/10/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "ALCircleQueue.hpp"

ALCircleQueue::ALCircleQueue(int capacity) {
    m_iQueueCapacity = capacity;
    m_iHead = 0;
    m_iTail = 0;
    m_iQueueLen = 0;
    m_pQueue = new int[m_iQueueCapacity];
}

ALCircleQueue::~ALCircleQueue() {
    delete []m_pQueue;
    m_pQueue = NULL;
}

void ALCircleQueue::ClearQueue() {
    m_iHead = m_iTail = 0;
    m_iQueueLen = 0;
}

int ALCircleQueue::QueueLength() const {
    return m_iQueueLen;
}

bool ALCircleQueue::QueueEmpty() const{
    return m_iQueueLen == 0 ? true : false;
}

bool ALCircleQueue::QueueFull() const {
    return m_iQueueLen == m_iQueueCapacity ? true : false;
}

bool ALCircleQueue::EnQueue(int element) {
    if (QueueFull()) {
        return false;
    }
    m_pQueue[m_iTail] = element;
    m_iTail = (m_iTail + 1) % m_iQueueCapacity;
    m_iQueueLen ++;
    return true;
}
bool ALCircleQueue::DeQueue(int *element) {
    if (QueueEmpty()) {
        return false;
    }
    *element = m_pQueue[m_iHead];
    m_iHead = (m_iHead + 1) % m_iQueueCapacity;
    m_iQueueLen --;
    return true;
}

void ALCircleQueue::QueueTraverse() {
    for (int i = m_iHead; i < m_iQueueLen + m_iHead; i ++) {
        std::cout << m_pQueue[i % m_iQueueCapacity];
        std::cout << '\n';
    }
}


