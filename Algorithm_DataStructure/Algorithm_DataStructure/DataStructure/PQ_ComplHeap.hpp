//
//  PQ_ComplHeap.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/4/1.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef PQ_ComplHeap_hpp
#define PQ_ComplHeap_hpp

#include <stdio.h>
#include "PriorityQueue.hpp"
#include "Vector.hpp"

#define Node(PQ, i) ((PQ)[i])
#define InHeap(n, i) (((-1) < (i)) && ((i) < (n)))
#define Parent(i) ((i - 1) >> 1)
#define LastInternal(n) Parent(n-1)  //最后一个内部节点
#define LChild(i) (1 + ((i) << 1))   //PQ[i]的左孩子
#define RChild(i) ((1 + (i)) << 1)   //PQ[i]的左孩子
#define ParentValid(i) (0 < i)       //判断PQ[i]是否有父亲
#define LChildValid(n, i) InHeap(n, LChild(i)) //判断PQ[i]是否有一个左孩子
#define RChildValid(n, i) InHeap(n, RChild(i)) //判断PQ[i]是否有两个孩子
#define Bigger(PQ, i, j) (Node(PQ, i) < Node(PQ, j) ? j : i) //取大者
/*若有右孩子，那么在i、LChild(i)、RChild(i)中取最大者，它堪为父者*/
/*否则，若有左孩子，在i、LChild(i)中取最大者，它堪为父者*/
/*再否则，则无左右孩子，i堪为父者*/
#define ProperParent(PQ, n, i) \
        (RChildValid(n, i) ? Bigger(PQ, Bigger(PQ, i, LChild(i)), RChild(i)) : \
        (LChildValid(n, i) ? Bigger(PQ, i, LChild(i)) : i \
        ) \
        ) //父子至多三者中的大者，相等时父节点优先，如此可避免不必要的交换

template <typename T>
class PQ_ComplHeap {
private:
    Vector<T>* heap;  //存放各词条的向量
public:
    /// @brief 默认构造器创建内部向量
    PQ_ComplHeap() {
        heap = new Vector<T>;
    }
    /// @brief Floyd建堆算法：对内部节点依次做下滤操作，O(n)的时间，
    static T* heapify(T* E, Rank lo, Rank hi) {
        int n = hi - lo;
        for (Rank i = LastInternal(n); InHeap(n, i); i--) {//至底而上，依次
            percolateDown(E + lo, n, i);//下滤各内部节点
        }
        return E;
    }
    static T* heapify(T* E, int n) {
        return heapify(E, 0, n);
    }
    PQ_ComplHeap(T* E, int n) {
        heap = new Vector<T>(heapify(E, n), n);
    }
    /// @brief 析构函数
    ~PQ_ComplHeap() {
        delete heap;
    }
    int size() {
        return heap->size();
    }
    bool empty() {
        return heap->empty();
    }
    /// @brief 完全二叉堆词条上滤算法：在向量*A中，对第i个词条实施上滤
    static Rank percolateUp(Vector<T>* A, Rank i) {
        while (ParentValid(i)) {
            Rank j = Parent(i);//j是i的父亲
            if (Node(*A, j) > Node(*A, i)) {//一旦当父亲大于儿子（不再逆序），上滤过程旋即结束
                break;
            }
            swap(Node(*A, i), Node(*A, j));//否者父子交换位置
            i = j;//往上
        }
        return i;
    }
    /// @brief 将词条插入完全二叉堆
    void insert(T e) {
        heap->insert(size(), e); //首先将新词条接入于内部向量的尾部
        percolateUp(heap, size() - 1);
        
    }
    /// @brief 获取非空完全二叉堆中优先级最高的词条
    T getMax() {
        return (*heap)[0];
    }
    static Rank percolateDown(Vector<T>* A, Rank n, Rank i) {
        Rank j;//i及其最多两个孩子中，堪为父者
        while (i != (j = ProperParent(*A, n, i))) {//只要i非j（i不能堪任父亲），则
            swap(Node(*A, i), Node(*A, j));//二者交换位置
            i = j;//并继续考察下降后的i
        }
        return j;//返回下滤抵达的位置亦i亦j
    }
    static Rank percolateDown(T* E, Rank n, Rank i) {
        Rank lc = 2 * i + 1;
        Rank rc = 2 * i + 2;
        while (true) {
            if (rc < n) {//有右孩子，则
                Rank bigger = E[lc] < E[rc] ? rc : lc;//i与左、右孩子中较大者比较
                if (E[i] < E[bigger]) {//如果i小于较大的孩子
                    swap(E[i], E[bigger]); //交换
                    i = bigger;            //记录新的i位置
                } else {    //否者，下滤结束
                    break;
                }
            } else if (lc < n && E[i] < E[lc]) {//有左孩子，且i小于左孩子，则
                swap(E[i], E[lc]); //交换
                i = lc;            //记录新的i位置
            } else {  //否者无左孩子，或只有左孩子但左孩子小于等于i
                break;//下滤结束
            }
            lc = 2 * i + 1;
            rc = 2 * i + 2;
        }
        return i;
    }
    static void heapSort(T* E, Rank lo, Rank hi) {
        heapify(E, lo, hi);
        while (lo < hi - 1) {
            T max = E[0];
            T last = E[hi - 1];
            E[0] = last;
            percolateDown(E, hi - lo, 0);
            E[hi - 1] = max;
            hi --;
        }
    }
    T delMax() {
        T max = (*heap)[0];
        (*heap)[0] = heap->remove(size() - 1);
        percolateDown(heap, size(), 0);
        return max;
    }
};



#endif /* PQ_ComplHeap_hpp */
