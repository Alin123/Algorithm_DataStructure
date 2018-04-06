//
//  RMB.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "RMB.hpp"


RMB::RMB(int yuan, int jf) {
    this->yuan = yuan;
    (*this).jf = jf;
}

void RMB::printRMB() {
    printf("¥%d:%d\n", yuan, jf);
}

RMB RMB::operator+(const RMB& another) {
    int rYuan = this->yuan + another.yuan;
    int rJf = this->jf + another.jf;
    
    if (rJf >= 100) {
        rJf -= 100;
        rYuan += 1;
    }
    return RMB(rYuan, rJf);
}

bool operator>(const RMB& one, const RMB& another) {
    if (one.yuan > another.yuan) {
        return true;
    } else {
        if (one.yuan == another.yuan && one.jf > another.jf) {
            return true;
        }
        return false;
    }
}

RMB& RMB::operator++() {
    this->yuan += 1;
    return *this;
}

RMB RMB::operator++(int) {
    RMB origin(this->yuan, this->jf);
    this->yuan += 1;
    
    return origin;
}
