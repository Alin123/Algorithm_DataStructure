//
//  Graph.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/23.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Graph_hpp
#define Graph_hpp

#include <stdio.h>
#include "Stack.hpp"
#include "Vertex.hpp"
#include "Edge.hpp"

template <typename Tv, typename Te>
class Graph {
private:
    void reset() { //所有顶点、边的辅助信息复位
        for (int i = 0; i < n; i++) {
            status(i) = UNDISCOVERED;
            dTime(i) = fTime(i) = -1;
            parent(i) = -1;
            priority(i) = __INT_MAX__;
            for (int j = 0; j < n; j++) {
                if (exists(i, j)) {
                    status(i, j) = UNDETERMINED;
                }
            }
        }
    }
    void BFS(int, int&);//广度优先搜索
    void DFS(int, int&);//深度优先搜索
    void BCC(int, int&, Stack<int>&); //基于DFS的双连通分量分解算法
    bool TSort(int, int&, Stack<Tv>*);//基于DFS的拓扑排序算法
public:
//顶点
    int n;//顶点总数
    virtual int insert(Tv const&) = 0; //插入顶点返回编号
    virtual Tv remove(int) = 0;//删除顶点及其关联边，返回该顶点信息
    virtual Tv vertex(int) = 0;//顶点v的数据（该顶点确实存在）
    virtual int inDegree(int) = 0;//顶点v的入度
    virtual int outDegree(int) = 0;//顶点v的出度
    virtual int firstNbr(int) = 0;//顶点v的首个邻接顶点
    virtual VStatus& status(int) = 0;//顶点v的状态
    virtual int& dTime(int) = 0;//顶点v的时间标签dTime
    virtual int& fTime(int) = 0;//顶点v的时间标签fTime
    virtual int& parent(int) = 0;//顶点v在遍历树中的父节点
    virtual int& priority(int) = 0;//顶点v在遍历树中的优先级数
//边
    int e;//边总数
    virtual bool exists(int, int) = 0;//边(v, u)是否存在
    virtual void insert(Te const&, int, int, int) = 0; //顶点v和u之间插入权重为w的边e
    virtual Te remove(int, int) = 0;//删除顶点v和u之间的边e，并返回边的信息
    virtual EStatus& status(int, int) = 0;//边(v, u)的状态
    virtual Te edge(int, int) = 0;//边(v, u)的数据
    virtual int& weight(int, int) = 0;//边(v, u)的权重
//算法
    void bfs(int);//广度优先搜索
    void dfs(int);//深度优先搜索
    void bcc(int);//基于DFS的双连通分量分解
    Stack<Tv>* tSrot(int);//基于DFS的拓扑排序
    void prim(int);//最小支撑树prim算法
    void dijkstra(int);//最短路径Dijkstra算法
    template <typename PU>//优先级更新器（函数对象）
    void pfs(int, PU);//优先级搜索
};


#endif /* Graph_hpp */
