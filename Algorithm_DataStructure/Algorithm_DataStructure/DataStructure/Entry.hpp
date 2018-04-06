//
//  Entry.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/28.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Entry_hpp
#define Entry_hpp

#include <stdio.h>

template <typename K, typename V>
struct Entry { //词条模版类
//成员
    K key;     //关键码
    V value;   //数组
    
//构造
    Entry(K k, V v): key(k), value(v) {}                       //默认构造函数
    Entry(Entry<K, V> const& e): key(e.key), value(e.value) {} //基于克隆的构造函数
    
//运算符重载
    bool operator==(Entry<K, V> const& e) {
        return key == e.key;
    }
    bool operator!=(Entry<K, V> const& e) {
        return key != e.key;
    }
};


#endif /* Entry_hpp */

