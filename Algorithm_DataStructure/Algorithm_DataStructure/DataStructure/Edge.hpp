//
//  Edge.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/24.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Edge_hpp
#define Edge_hpp

#include <stdio.h>

typedef enum {
    UNDETERMINED,//undetermined 不确定的
    TREE,        //tree
    CROSS,       //cross：交叉的、相反的
    FORWARD,     //forward：向前的
    BACKWARD     //backward：向后的
}EStatus;

template <typename Te>
struct Edge {
    Te data;//数据
    int weight;//权重
    EStatus status;//状态
    
    Edge(Te const& e, int w): data(e), weight(e), status(UNDETERMINED) {}//构造新边
};

#endif /* Edge_hpp */
