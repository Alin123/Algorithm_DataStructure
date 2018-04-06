//
//  AVLTree.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/27.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef AVLTree_hpp
#define AVLTree_hpp

#include <stdio.h>
#include "BinSearchTree.hpp"
#include "BinTree.hpp"

/**
 * 平衡因子（任一节点的左右子树高度差）不超过1的二叉搜索树
 */
template <typename T>
class AVL: public BST<T> {//由BST派生AVL树模版
public:
    /**
     * 重写了父类二叉搜索树的插入方法，在插入操作中添加了控制BST平衡的操作
     */
    BinNodePosi(T) insert(const T& e) {//将关键码e插入AVL树中
        BinNodePosi(T)& x = BST<T>::search(e);
        if (x) {
            return x;//确定目标e不存在（留意对_hot的设置）
        }
        x = new BinNode<T>(e, BST<T>::_hot);//创建节点x（此后，其父_hot可能增高，祖父可能失衡）
        BST<T>::_size++;
        for (BinNodePosi(T) g = BST<T>::_hot; g; g = g->parent) {//从x之父出发向上，逐层检查各代祖先g
            if (!AvlBalanced(*g)) {//一旦发现g失衡，则（采用“3+4”算法）使之复衡
                FromParentTo(*g) = BST<T>::rotateAt(tallerChild(tallerChild(g)));//将该子树联至原父亲
                break;//g复衡后，局部子树高度必然复原；其祖先亦必如此，顾调整随即结束
            } else {//否者（g依然平衡），只需简单地
                BST<T>::updateHeightAbove(g);//更新其高度（注意：即便g威失衡，高度亦可能增加）
            }
        }//至多只需一次调整；若果真做过调整，则全树高度必然复原
        return x;//返回新节点
    }//无论e是否存在于原树中，返回时总有x->data == e
    /**
     * 重写了父类二叉搜索树的删除方法，在删除操作中也添加了控制BST平衡的操作
     */
    bool remove(const T& e) {//从AVL树中删除关键码e
        BinNodePosi(T)& x = BST<T>::search(e);
        if (!x) return false;//确认目标节点存在（留意对_hot的设置）
        BST<T>::removeAt(x, BST<T>::_hot); BST<T>::_size--;//先按BST规则删除之（此后，原节点之父_hot及其祖先均有可能失衡）
        for (BinNodePosi(T) g = BST<T>::_hot; g; g->parent) {//从_hot出发向上，逐层检查各代祖先g
            if (!AvlBalanced(*g)) {//一旦发现g失衡，则（采用“3+4”算法）使之复衡
                g = FromParentTo(*g) = BST<T>::rotateAt(tallerChild(tallerChild(g)));//将孩子树联至原父亲
            }
            BST<T>::updateHeightAbove(g);//并更新高度（注意：即便g未失衡，高度亦可能降低）
        }//可能需做Omega(logn)次调整--无论是否做过调整，全树高度均可能降低
        return true;//删除成功
    }//若目标节点存在且被删除，返回true；否者返回false
};

#define Balanced(x) (stature((x).lChild) == stature((x).rChild)) //理想平衡条件
#define BalFac(x) (stature((x).lChild) - stature((x).rChild))    //平衡因子
#define AvlBalanced(x) ((-2 < BalFac(x)) && (BalFac(x) < 2))     //AVL平衡条件

#define tallerChild(x) ( \
    stature((x).lChild) > stature((x).rChild) ? (x).lChild : ( \
    stature((x).rChild) > stature((x).lChild) ? (x).rChild : ( \
    IsLChild(*(x)) ? (x)->lChild : (x)->rChild \
    )\
    )\
)

#endif /* AVLTree_hpp */
