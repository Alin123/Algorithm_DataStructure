//
//  SingleFactory.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "SingleFactory.hpp"

Fruit::~Fruit() {
    printf("\n");
}

bool Fruit::getIsDelicious() {
    return this->isDelicious;
}

Apple::Apple() {
    printf("创建苹果！\n");
    this->isDelicious = true;
}

Apple::~Apple() {
    printf("销毁苹果！\n");
}

void Apple::plant() {
    printf("种植苹果！\n");
}

void Apple::grow() {
    printf("苹果正在生长！\n");
}

void Apple::harvest() {
    printf("苹果收获啦！\n");
}

Grape::Grape() {
    printf("创建葡萄！\n");
    this->isDelicious = false;
}

Grape::~Grape() {
    printf("销毁葡萄！\n");
}

void Grape::plant() {
    printf("种植葡萄！\n");
}

void Grape::grow() {
    printf("葡萄正在生长！\n");
}

void Grape::harvest() {
    printf("葡萄收获啦！\n");
}


Gardener::Gardener() {
    this->apple = NULL;
    this->grape = NULL;
}

Gardener::~Gardener() {
    if (this->apple) {
        delete this->apple;
        this->apple = NULL;
    }
    if (this->grape) {
        delete this->grape;
        this->grape = NULL;
    }
}

Fruit *Gardener::getFruit(int type) {
    Fruit *fruit = NULL;
    if (type == APPLE) {
        if (this->apple == NULL) {
            this->apple = new Apple();
        }
        fruit = this->apple;
    } else if (type == GRAPE) {
        if (this->grape == NULL) {
            this->grape = new Grape();
        }
        fruit = this->grape;
    }
    return fruit;
}
