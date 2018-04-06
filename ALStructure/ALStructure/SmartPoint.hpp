//
//  SmartPoint.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef SmartPoint_hpp
#define SmartPoint_hpp

#include <stdio.h>

template <typename T>
class SmartPtr {
public:
    SmartPtr(T *p_):p(p_) {
        
    }
private:
    T *p;
};


#endif /* SmartPoint_hpp */
