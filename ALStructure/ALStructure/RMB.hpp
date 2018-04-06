//
//  RMB.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef RMB_hpp
#define RMB_hpp

#include <stdio.h>

class RMB {
public:
    
    RMB(int yuan, int jf);
    
    void printRMB();
    
    RMB operator+(const RMB&);                    //通过成员函数重载+运算符，相当于第一个参数变成了发起+运算对象自身
    friend bool operator>(const RMB&, const RMB&);//通过友元函数重载>运算符
    
    RMB& operator++();                            //前增量
    RMB operator++(int);                          //后增量int仅用于区分，语法格式
    
    
private:
    unsigned int yuan;
    unsigned int jf;
};

#endif /* RMB_hpp */
