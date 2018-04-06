//
//  ConversionOfNumberSystems.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/20.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef ConversionOfNumberSystems_hpp
#define ConversionOfNumberSystems_hpp

#include <stdio.h>
#include "Stack.hpp"

void convert_recursion(Stack<char>& s, int n, int base);
void convert_iteration(Stack<char>& s, int n, int base);

#endif /* ConversionOfNumberSystems_hpp */
