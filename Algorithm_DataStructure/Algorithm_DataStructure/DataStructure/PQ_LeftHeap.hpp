//
//  PQ_LeftHeap.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/4/4.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef PQ_LeftHeap_hpp
#define PQ_LeftHeap_hpp

#include <stdio.h>
#include "PriorityQueue.hpp"
#include "BinTree.hpp"

template <typename T>
class PQ_LeftHeap: public PriorityQueue<T> {//以左式堆形式实现的优先级队列
private:
    BinTree<T>* heap;//各元素在内部组织为二叉树
public:
    PQ_LeftHeap() {
        heap = new BinTree<T>;
    }
    PQ_LeftHeap(T* E, int n) {
        heap = new BinTree<T>;
    }
    ~PQ_LeftHeap() {
        delete heap;
    }
    int size() const {
        return heap->size();
    }
    bool empty() const {
        return heap->empty();
    }
    
    static void exchangeChildren(BinNodePosi(T) v) {//左右孩子对换
        BinNodePosi(T) t = v->lChild;
        v->lChild = v->rChild;
        v->rChild = t;
    }
    // 合并以a和b为节点的两个左式堆，其中前者的优先级更高
    static BinNodePosi(T) merge1(BinNodePosi(T) a, BinNodePosi(T) b) {
        if (!HasLChild(*a)) {//a没有左孩子
            a->lChild = b; //直接将b作为a的左孩子
            b->parent = a;
        } else { //否则
            a->rChild = merge(a->rChild, b);//将b与a的右子堆合并
            a->rChild->parent = a;//并更新父子关系
            if (a->lChild->npl < a->rChild->npl) {//合并后，若a的左子堆的npl更小，则
                exchangeChildren(a);//交换a的左、右子堆————如此可保证右子堆的npl更小
            }
            a->npl = a->rChild->npl + 1;//更新a的npl
        }
    }
    //根据相对优先级确定合宜的方案，合并以a和b为根节点的两个左式堆
    static BinNodePosi(T) merge(BinNodePosi(T) a, BinNodePosi(T) b) {
        if (!a) return b;//退化情况
        if (!b) return a;//退化情况
        if (a->data < b->data) {
            return merge1(b, a);
        } else {
            return merge1(a, b);
        }
    }
            
    void insert(T const& e) {
        BinNodePosi(T) v = new BinNode<T>(e);
        heap->_root = merge(heap->_root, v);
        heap->_root->parent = NULL;
        heap->_size++;
    }
    T getMax() {
        return heap->_root->data;
    }
    T delMax() {
        BinNodePosi(T) lHeap = heap->_root->lChild;
        BinNodePosi(T) rHeap = heap->_root->rChild;
        T e = heap->_root->data;
        delete heap->_root;
        heap->_size--;
        heap->_root = merge(lHeap, rHeap);
        if (heap->_root) {
            heap->_root->parent = NULL;
        }
        return e;
    }
    
};

#endif /* PQ_LeftHeap_hpp */
