//
//  GraphMatrix.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/24.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef GraphMatrix_hpp
#define GraphMatrix_hpp

#define Graph_n (Graph<Tv, Te>::n)
#define Graph_e (Graph<Tv, Te>::e)

#include <stdio.h>
#include "Graph.hpp"
#include "Queue.hpp"

template <typename Tv, typename Te>
class GraphMatrix: public Graph<Tv, Te> {
private:
    Vector<Vertex<Tv>*> V; //顶点(的指针)集
    Vector<Vector<Edge<Te>*>> E; //边(的指针)集
    
    void BFS(int v, int& clock) {//广度优先搜索BFS算法（单连通域）
        Queue<int> Q;//引入辅助队列
        status(v) = DISCOVERED;//标记起点为“已发现的”顶点
        Q.enqueue(v);//起点入队列
        while (!Q.empty()) {//在Q变空前，不断
            int v = Q.dequeue(); dTime(v) = ++clock;//取出队首顶点v
            for (int u = firstNbr(v); -1 < u ; u = nextNbr(v, u)) {//枚举v的所有邻居u
                if (status(u) == UNDISCOVERED) {//若u尚未被发现，则
                    status(u) = DISCOVERED;//发现该顶点
                    Q.enqueue(V[u]);//该顶点入队
                    status(v, u) = TREE;parent(u) = v;//引入树边拓展支撑树
                } else {//若u已被发现，或者甚至已经访问完毕，则
                    status(v, u) = CROSS;//将(v, u)归类于跨边
                }
            }
            status(v) = VISITED;//自次点顶点访问完毕
        }
    }
    void DFS(int v, int& clock) {//深度优先搜索DFS算法（单连通域）
        dTime(v) = ++clock; status(v) = DISCOVERED; //发现当前顶点v
        for (int u = firstNbr(v); -1 < u; u = nextNbr(v, u)) {//枚举v的所有邻居
            switch (status(u)) {//并视其状态而分别处理
                case UNDISCOVERED: {//u尚未发现，意味着支撑树可在此拓展
                    status(v, u) = TREE;
                    parent(u) = v;
                    DFS(u, &clock);
                }
                    break;
                case DISCOVERED: {//u已被发现但尚未访问完毕，应属被后代指向的祖先
                    status(v, u) = BACKWARD;
                }
                    break;
                default: {//u已访问完毕（VISITED，有向图），则视承袭关系分为前向边或跨边
                    status(v, u) = (dTime(v) < dTime(u)) ? FORWARD : CROSS;
                }
                    break;
            }
        }
        status(v) = VISITED;//至此，当前顶点v方告访问完毕
        fTime(v) = ++clock;
    }
    bool TSort(int v, int& clock, Stack<Tv>* S) {//基于DFS的拓扑排序算法（单趟）
        dTime(v) = ++clock; status(v) = VISITED;//发现顶点v
        for (int u = firstNbr(v); -1 < u; u = nextNbr(v, u)) {//枚举v的所有邻居u
            switch (status(v)) {//并视u的状态分别处理
                case UNDISCOVERED: {
                    parent(u) = v;
                    status(v, u) = TREE;
                    if (!TSort(u, &clock, S)) {//从顶点u深入
                        return false;
                    }
                }
                    break;
                case DISCOVERED: {
                    status(v, u) = BACKWARD;//一旦发现后向边（非DAG，而是有环图），则
                    return false;//退出而不再深入
                }
                    break;
                default: {//VISTED（有向图 only）
                    status(v, u) = (dTime(v) < dTime(u)) ? FORWARD : CROSS;
                }
                    break;
            }
        }
        status(v) = VISITED;
        S->push(vertex(v));
        return true;
    }
public:
// 构造、析构
    GraphMatrix() {
        Graph_n = 0;
        Graph<Tv, Te>::e = 0;
    }
    ~GraphMatrix() {
        for (int j = 0; j < Graph_n; j++) {
            for (int k = 0; k < Graph<Tv, Te>::e; k++) {
                delete E[j][k];//清除所有动态申请的边的记录
            }
        }
    }
//顶点访问操作（该顶点确实存在）
    virtual int insert(Tv const& vertex) {//插入顶点，返回编号
        E.insert(Vector<Edge<Te>*>());//创建对应的边向量
        for (int j = 0; j < Graph_n; j++) {//对应的边向量初始化为空
            E[Graph_n].insert(NULL);
        }
        Graph_n++;
        for (int j = 0; j < Graph_n; j++) {
            E[j].insert(NULL);
        }
        return V.insert(new Vertex<Tv>(vertex));
    }
    virtual Tv remove(int i) {// 删除顶点及其关联边，返回该顶点信息
        for (int j = 0; j < Graph_n; j++) {//更新度数
            if (exists(i, j)) {//i的出边
                Graph_e--;
                V[j]->inDegree--;
            }
            if (exists(j, i)) {//i的入边
                Graph_e--;
                V[j]->outDegree--;
            }
        }
        if (exists(i, i)) {//追回可能重复的边计数
            Graph_e++;
        }
        Tv d = V.remove(i)->data;Graph_n--;//删除顶点
        E.remove(i);//及对应的第i行
        for (int j = 0; j < Graph_n; j++) {//删除各行的第i列
            E[j].remove[i];
        }
        return d;
    }
// 顶点查询操作
    virtual Tv vertex(int i) {
        return V[i]->data;
    }
    virtual int inDegree(int i) {
        return V[i]->inDegree;
    }
    virtual int outDegree(int i) {
        return V[i]->outDegree;
    }
    virtual int firstNbr(int i) {//顶点i的首个邻接顶点
        return nextNbr(i, Graph_n);
    }
    virtual int nextNbr(int i, int j) {//顶点i的相对于顶点j的下一邻接顶点
        while ((-1 < j) && !exists(i, j)) {
            j--;
        }
        return j;
    }
    virtual VStatus& status(int i) {
        return V[i]->status;
    }
    virtual int& dTime(int i) {
        return V[i]->dTime;
    }
    virtual int& fTime(int i) {
        return V[i]->fTime;
    }
    virtual int& parent(int i) {
        return V[i]->parent;
    }
    virtual int& priority(int i) {
        return V[i]->priority;
    }
//边确认操作
    virtual bool exists(int i, int j) {
        return (0 <= i) && (i < Graph_n) &&
               (0 <= j) && (j < Graph_n) &&
               E[i][j] != NULL;
    }
//访问边操作
    virtual void insert(Te const& edge, int w, int i, int j) {//插入权重为w的边e = (i, j)
        if (exists(i, j)) {
            return;
        }
        Graph_e++;
        E[i][j] = new Edge<Te>(edge, w);
        V[i]->outDegree++;
        V[j]->inDegree++;
    }
    virtual Te remove(int i, int j) {//
        if (!exists(i, j)) {
            return NULL;
        }
        Te edge = E[i][j]->data;
        Graph_e--;
        E[i][j] = NULL;
        V[i]->outDegree--;
        V[j]->inDegree--;
        return edge;
    }
//边查询操作
    virtual EStatus status(int i, int j) {
        return E[i][j]->status;
    }
    virtual Te edge(int i, int j) {
        return E[i][j]->data;
    }
    virtual int& weight(int i, int j) {
        return E[i][j]->weight;
    }
    void bfs(int s) {
        Graph<Tv, Te>::reset();
        int clock = 0; int v = s;//初始化
        do {
            if (status(v) == UNDISCOVERED) {
                BFS(v, &clock);
            }
        } while (s != (v = (++v % Graph_n)));
    }
    void dfs(int s) {//深度优先搜索DFS算法（全图）
        Graph<Tv, Te>::reset();//初始化
        int clock = 0; int v = s;//从编号s的顶点开始
        do {//逐一检查所有顶点
            if (status(v) == UNDISCOVERED) {//一旦遇到尚未发现的顶点
                DFS(v, clock);//即从该顶点出发启动一次DFS
            }
        } while (s != (v = (++v % Graph_n)));//按序号检查，故不漏不重
    }
    Stack<Tv>* tSort(int s) {//基于DFS的拓扑排序算法
        Graph<Tv, Te>::reset();
        int clock = 0;
        int v = s;
        Stack<Tv>* S = new Stack<Tv>;//用栈记录排序顶点
        do {
            if (UNDISCOVERED == status(v)) {
                if (!TSort(v, clock, S)) {//clock不是必需
                    while (!S->empty()) {//任一连通域（亦即整图）非DAG，则直接返回
                        S->pop();
                    }
                    break;
                }
            }
        } while (s != (v = (++v % Graph_n)));
        return S;//若输入为DAG，则S内各顶点自顶而底排序，否则（不存在拓扑排序），S空
    }
    template <typename PU>//优先级更新器（函数对象）
    void pfs(int s, PU prioUpdater) {//优先级搜索算法框架
        Graph<Tv, Te>::reset();//初始化，起点s加入遍历树
        priority(s) = 0;
        status(s) = VISITED;
        parent(s) = -1;
        for (int i = 1; i < Graph_n; i++) {//依次引入n-1个顶点和n-1条边，循环的趟数
            for (int w = firstNbr(s); -1 < w; w = nextNbr(s, w)) {//枚举s所有的邻居w
                prioUpdater(this, s, w);//更新顶点w的优先级及其父顶点
            }
            for (int shortest = __INT_MAX__, w = 0; w < Graph_n; w++) {
                if (status(w) == UNDISCOVERED) {//从尚未加入遍历树的顶点中
                    if (shortest > priority(w)) {//选出下一个
                        shortest = priority(w);//优先级最高的顶点s
                        s = w;
                    }
                }
            }
            status(s) = VISITED;//将s及其与父顶点的联边加入遍历树
            status(parent(s), s) = TREE;
        }
    }//通过定义具体的优先级更新策略prioUpdater，即可实现不同算法功能
};

#endif /* GraphMatrix_hpp */
