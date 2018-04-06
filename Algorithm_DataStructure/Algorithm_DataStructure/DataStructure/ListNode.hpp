//
//  ListNode.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/19.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef ListNode_hpp
#define ListNode_hpp

#include <stdio.h>

typedef int Rank;
#define ListNodePosi(T) ListNode<T>* //列表节点位置

template <typename T>
class ListNode {
public:
//成员
    T data;
    ListNodePosi(T) pred;
    ListNodePosi(T) succ;
// 构造函数
    ListNode() {}
    ListNode(T e, ListNodePosi(T) p = NULL, ListNodePosi(T) s = NULL) {
        data = e;
        pred = p;
        succ = s;
    }
// 操作接口
    ListNodePosi(T) insertAsPred(T const& e) { //紧随当前节点之前插入新节点
        ListNodePosi(T) x = new ListNode(e, pred, this);
        pred->succ = x;
        pred = x;
        return x;
    }
    ListNodePosi(T) insertAsSucc(T const& e) {//紧随当前节点之后插入新节点
        ListNodePosi(T) x = new ListNode(e, this, succ);
        succ = x;
        succ->pred = x;
        return x;
    }
};

#endif /* ListNode_hpp */
