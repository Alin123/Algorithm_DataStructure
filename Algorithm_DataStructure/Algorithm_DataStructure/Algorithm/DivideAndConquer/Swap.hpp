//
//  Swap.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/14.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Swap_hpp
#define Swap_hpp

#include <stdio.h>

template <typename T>
void swap(T& a, T& b) {
    T temp = a;
    a = b;
    b = temp;
}

#endif /* Swap_hpp */
