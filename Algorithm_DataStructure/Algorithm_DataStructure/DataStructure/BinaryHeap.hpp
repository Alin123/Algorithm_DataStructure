//
//  BinaryHeap.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/4/3.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef BinaryHeap_hpp
#define BinaryHeap_hpp

#include <stdio.h>
#include "Swap.hpp"
#include "Stack.hpp"

#define HeapNodePosi(T) HeapNode<T>*

template <typename T>
class HeapNode {
public:
    T data;
    int rank;
    HeapNodePosi(T) parent;
    HeapNodePosi(T) lChild;
    HeapNodePosi(T) rChild;
#pragma mark 堆节点构造函数
    HeapNode(T e, int idx, HeapNodePosi(T) p = NULL, HeapNodePosi(T) l = NULL, HeapNodePosi(T) r = NULL) {
        data = e;
        rank = idx;
        parent = p;
        lChild = l;
        rChild = r;
    }
};

template <typename T>
class BinaryHeap {
private:
    HeapNodePosi(T) _root;   //优先级队列的根节点
    HeapNodePosi(T) _latest; //最新插入的节点
    int _size;               //规模
    Stack<int>* stack;       //辅助栈，用于查找指定秩的节点
protected:
    void removeAt(HeapNodePosi(T) node) {
        if (!node) {//递过基，空树
            return;
        }
        removeAt(node->lChild);
        removeAt(node->rChild);
        delete node;
    }
    HeapNodePosi(T) nodeAtRank(int rank) {
        if (rank == 0) {
            return _root;
        } else {
            while (rank) {
                stack->push(rank);
                rank = (rank - 1) >> 1;
            }
            HeapNodePosi(T) node = _root;
            while (!(stack->empty())) {
                if (stack->pop() % 2 == 0) {
                    node = node->rChild;
                } else {
                    node = node->lChild;
                }
            }
            return node;
        }
    }
    void percolateUp(HeapNodePosi(T) node) {//上滤，插入时使用
        while (node->parent) {
            if (node->data > node->parent->data) {
                swap(node->data, node->parent->data);
                node = node->parent;
            } else {
                break;
            }
        }
    }
    void percolateDown(HeapNodePosi(T) node) {//下滤，删除操作时使用
        while ((node->rank * 2 + 1) < _size) {//还有左孩子，则为非叶子节点
            if ((node->rank * 2 + 2) < _size) {//若有右孩子，则
                HeapNodePosi(T) bigger = node->lChild->data > node->rChild->data ? node->lChild : node->rChild;
                if (node->data < bigger->data) {//如果i小于较大的孩子
                    swap(node->data, bigger->data);
                    node = bigger;
                } else { //否者node大于等于较大者，那么说明顺序正确，不必再交换了
                    break;
                }
            } else {//只有左孩子
                if (node->data < node->lChild->data) {
                    swap(node->data, node->lChild->data);
                    node = node->lChild;
                } else {
                    break;
                }
            }
        }
    }
public:
    BinaryHeap() {
        _root = _latest = NULL;
        _size = 0;
        stack = new Stack<int>;
    }
    ~BinaryHeap() {
        delete stack;
        removeAt(_root);
        _root = _latest = NULL;
        _size = 0;
    }
    int size() const {
        return _size;
    }
    bool empty() const {
        return !_root;
    }
    void insert(T e) {
        HeapNodePosi(T) node = new HeapNode<T>(e, _size);
        if (_size == 0) {
            _root = _latest = node;
            _size ++;
        } else {
            int parentRank = (node->rank - 1) >> 1;//根据node的rank确定父亲的rank
            HeapNodePosi(T) parent = nodeAtRank(parentRank);//找到父亲
            node->parent = parent;//接入二叉树
            if (node->rank % 2 == 0) {
                parent->rChild = node;
            } else {
                parent->lChild = node;
            }
            _size++;//规模加一
            percolateUp(node);//上滤
            _latest = node;//更新最后的叶子节点
        }
    }
    T getMax() {
        return _root->data;
    }
    T delMax() {
        if (_size == 1) {
            T max = _root->data;
            delete _root;
            _root = _latest = NULL;
            _size --;
            return max;
        } else {
            T max = _root->data;
            T latest = _latest->data;
            if (_latest->rank % 2 == 0) {//如果是右孩子
                _latest->parent->rChild = NULL;//来自父亲的指针置空
            } else {//否者必为左孩子
                _latest->parent->lChild = NULL;//来自父亲的指针置空
            }
            delete _latest;
            _size --;
            _latest = nodeAtRank(_size - 1);
            _root->data = latest;
            percolateDown(_root);
            return max;
        }
    }
};

#endif /* BinaryHeap_hpp */
