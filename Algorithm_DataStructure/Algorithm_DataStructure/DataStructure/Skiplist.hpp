//
//  Skiplist.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/29.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Skiplist_hpp
#define Skiplist_hpp

#include <stdio.h>
#include "Dictionary.hpp"
#include "List.hpp"
#include "Quadlist.hpp"

template <typename K, typename V>
class Skiplist: public Dictionary<K, V>, public List<Quadlist<Entry<K, V>*>*> {
protected:
    /**
     * Skiplist词条中查找算法（供内部调用）
     * 入口：qlist为顶层列表，p为qlist第一个数据节点（若qlist的size为0，那么p为尾节点）
     * 出口：若成功，p为命中关键码所属塔的顶部节点，qlist为p所属列表
            否则，p为所属塔的基座，该塔对应于不大于k的最大且最右关键码，qlist为空
     * 约定：多个词条名中时，沿四联表取最靠后者
     */
    bool skipSearch(ListNode<Quadlist<Entry<K, V>*>*>* &qlist, QuadlistNode<Entry<K, V>*>* &p, K& k) {
        while (true) {//在每一层
            //从前往后查找，p->succ == NULL证明p是尾节点，p->succ证明p不是尾节点，<=保证了命中的是最靠后者
            while (p->succ && p->entry->k <= k) {//循环退出的条件：1p已经到了尾节点，2找到了第一个关键码大于k的塔
                p = p->succ;
            }
            p = p->pred;//此时倒回一步，即可判断是否***巧妙的设计***
            if (p->pred && p->entry->k == k) {//p为非头节点，且k一致，命中
                return true;
            }
            qlist = qlist->succ;
            if (!qlist->succ) {//若以已到穿透底层，则意味着失败，
                return false;//qlist此时为List<Quadlist<T>*>的尾节点
            }
            //倒退一步有可能倒退到头节点Quadlist::header，所以不能直接取p->below
            p = (p->pred) ? p->below : (qlist->data->first());//转入
        }
    }
    
public:
    int size() {//词条总数，即底层Quadlist的规模
        return List<Quadlist<Entry<K, V>*>*>::empty() ? 0 : List<Quadlist<Entry<K, V>*>*>::last()->data->size();
    }
    int level() {//层高 == #Quadlist，不一定要开放
        return List<Quadlist<Entry<K, V>*>*>::size();
    }
    bool put(K k, V v){//插入（注意域Map有别--Skiplis允许词条重复，故必然成功）
        Entry<K, V>* e = new Entry<K, V>(k, v);
        if (List<Quadlist<Entry<K, V>*>*>::empty()) {//如果为空的话
            List<Quadlist<Entry<K, V>*>*>::insertAsFirst(new Quadlist<Entry<K, V>*>);//创建一层
        }
        ListNode<Quadlist<Entry<K, V>*>*>* qlist = List<Quadlist<Entry<K, V>*>*>::first();//从顶层的
        QuadlistNode<Entry<K, V>*>* p = qlist->data->first();//第一个数据节点开始啊查找
        if (skipSearch(qlist, p, k)) {//查找适当的位置：最后一个不大k的塔的基座元素
            while (p->below) {
                p = p->below;//若已有雷同词条，则需强制转到塔底
            }
        }
        qlist = List<Quadlist<Entry<K, V>*>*>::last();//以下，紧邻p的右侧，一座新塔将自底而上逐层生长
        QuadlistNode<Entry<K, V>*>* b = qlist->data->insertAfterAbove(e, p, NULL);//将e插入p右侧（作为新塔的基座）
        while (rand() % 2) {
            while (qlist->data->valid(p) && !p->above) {
                p = p->pred;// 找出不低于此高度的最近前驱
            }//循环退出的条件：1、p已经到达了Quadlist的头节点；2、p->above!=NULL，p的上面有元素了
            if (!qlist->data->valid(p)) {//若该前驱是header，情形一
                if (qlist == List<Quadlist<Entry<K, V>*>*>::first()) {//且当前已是最顶层，则意味着必须
                    List<Quadlist<Entry<K, V>*>*>::insertAsFirst(new Quadlist<Entry<K, V>*>);//首先创建新的一层，然后
                }
                p = qlist->pred->data->first()->pred;//将p转至上一层Skiplist的header
            } else {//否则，可迳自
                p = p->above;//将p提升至该高度
            }
            qlist = qlist->pred;//上升一层，并在该层
            b = qlist->data->insertAfterAbove(e, p, b);//将新节点插入p之后、b之上
        }
        return true;//Dictionary允许重复元素，故插入必成功，这与Hashtable等Map略有不同
    }
    V* get(K k) {//读取
        if (List<Quadlist<Entry<K, V>*>*>::empty()) return NULL;
        ListNode<Quadlist<Entry<K, V>*>*>* qlist = List<Quadlist<Entry<K, V>*>*>::first();
        QuadlistNode<Entry<K, V>*>* p = qlist->data->first();
        return skipSearch(qlist, p, k) ? &(p->entry->value) : NULL;
    }
    bool remove(K k) {//删除
        if (List<Quadlist<Entry<K, V>*>*>::empty()) return false;//空表的情况直接退出
        ListNode<Quadlist<Entry<K, V>*>*> qlist = List<Quadlist<Entry<K, V>*>*>::first(); //从顶层
        QuadlistNode<Entry<K, V>*>* p = qlist->data->first();//首节点开始
        if (!skipSearch(qlist, p, k)) return false;//目标节点不存在，直接返回
        do {//若目标词条存在，则逐层拆除与之对应的塔
            QuadlistNode<Entry<K, V>*>* lower = p->below;//记住下层的节点
            qlist->data->remove(p);//删除当前层节点
            p = lower; qlist = qlist->succ;//转入下层
        } while (qlist->succ);//直到塔基
        while (List<Quadlist<Entry<K, V>*>*>::empty() && List<Quadlist<Entry<K, V>*>*>::first()->data->empty()) {//反复
            List<Quadlist<Entry<K, V>*>*>::remove(List<Quadlist<Entry<K, V>*>*>::first());//清除已不含词条的层Quadlist
        }
        return true;
    }
};


#endif /* Skiplist_hpp */
