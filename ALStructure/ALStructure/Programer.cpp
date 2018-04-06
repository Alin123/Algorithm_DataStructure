//
//  Programer.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/13.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "Programer.hpp"

std::string Programer::jobDuty = "Coding!";

void Programer::study() {
    printf("为中华民族之崛起而读书！");
}

void Programer::setProperty(int age) {
    this->age = age;
}

void globalFriendMentod(Programer *p, int age) {
    p->age = age;
}

Programer::Programer() {
    printf("由默认构造函数创建！");
    this->age = 0;
    memset(this->name, 0, 20);
    this->hobby = NULL;
}

Programer::Programer(int age) {
    printf("由指定构造函数创建！");
    this->age = age;
    memset(this->name, 0, 20);
    this->hobby = NULL;
}

Programer::~Programer() {
    printf("由析构函数销毁！");
    if (hobby) {
        delete[] hobby;
        hobby = NULL;
    }
}

//拷贝构造函数
Programer::Programer(const Programer& programer) {
    printf("由拷贝构造函数创建！");
    
    age = programer.age;
    memset(name, 0, 20);
    memcpy(name, programer.name, 20);
    
    if (programer.hobby != NULL) {
        unsigned long length = strlen(programer.hobby)  + 1;
        hobby = new char[length];
        memset(hobby, 0, length);
        strcpy(hobby, programer.hobby);
    } else {
        hobby = NULL;
    }
}

Programer& Programer::operator=(const Programer &other) {
    if (&other == this) {
        return *this;
    }
    age = other.age;
    memset(name, 0, 20);
    memcpy(name, other.name, 20);
    
    if (hobby != NULL) {
        delete[] hobby;
        hobby = NULL;
    }
    
    if (other.hobby != NULL) {
        unsigned long length = strlen(other.hobby) + 1;
        hobby = new char[length];
        memset(hobby, 0, length);
        strcpy(hobby, other.hobby);
    }
    
    printf("根据赋值运算符创建！");
    return *this;
}
