//
//  BinNode.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/22.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef BinNode_hpp
#define BinNode_hpp

#include <stdio.h>
#include "Stack.hpp"
#include "Queue.hpp"

#define BinNodePosi(T) BinNode<T>*          //节点位置
#define stature(p) ((p) ? (p->height) : -1) //节点高度
typedef enum {RB_RED, RB_BLACK} RBColor;    //节点颜色

template <typename T>
class BinNode {
public:
    T data;
    BinNodePosi(T) parent; // 父节点
    BinNodePosi(T) lChild; // 左孩子
    BinNodePosi(T) rChild; // 右孩子
    int height;            // 高度
    int npl;               // Null Path Length 左式堆
    RBColor color;         // 颜色(红黑树)
//构造函数
    BinNode() : parent(NULL), lChild(NULL), rChild(NULL), height(0), npl(1), color(RB_RED) {}
    BinNode(T e, BinNodePosi(T) p = NULL, BinNodePosi(T) lc = NULL, BinNodePosi(T) rc = NULL, int h = 0, int l = 1, RBColor c = RB_RED) : data(e), parent(p), lChild(lc), rChild(rc), height(h), npl(l), color(c) {}
//操作接口
    int size() {//统计当前节点后代总数
        if (!HasChild(*this)) {
            return 0;
        } else if (HasLChild(*this) && !HasRChild(*this)) {
            return 1 + lChild->size();
        } else if (HasRChild(*this) && !HasLChild(*this)) {
            return 1 + rChild->size();
        } else {
            return 1 + lChild->size() + rChild->size();
        }
    }
    BinNodePosi(T) insertAsLC(T const& e) {// 作为当前节点的左孩子插入新节点
        lChild = new BinNode(e, this);
    }
    BinNodePosi(T) insertAsRC(T const& e) {// 作为当前节点的右孩子插入新节点
        rChild = new BinNode(e, this);
    }
    BinNodePosi(T) succ() { // 取当前节点的直接后继
        BinNodePosi(T) s = this;//记录后继的临时变量
        if (rChild) { //如果有右孩子节点，则直接后继必在右子树中，具体地就是
            s = rChild; //右子树中
            while(HasLChild(*s))
                s = s->lChild;//最靠左（最小）的节点
        } else {//否则，直接后继应该是“将当前节点包含于其左子树中的最低祖先”，具体地就是
            while(IsRChild(*s))//逆向地沿右向分支，不断朝左上方移动
                s = s->parent;
            s = s->parent;//最后再朝右上发移动一步，即抵达直接后继（如果存在）
        }
        return s;
    }
    template <typename VST> void travLevel(VST& visit) { //子树层次遍历
        travLevel(this, visit);
    }
    template <typename VST> void travPre(VST& visit) {   //子树先序遍历
        switch (rand() % 3) {
            case 1: travPre_I1(this, visit); break;
            case 2: travPre_I2(this, visit); break;
            default: travPre_R(this, visit); break;
        }
    }
    template <typename VST> void travIn(VST& visit) {    //子树中序遍历
        switch (rand() % 4) {
            case 1: travIn_I1(this, visit); break;
            case 2: travIn_I2(this, visit); break;
            case 3: travIn_I3(this, visit); break;
            default: travIn_R(this, visit); break;
        }
    }
    template <typename VST> void travPost(VST& visit) {  //子树后续遍历
        switch (rand() % 2) {
            case 1: travPost_I(this, visit); break;
            default: travPost_R(this, visit); break;
        }
    }
//递归遍历
    template <typename VST> void travPre_R(BinNodePosi(T) x, VST& visit) {
        if (!x) {
            return;
        }
        vist(x->data);
        travPre_R(x->lChild, visit);
        travPre_R(x->rChild, visit);
    }
    template <typename VST> void travIn_R(BinNodePosi(T) x, VST& visit) {
        if (!x) {
            return;
        }
        travIn_R(x->lChild, visit);
        visit(x->data);
        travIn_R(x->rChild, visit);
    }
    template <typename VST> void travPost_R(BinNodePosi(T) x, VST& visit) {
        if (!x) {
            return;
        }
        travPost_R(x->lChild, visit);
        travPost_R(x->rChild, visit);
        visit(x->data);
    }
// 迭代遍历
    template <typename VST> void travPre_I1(BinNodePosi(T) x, VST& visit) {//二叉树先序遍历算法
        Stack<BinNodePosi(T)> stack;//辅助栈
        if (x) {
            stack.push(x);          //根节点
        }
        while (!stack.empty()) {    //再无节点是退出
            x = stack.pop();        //弹出并访问当前节点
            visit(x->data);
            if (HasLChild(x)) {     //其非空子节点依次入栈
                stack.push(x->lChild);
            }
            if (HasRChild(x)) {
                stack.push(x->rChild);
            }
        }
    }
    template <typename VST>//从当前节点出发，沿左分支不断深入，直至没有左分支的节点；沿途节点遇到后立即访问，若还有右子节点则入栈
    static void visitAlongLeftBranch(BinNodePosi(T) x, VST& visit, Stack<BinNodePosi(T)>& stack) {
        if (x) {
            visit(x->data);
            if (HasRChild(x)) {
                stack.push(x->rChild);
            }
            x = x->lChild;
        }
    }
    template <typename VST> void travPre_I2(BinNodePosi(T) x, VST& visit) {//二叉树先序遍历算法
        Stack<BinNodePosi(T)> stack;
        while (true) {
            visitAlongLeftBranch(x, visit, stack);//从当前节点出发，逐批访问
            if (stack.empty()) {//直到栈空
                break;
            }
            x = stack.pop(); //弹出下一批节点的起点
        }
    }
    /*
    template <typename VST>
    static void visitAndPushLeft(VST& visit, Stack<BinNodePosi(T)>& stack) {
        BinNodePosi(T) x = stack.pop();
        visit(x->data);
        if (HasRChild(x)) {
            stack.push(x->rChild);
        }
    }
    template <typename VST> void travIn_I1(BinNodePosi(T) x, VST& visit) {//二叉树先序遍历算法
        if (!x) {
            return;
        }
        Stack<BinNodePosi(T)> stack;
        stack.push(x);
        while (true) {
            if (stack.empty()) {
                break;
            }
            BinNodePosi(T) p = stack.top();
            while (HasLChild(p)) {
                stack.push(p->lChild);
                p = p->lChild;
            }
            visitAndPushLeft(visit, stack);
        }
    }
     */
    static void goAlongLeftBranch(BinNodePosi(T) x, Stack<BinNodePosi(T)>& stack) {
        while (x) {
            stack.push(x->lChild);
            x = x->lChild;
        }
    }
    template <typename VST> void travIn_I1(BinNodePosi(T) x, VST& visit) {
        Stack<BinNodePosi(T)> stack;
        while (true) {
            goAlongLeftBranch(x, stack);
            if (stack.empty()) {
                return;
            }
            x = stack.pop();
            visit(x->data);
            x = x->rChild;
        }
    }
    template <typename VST> void travIn_I2(BinNodePosi(T) x, VST& visit) {
        Stack<BinNodePosi(T)> stack;
        while (true) {
            if (x) {
                stack.push(x);//根节点进栈
                x = x->lChild; //深入遍历左子树
            } else if (!stack.empty()) {
                x = stack.pop();//尚未反问的最低祖先节点出栈
                visit(x->data);//访问该祖先节点
                x = x->rChild;//遍历祖先的右子树
            } else
                break;//遍历完成
        }
    }
    template <typename VST> void travIn_I3(BinNodePosi(T) x, VST& visit) {
        bool backtrack = false;
        while (true) {
            if (!backtrack && HasLChild(*x)) {
                x = x->lChild;
            } else {
                visit(x->data);
                if (HasRChild(*x)) {
                    x = x->rChild;
                    backtrack = false;
                } else {
                    if (!(x = x->succ())) {
                        break;
                    }
                    backtrack = true;
                }
            }
        }
    }
    //在以S栈顶节点为根的子树中，找到最高左侧可见叶子节点
    static void gotoHLVFL(Stack<BinNodePosi(T)>& S) {//沿途所遇节点依次入栈
        while (BinNodePosi(T) x = S.top()) {//自顶而下，反复检查当前节点，即栈顶节点
            if (HasLChild(*x)) {//尽可能向右
                if (HasRChild(*x)) {//若有右子节点
                    S.push(x->rChild);//优先入栈
                }
                S.push(x->lChild);//然后才转至左子节点
            } else {//实不得已
                S.push(x->rChild);//才向右
            }
        }
        S.pop();//返回前，弹出栈顶的空节点
    }
    template <typename VST> void travPost_I(BinNodePosi(T) x, VST& visit) {
        Stack<BinNodePosi(T)> S;
        if (x) {
            S.push(x);//根节点入栈
        }
        while (!S.empty()) {
            if (S.top() != x->parent) {//若栈顶非当前节点之父（则必为其右兄）,此时需
                gotoHLVFL(S);//在以其右兄为根之子树中，找到HLVFL（相当于递归深入其中）
            }
            x = S.pop();//弹出栈顶(即前一节点之后继)，并访问之
            visit(x->data);
        }
    }
    template <typename VST> void travLevel(BinNodePosi(T) x, VST& visit) {
        Queue<BinNodePosi(T)> Q;
        Q.enqueue(x);
        while (!Q.empty()) {
            BinNodePosi(T) x = Q.dequeue();
            visit(x->data);
            if (HasLChild(x)) {
                Q.enqueue(x->lChild);
            }
            if (HasRChild(x)) {
                Q.enqueue(x->rChild);
            }
        }
    }
//比较器、判等器
    bool operator<(BinNode const& bn) {
        return data < bn.data;
    }
    bool operator==(BinNode const& bn) {
        return data == bn.data;
    }
    
};

// BinNode状态与性质的判断

#define IsRoot(x) (!((x).parent))
#define IsLChild(x) (!IsRoot(x) && (&(x) == (x).parent->lChild))
#define IsRChild(x) (!IsRoot(x) && (&(x) == (x).parent->rChild))
#define HasParent(x) (!IsRoot(x))
#define HasLChild(x) ((x).lChild)
#define HasRChild(x) ((x).rChild)
#define HasChild(x) (HasLChild(x) || HasRChild(x))
#define HasBothChild(x) (HasLChild(x) && HasRChild(x))
#define HasLeaf(x) (!HasChild(x))

// 与BinNode具有特定关系的节点及指针

#define sibling(p) ( \
    IsLChild(*(p)) ? \
        (p)->parent->rChild : \
        (p)->parent->rChild \
)//兄弟

#define uncle(x) ( \
    IsLChild(*((x)->parent)) ? \
        (x)->parent->parent->rChild : \
        (x)->parent->parent->lChild \
)//叔叔

#define FromParentTo(x) ( \
    IsRoot(x) ? this->_root : ( \
    IsLChild(x) ? (x).parent->lChild : (x).parent->rChild \
    ) \
)//来自父亲的指针

#endif /* BinNode_hpp */
