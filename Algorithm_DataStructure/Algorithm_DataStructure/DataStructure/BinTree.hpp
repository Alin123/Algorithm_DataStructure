//
//  BinTree.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/22.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef BinTree_hpp
#define BinTree_hpp

#include <stdio.h>
#include "BinNode.hpp"
#include <math.h>

template <typename T>
class BinTree {
protected:
//成员变量
    int _size; //规模
    BinNodePosi(T) _root;
//成员函数
    virtual int updateHeight(BinNodePosi(T) x) { //更新节点x的高度
        return x->height = 1 + fmax(stature(x->lChild), stature(x->rChild));//具体规则因树不同而异
    }
    void updateHeightAbove(BinNodePosi(T) x) {   //更新节点x及其祖先的高度
        while (x) {//可优化，一旦高度未变，即可终止
            updateHeight(x);
            x = x->parent;
        }
    }
public:
    BinTree(): _size(0), _root(NULL) {} //构造函数
    ~BinTree() {                        //析构函数
        if (0 < _size) {
            remove(_root);
        }
    }
    int& size() { //规模
        return _size;
    }
    bool empty() const { //判空
        return !_root;
    }
    BinNodePosi(T)& root() { //树根
        return _root;
    }
    BinNodePosi(T) insertAsRoot(T const& e) { //插入根节点
        _size = 1;
        _root = new BinNode<T>(e, NULL);
        return _root;
    }
    BinNodePosi(T) insertAsLC(BinNodePosi(T) x, T const& e) { //e作为左孩子(原无)插入
        _size += 1;
        x->insertAsLC(e);
        updateHeightAbove(x);
        return x->lChild;
    }
    BinNodePosi(T) insertAsRC(BinNodePosi(T) x, T const& e) { //e作为右孩子(原无)插入
        _size += 1;
        x->insertAsRC(e);
        updateHeightAbove(x);
        return x->rChild;
    }
    BinNodePosi(T) attachAsLC(BinNodePosi(T) x, BinTree<T>* &tree) { //tree作为x的左子树接入
        x->lChild = tree->_root;
        tree->_root->parent = x;
        _size += tree->_size;
        updateHeightAbove(x);
        tree->_root = NULL;
        tree->_size = 0;
        release(tree);
        tree = NULL;
        return x;
    }
    BinNodePosi(T) attachAsRC(BinNodePosi(T) x, BinTree<T>* &tree) { //tree作为x的右子树接入
        x->rChild = tree->_root;
        tree->_root->parent = x;//接入
        _size += tree->_size;
        updateHeightAbove(x);   //更新全树规模与x所有祖先的高度
        tree->_root = NULL;
        tree->_size = 0;
        release(tree);
        tree = NULL;
        return x;
    }
    
    int remove(BinNodePosi(T) x) { //删除以位置x为根节点的子树，返回该子树的原始规模
        FromParentTo(*x) = NULL;   //切断来自父节点的指针
        updateHeightAbove(x->parent); //更新祖先节点
        int n = removeAt(x);          //删除子树x，更新规模，返回删除节点总数
        _size -= n;
        return n;
    }
    static int removeAt(BinNodePosi(T) x) {//删除二叉树中位置x处的节点及其后代，放回被删除节点的数目
        if (!x) {//递过基，空树
            return 0;
        }
        int n = 1 + removeAt(x->lChild) + removeAt(x->rChild); //递归释放左右子树
        release(x->data); //释放被摘除的节点，并返回节点总数
        release(x);
        return n;
    }
    BinTree<T>* secede(BinNodePosi(T) x) { // 将子树x从当前树中摘除，并将其转化为一颗独立树
        FromParentTo(*x) = NULL;//切断来自父节点的指针
        updateHeightAbove(x->parent);// 更新原树中所有祖先的高度
        BinTree<T>* S = new BinTree<T>;//新树以x为根
        S->_root = x;
        x->parent = NULL;
        S->_size = x->size();//更新规模
        _size -= S->_size;
        return S;
    }
    template <typename VST> void travLevel(VST& vist) {//层次遍历
        if (_root) {
            _root->travLevel(vist);
        }
    }
    template <typename VST> void travPre(VST& vist) {//先序遍历
        if (_root) {
            _root->travPre(vist);
        }
    }
    template <typename VST> void travIn(VST& vist) {//中序遍历
        if (_root) {
            _root->travIn(vist);
        }
    }
    template <typename VST> void travPost(VST& vist) {//后续遍历
        if (_root) {
            _root->travPost(vist);
        }
    }
    bool operator<(BinTree<T> const& t) {//比较根节点的数据是否是小于关系
        return _root && t._root && (_root->data < t._root->data);
    }
    bool operator==(BinTree<T> const& t) {//比较根节点是否是同一节点
        return _root && t._root && (_root == t._root);
    }
};

#endif /* BinTree_hpp */
