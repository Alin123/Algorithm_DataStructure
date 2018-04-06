//
//  Programer.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/13.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef Programer_hpp
#define Programer_hpp

#include <stdio.h>
#include <iostream>
#include <string>

class Programer {
public:
    Programer();
    Programer(int age);
    ~Programer();
    Programer(const Programer& programer);
    Programer& operator=(const Programer& other);
    void study();
    void setProperty(int age);
    
    friend void globalFriendMentod(Programer *, int age);
    
private:
    int age;
    char name[20];
    char *hobby;
    static std::string jobDuty;
};

#endif /* Programer_hpp */
