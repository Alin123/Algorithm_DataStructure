//
//  PrimPU.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/26.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef PrimPU_hpp
#define PrimPU_hpp

#include <stdio.h>
#include "Graph.hpp"

template <typename Tv, typename Te>
struct PrimPU {//针对Prim算法的顶点优先级更新器
    virtual void operator()(Graph<Tv, Te>* g, int uk, int v) {
        if (g->status(v) == UNDISCOVERED) {//对于uk每一尚未被发现的邻接顶点v
            if (g->priority(v) > g->weight(uk, v)) {//按Prim策略做松弛
                g->priority(v) = g->weight(uk, v);
                g->parent(v) = uk;
            }
        }
    }
};

#endif /* PrimPU_hpp */
