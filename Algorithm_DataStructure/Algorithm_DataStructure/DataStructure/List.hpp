//
//  List.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/19.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef List_hpp
#define List_hpp

#include <stdio.h>
#include <stdlib.h>
#include "ListNode.hpp"

template <typename T>
class List {
private:
    int _size;               //规模
    ListNodePosi(T) header;  //头哨兵
    ListNodePosi(T) trailer; //尾哨兵
protected:
    void init() { //列表创建时的初始化
        header = new ListNode<T>;
        trailer = new ListNode<T>;
        header->succ = trailer; header->pred = NULL;
        trailer->pred = header; trailer->succ = NULL;
        _size = 0;
    }
    int clear() {
        int oldSize = _size;
        while (0 < _size) {
            remove(header->succ);
        }
        remove(oldSize);
    }
    void copyNodes(ListNodePosi(T) p, int n) {//列表内部方法：复制列表中自位置p起的n项
        init();
        while (n--) {
            insertAsLast(p->data);
            p = p->succ;
        }
    }
    void merge(ListNodePosi(T)& p, int n, List<T>& L, ListNodePosi(T) q, int m) {//有序列表区间归并
        //assert：this.valid(p) && rank(p) + n <= size && this.sorted(p, n)
        //        L.valid(p) && rank(q) + m <= L._size && L.sorted(q, m)
        // 注意：在归并排序之类的场合，很可能this == L && rank(p) + n = rank(q)
        ListNodePosi(T) pp = p->pred;
        while (0 < n) {
            if ((0 < n) && (p->data) <= q->data) {
                if (q == (p = p->succ)) {
                    break;
                }
                n--;
            } else {
                insertBefore(p, L.remove((q = q->succ)->pred));
                m--;
            }
        }
        p = pp->succ;
    }
    void mergeSort(ListNodePosi(T)& p, int n) {
        if (n < 2) {
            return;
        }
        int m = n >> 1;
        ListNodePosi(T) q = p;
        for (int i = 0; i < m; i++) {
            q = q->succ;
        }
        mergeSort(p, m);
        mergeSort(q, n - m);
        merge(p, m, *this, q, n - m);
    }
    void selectionSort(ListNodePosi(T) p, int n) {//vaild(p) && rank(p) + n ≤ size
        ListNodePosi(T) head = p->pred;
        ListNodePosi(T) tail = p;
        for (int i = 0; i < n; i++) {
            tail = tail->succ;
        }
        while (1 < n) {
            ListNodePosi(T) max = selectMax(head->succ, n);
            insertBefore(tail, remove(max));
            tail = tail->pred;
            n--;
        }
    }
    void insertionSort(ListNodePosi(T) p, int n) {
        for (int i = 0; i < n; i ++) {
            ListNodePosi(T) target = search(p->data, i, p);
            insertAfter(target, p->data);
            p = p->succ;
            remove(p->pred);
        }
    }
public:
//构造函数
    List() {
        init();
    }
    List(List<T> const& L) {
        copyNodes(L.first(), L._size);
    }
    List(List<T> const& L, Rank r, int n) {
        copyNodes(L[r], n);
    }
    List(ListNodePosi(T) p, int n) {//复制列表中自位置p起的n项，assert：p为合法位置，且至少有n-1个后继节点
        copyNodes(p, n);
    }
//析构函数
    ~List() {//释放（包含头、尾哨兵在内的）所有节点
        clear();
        delete header;
        delete trailer;
    }
//只读访问接口
    int size() const {
        return _size;
    }
    bool empty() const {
        return _size < 0;
    }
    ListNodePosi(T) operator[](Rank r) const {//重载，支持循秩访问，但效率低
        ListNodePosi(T) p = first();
        while (0 < r--) {
            p = p->succ;
        }
        return p;
    }
    ListNodePosi(T) first() const {
        return header->succ;
    }
    ListNodePosi(T) last() const {
        return trailer->pred;
    }
    bool valid(ListNodePosi(T) p) {
        return p && (p != header) && (p != trailer);
    }
    bool valid(ListNodePosi(T) p, Rank r, ListNodePosi(T) q) {//判断p是否为q的前驱且距离不超过r
        while (0 < r--) {
            if (p == (q = q->pred)) {
                return true;
            }
        }
        return false;
    }
    bool valid(ListNodePosi(T) p, ListNodePosi(T) q, Rank r) {//判断p是否为q的后继且距离不超过r
        while (0 < r--) {
            if (p == (q = q->succ)) {
                return true;
            }
        }
        return false;
    }
    int disordered() const {
        
    }
    ListNodePosi(T) find(T const& e, int n, ListNodePosi(T) p) const { //无序区间查找：在无序列表内节点p(可能是trailer)的n个(真)前驱中，找到等于e的最后者
        while(0 < n--) {
            if(e == (p = p->pred)->data) {
                return p;
            }
        }
        return NULL;
    }
    ListNodePosi(T) find(T const& e) const {
        find(e, _size, trailer);
    }
    //在有序列表内节点p(可能是trailer)的n个(真)前驱中，找到不大于e的最后者
    ListNodePosi(T) search(T const& e, int n, ListNodePosi(T) p) const {//有序区间查找
        //assert: 0 ≤ n ≤ rank(p) < _size
        while(0 <= n--) {
            if ((p = p->pred)->data <= e) {
                break;
            }
        }
        return p;
    }
    ListNodePosi(T) search(T const& e) const {
        return search(e, _size, trailer);
    }
    ListNodePosi(T) selectMax(ListNodePosi(T) p, int n) {//在p及前n-1个后继中选出最大者
        ListNodePosi(T) max = p;
        for (ListNodePosi(T) cur = p; 1 < n; n--) {
            if ((cur = cur->succ)->data >= max->data) {
                max = cur;
            }
        }
        return max;
    }
    ListNodePosi(T) selectMax() {
        return selectMax(header, _size);
    }
//可写访问接口
    ListNodePosi(T) insertAsFirst(T const& e) {
        _size++;
        return header->insertAsSucc(e);
    }
    ListNodePosi(T) insertAsLast(T const& e) {
        _size++;
        return trailer->insertAsSucc(e);
    }
    ListNodePosi(T) insertBefore(ListNodePosi(T) p, T const& e) {//将e当作p的前驱插入
        _size++;
        p->insertAsPred(e);
    }
    ListNodePosi(T) insertAfter(ListNodePosi(T) p, T const& e) {//将e当作p的后继插入
        _size++;
        p->insertAsSucc(e);
    }
    T remove(ListNodePosi(T) p) {//删除合法位置p处的节点，返回被删除节点
        T data = p->data;
        p->pred->succ = p->succ;
        p->succ->pred = p->pred;
        delete p;
        _size --;
        return data;
    }
    void merge(List<T>& L) { //全列表归并
        merge(first(), _size, L, L.first(), L._size);
    }
    void sort(ListNodePosi(T) p, int n) {
        switch (rand() % 3) {
            case 0:
                insertionSort(p, n);
                break;
            case 1:
                selectionSort(p, n);
                break;
            default:
                mergeSort(p, n);
                break;
        }
    }
    void sort() {
        sort(first(), _size);
    }
    int deduplicate() {//无序去重
        if (_size < 2) {
            return 0;
        }
        int oldSize = _size;
        ListNodePosi(T) p = header;
        Rank r = 0;
        while (trailer != (p = p->succ)) {
            ListNodePosi(T) q = find(p->data, r, p);
            if (q) {
                remove(q);
            } else {
                r++;
            }
        }
        return oldSize - _size;
    }
    int uniquify() {//有序去重
        if (_size < 2) {
            return 0;
        }
        int oldSize = _size;
        ListNodePosi(T) p = header;
        while (trailer != p) {
            if (p->succ != trailer) {
                if (p->succ->data == p->data) {
                    remove(p->succ);
                } else {
                    p = p->succ;
                }
            }
        }
        return oldSize - _size;
    }
//遍历
    void traverse(void (*visit)(T&)) {
        for (ListNodePosi(T) p = header->succ; p != trailer; p = p->succ) {
            visit(p->data);
        }
    }
    template <typename VST>
    void traverse(VST&) {
        for (ListNodePosi(T) p = header->succ; p != trailer; p = p->succ) {
            visit(p->data);
        }
    }
};



#endif /* List_hpp */
