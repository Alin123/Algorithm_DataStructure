//
//  Vertex.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/24.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Vertex_hpp
#define Vertex_hpp

#include <stdio.h>

typedef enum {
    UNDISCOVERED,//undiscovered
    DISCOVERED,  //discovered
    VISITED      //visited
}VStatus;

template <typename Tv> struct Vertex {
    Tv data;//数据
    int inDegree;//入度
    int outDegree;//出度
    VStatus status;//状态
    int dTime;//时间标签，开始访问当前顶点的时间
    int fTime;//时间标签，当前顶点访问完毕的时间，BFS：当前顶点所有的邻接点都已被发现且入队(入队以便下一轮的访问)，那么当前顶点访问完毕，fTime记录该时刻；
              //DFS：当前顶点所有的邻接点都已被DFS，那么当前顶点访问完毕，fTime记录该时刻。
    int parent;//在遍历树中的父节点
    int priority;//在遍历树中的优先级（如Dijkstra中的路径长度、Prim中的极短跨越边长度等）
    Vertex(Tv const& d): data(d), inDegree(0), outDegree(0), status(UNDISCOVERED),
                         dTime(-1), fTime(-1), parent(-1), priority(__INT_MAX__) {}
};

#endif /* Vertex_hpp */
