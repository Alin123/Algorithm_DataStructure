//
//  QuadlistNode.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/28.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef QuadlistNode_hpp
#define QuadlistNode_hpp

#include <stdio.h>
#include "Entry.hpp"

#define QuadlistNodePosi(T) QuadlistNode<T>*

template <typename T>
class QuadlistNode {
public:
//成员
    T data;
    QuadlistNodePosi(T) pred;  QuadlistNodePosi(T) succ;   //前驱、后继
    QuadlistNodePosi(T) above; QuadlistNodePosi(T) below; //上邻、下邻
//构造函数
    /**
     * 针对header、trailer的构造
     */
    QuadlistNode(){}
    /**
     * 默认构造器
     */
    QuadlistNode(T e, QuadlistNodePosi(T) p = NULL, QuadlistNodePosi(T) s = NULL,
                 QuadlistNodePosi(T) a = NULL, QuadlistNodePosi(T) b = NULL): data(e), pred(p), succ(s), above(a), below(b) {}
//操作接口
    /**
     * 插入新节点，以当前节点为前驱，以节点b为下邻
     */
    QuadlistNodePosi(T) insertAsSuccAbove(T const& e, QuadlistNodePosi(T) b = NULL) {
        QuadlistNodePosi(T) x = new QuadlistNode(e, this, succ, NULL, b);//创建新节点
        succ->pred = x; succ = x;//设置水平逆向链接
        if (b) b->above = x;     //设置垂直逆向链接
        return x;
    }
};

#endif /* QuadlistNode_hpp */
