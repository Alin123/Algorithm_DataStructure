//
//  Dictionary.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/28.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Dictionary_hpp
#define Dictionary_hpp

#include <stdio.h>

template <typename K, typename V>
class Dictionary {
public:
    /**
     * 当前词条总数
     */
    virtual int size() {
        return 0;
    };
    /**
     * 插入词条（禁止雷同此条时可能失败）
     */
    virtual bool put(K, V) {
        return false;
    };
    /**
     * 读取词条
     */
    virtual V* get(K) {
        return NULL;
    };
    /**
     * 删除词条
     */
    virtual bool remove() {
        return false;
    };
};

#endif /* Dictionary_hpp */
