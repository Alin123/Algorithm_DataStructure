//
//  Hashtable.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/30.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Hashtable_hpp
#define Hashtable_hpp

#include <stdio.h>
#include <string>

static bool isPrim(unsigned int x) { //判断一个数是不是素数
    for (int i = 2; i * i <= x; i++) {
        if (x % i == 0) {
            return false;
        }
    }
    return true;
}
static int primeNLT(int N) { //不小于N的最大素数
    int x = N;
    while (!isPrim(x)) {
        x++;
    }
    return x;
}

static size_t hashCode(char s[]) {
    int h = 0;
    for (size_t n = strlen(s), i = 0; i < n; i++) {
        h = (h << 5) | (h >> 27);
        h += (int)s[i];
    }
    return (size_t) h;
}
static size_t hashCode(int k) {
    return (size_t) k;
}
static size_t hashCode(char c) {
    return (size_t) c;
}
static size_t hashCode(long long i) {
    return (size_t) ((i >> 32) + (int)i);
}

#include "Dictionary.hpp"
#include "Entry.hpp"
#include "Bitmap.hpp"

#define EntryPoint Entry<K, V>*

template <typename K, typename V> class Hashtable: public Dictionary<K, V> {
    
private:
    EntryPoint* ht; //存放词条指针桶数组，EntryPoint ht[100]能存放100个词条指针的数组
    int M;          //桶数组容量
    int N;          //词条数量
    Bitmap* lazyRemoval; //懒惰删除标记
#define lazilyRemoved(x) (lazyRemoval->test(x))
#define markAsRemoved(x) (lazyRemoval->set(x))
    
protected:
    /// @brief 沿关键码k对应的查找链，找到词条匹配的桶
    /**
     * 沿关键码k对应的查找链，找到条目匹配的桶（供查找，删除条目时调用）
     * 返回时，或者查找命中，或者抵达查找链末端--无LazyMask标记的桶
     * 试探算法多种多样，可灵活选取；这里为线性试探
     */
    int probe4Hit(const K& k) {
        int r = hashCode(k) % M; //采用除余法确定首个试探的桶单元地址
        while (true) {
            if (ht[r] && ht[r]->key == k) {//命中
                break;
            }
            if (!ht[r] && !lazilyRemoved(r)) {//空桶且没有（懒惰删除）的标记，证明查找链已经结束
                break;
            }
            r = (r + 1) % M;
        }
        return r;
    }
    /// @brief 沿关键码k对应的查找链，找到首个可用的空桶
    /**
     * 沿关键码k对应的查找链，找到条目匹配的桶（仅供插入条目时调用）
     * 返回时找到第一个空桶，无论是否有（懒惰删除）的标记
     */
    int probe4Free(const K& k) {
        int r = hashCode(k) % M; //采用除余法确定首个试探的桶单元地址
        while (ht[r]) {
            r = (r + 1) % M;
        }
        return r;
    }
    /// @brief 重散列算法：扩充桶数组，保证装填因子在警戒线以下
    void rehash() {
        int old_capacity = M; EntryPoint* old_ht = ht;
        M = primeNLT(M * 2); N = 0;
        ht = new EntryPoint[M]; memset(ht, 0, sizeof(EntryPoint) * M);
        delete lazyRemoval; lazyRemoval = new Bitmap(M);
        for (int i = 0; i < old_capacity; i ++) {
            if (old_ht[i]) {
                put(old_ht[i]->key, old_ht[i]->value);
            }
        }
        for (int i = 0; i < old_capacity; i++) {
            if (old_ht[i]) {
                delete old_ht[i];
            }
        }
        delete old_ht;
    }
    
public:
    /// @brief 创建一个容器不小于c的散列表（为测试暂时选用较小的默认值）
    Hashtable(int c = 5) {
        M = primeNLT(c);                   //以不小于c的素数为容量
        N = 0;                             //词条初始规模为0
        ht = new EntryPoint[M];            //开辟同数组，保证填充因子不操过50%
        memset(ht, 0, sizeof(EntryPoint) * M); //初始化其中的值
        lazyRemoval = new Bitmap(M);       //懒惰删除标记比特图
    }
    /// @brief 释放桶数组及其中各（非空）元素所指向的词条
    ~Hashtable() {
        for (int i = 0; i < M; i++) {
            if (ht[i]) {
                release(ht[i]);
            }
        }
        release(ht);
        release(lazyRemoval);
    }
    /// @brief 当前的词条数目
    virtual int size() {
        return N;
    }
    /// @brief 插入（禁止雷同词条，故可能失败）
    virtual bool put(K k, V v) {
        if (ht[probe4Hit(k)]) {
            return false;
        }
        ht[probe4Free(k)] = new Entry<K, V>(k, v);
        N += 1;
        if (N * 2 > M) {
            rehash();
        }
        return true;
    }
    /// @brief 读取
    virtual V* get(K k) {
        int r = probe4Hit(k);
        return ht[r] ? &(ht[r]->value) : NULL;
    }
    /// @brief 删除
    virtual bool remove(K k) {
        int r = probe4Hit(k);
        if (!ht[r]) {
            return false;
        }
        delete ht[r];
        ht[r] = NULL;
        if (ht[(r + 1) % M]) {
            markAsRemoved(r);
        }
        N -= 1;
        return true;
    }
    void traverse(void (*visit)(V*)) {
        for (int i = 0; i < M; i ++) {
            EntryPoint p = ht[i];
            if (p) {
                visit(&(p->value));
            } else {
                visit(NULL);
            }
        }
    }
};

#endif /* Hashtable_hpp */
