//
//  Quadlist.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/28.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Quadlist_hpp
#define Quadlist_hpp

#include <stdio.h>
#include "QuadlistNode.hpp"

template <typename T>
class Quadlist {
private:
    int _size;                    //规模
    QuadlistNodePosi(T) header;   //头哨兵
    QuadlistNodePosi(T) trailer;  //尾哨兵
protected:
    void init() {
        header = new QuadlistNode<T>;  //创建头哨兵节点
        trailer = new QuadlistNode<T>; //创建尾哨兵节点
        header->pred = NULL; header->succ = trailer;
        trailer->pred = header; trailer->succ = NULL;
        header->above = trailer->above = NULL;
        header->below = trailer->below = NULL;
        _size = 0;
    }
    
    int clear() {
        int oldSize = _size;
        while (0 < _size) {
            remove(fist());
        }
        return oldSize;
    }
public:
    /**
     * 默认构造函数
     */
    Quadlist() {
        init();
    }
    /**
     * 析构函数
     */
    ~Quadlist() {
        clear();
        delete header;
        delete trailer;
    }
//只读访问接口
    int size() const {      //规模
        return _size;
    }
    bool empty() const {    //判空
        return _size <= 0;
    }
    QuadlistNodePosi(T) fist() const { //首节点位置
        return header->succ;
    }
    QuadlistNodePosi(T) last() const { //末节点位置
        return trailer->pred;
    }
    bool valid(QuadlistNodePosi(T) p) {//判断p是否对外合法
        return (header != p) && (trailer != p);
    }
//可写访问接口
    /**
     *  删除（合法）位置p处的节点，返回删除节点的数据
     */
    T remove(QuadlistNodePosi(T) p) {
        T e = p->data;
        p->pred->succ = p->succ;
        p->succ->pred = p->pred;
        release(p);_size --;
        return e;
    }
    /**
     * 将e作为p的后继、b的上邻插入
     */
    QuadlistNodePosi(T) insertAfterAbove(T const& e, QuadlistNodePosi(T) p, QuadlistNodePosi(T) b = NULL) {
        _size++;
        return p->insertAsSuccAbove(e, b);//返回新节点位置（below = NULL，上面的元素为空）
    }
//遍历
    /**
     * 遍历个节点，依次实施指定操作（函数指针，只读或局部修改）
     */
    void traverse(void (*visit)(T&)) {
        QuadlistNodePosi(T) p = fist();
        while (valid(p)) {
            visit(p->data);
            p = p->succ;
        }
    }
    /**
     * 遍历个节点，依次实施指定操作（函数对象，可全局性修改节点）
     */
    template <typename VST> void traverse(VST visit) {
        QuadlistNodePosi(T) p = fist();
        while (valid(p)) {
            visit(p->data);
            p = p->succ;
        }
    }
};

#endif /* Quadlist_hpp */
