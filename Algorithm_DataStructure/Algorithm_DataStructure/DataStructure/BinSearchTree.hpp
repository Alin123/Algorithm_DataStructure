//
//  BinSearchTree.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/27.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef BinSearchTree_hpp
#define BinSearchTree_hpp

#include <stdio.h>
#include "BinTree.hpp"

/**
 * 任一节点的左子树中的元素都不大于该节点的元素，右子树中的元素都不小于该节点的元素！Vl <= V <= Vr
 */
template <typename T>
class BST: public BinTree<T> {//由BinTree派生BST模版类
protected:
    BinNodePosi(T) _hot;//BST::search()最后访问的非空（除非树空）的节点位置
    BinNodePosi(T) connect34(//按照“3+4”结构联接3个顶点及4棵子树
        BinNodePosi(T) a, BinNodePosi(T) b, BinNodePosi(T) c,
        BinNodePosi(T) T0, BinNodePosi(T) T1, BinNodePosi(T) T2, BinNodePosi(T) T3) {
        a->lChild = T0; if (T0) T0->parent = a;
        a->rChild = T1; if (T1) T1->parent = a; BinTree<T>::updateHeight(a);
        c->lChild = T2; if (T2) T2->parent = c;
        c->rChild = T3; if (T3) T3->parent = c; BinTree<T>::updateHeight(c);
        b->lChild = a; a->parent = b;
        b->rChild = c; c->parent = b; BinTree<T>::updateHeight(b);
        return b;//该子树新的根节点
    }
    BinNodePosi(T) rotateAt(BinNodePosi(T) v) {//对x及其父亲、祖父做统一旋转调整
        BinNodePosi(T) p = v->parent; BinNodePosi(T) g = p->parent;//视v、p和g相对位置分四种情况
        if (IsLChild(*p)) { /* zig */
            if (IsLChild(*v)) { /* zig-zig */
                p->parent = g->parent;//向上联接
                return connect34(v, p, g, v->lChild, v->rChild, p->rChild, g->rChild);
            } else { /* zig-zag */
                v->parent = g->parent;//向上联接
                return connect34(p, v, g, p->lChild, v->lChild, v->rChild, g->rChild);
            }
        } else { /* zag */
            if (IsRChild(*v)) { /* zag-zag */
                p->parent = g->parent;//向上联接
                return connect34(g, p, v, g->lChild, p->lChild, v->lChild, v->rChild);
            } else {
                v->parent = g->parent;//向上联接
                return connect34(g, v, p, g->lChild, v->lChild, v->rChild, p->rChild);
            }
        }
    }
public:
    static BinNodePosi(T)& searchIn(BinNodePosi(T)& v, const T& e, BinNodePosi(T)& hot) {//在以v为根的（AVL、SPLAY、rbTree等）BST子树中查找关键码e
        if (!v || (v->data == e)) {//至此可确定成功或失败，或者
            return v;
        }
        hot = v;//先记录当前节点，然后再
        return searchIn((e < v->data) ? v->lChild : v->rChild, e, hot);//递归查找
    }//返回目标节点位置的引用，以便后续插入、删除操作；失败时返回NULL
    virtual BinNodePosi(T)& search(const T& e) {//在BST中查找关键码e
        return searchIn(BinTree<T>::_root, e, _hot = NULL);
    }
    virtual BinNodePosi(T) insert(const T& e) {//将关键码e插入BST中
        BinNodePosi(T)& x = search(e);
        if (x) {//确定目标节点不存在（留意对_hot的设置）
            return x;
        }
        x = new BinNode<T>(e, _hot);//创建新节点x：以e为关键码，以_hot为父，x为_hot左节点或右节点的引用，等于_hot->lChild = new BinNode<T>(e, _hot);
        BinTree<T>::_size++;// 更新全树规模
        BinTree<T>::updateHeightAbove(x);//更新x及其历代祖先的高度
        return x;
    }//无论e是否存在于原树中，返回时总有x->data == e
    /**
     * BST节点删除算法：删除位置v所指的节点（全局静态模版函数，适用于AVL、Splay、RedBlack等各种BST）
     * v通常由此前的查找确定，经确认非NULL后方调用本函数，故必删除成功
     * 与SearchIn不同，调用前不必将hot置空
     * 返回值指向实际被删除节点的替换者，hot指向实际被删除节点的父亲，二者都有可能为NULL
     */
    static BinNodePosi(T) removeAt(BinNodePosi(T)& v, BinNodePosi(T)& hot) {
        BinNodePosi(T) w = v;//实际被摘除的节点，初值同v
        BinNodePosi(T) succ = NULL;//实际被删除节点的替换者
        if (!HasLChild(*v)) {//若*v的左子树为空，则可
            succ = v = v->rChild;//直接将*v替换成其右子树
        } else if (!HasRChild(*v)) {//若右子树为空，则可
            succ = v = v->lChild;//直接将*v替换成其左子树
        } else {//若左右子树均存在，则选择v的直接后继作为实际被摘除的节点，为此需要
            w = w->succ();//在右子树中找到*v的直接后继*w
            swap(v->data, w->data);//交换*v和*w的数据元素，此时*w为将要被删除的节点，并且*w没有左子树
            BinNodePosi(T) u = w->parent;//要删除*w，先找到其父亲
            ((u == v) ? u->rChild : u->lChild) = succ = w->rChild;//隔离节点*w（若交换后要删除的*w是*v的右孩子那么将w->rChild赋给*v的右孩子，否者*w必是其父亲的左孩子，非如此其父亲将是*v的直接后继，那么将w->rChild赋给*w的父亲的左孩子，即替换掉*w在其父亲节点中的位置）
        }
        hot = w->parent;//记录实际被删除节点的父亲
        if (succ) {//将被删除节点的替换者与hot相连
            succ->parent = hot;//如果被删除点有后继，那么后继的父亲为原被删除点的父亲，也即hot
        }
        release(w->data);//释放被摘除的节点
        release(w);
        return succ;//返回接替者
    }
    virtual bool remove(const T& e) {
        BinNodePosi(T)& x = search(e);//_hot代表被删除（被操作点）节点的父亲
        if (!x) {
            return false;//确认目标节点存在（留意对_hot的设置）
        }
        removeAt(x, _hot);//实施删除
        BinTree<T>::_size --;
        BinTree<T>::updateHeightAbove(_hot);
        return true;
    }
};

#endif /* BinSearchTree_hpp */
