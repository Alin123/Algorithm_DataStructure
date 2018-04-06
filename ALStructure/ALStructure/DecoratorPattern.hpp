//
//  DecoratorPattern.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/21.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef DecoratorPattern_hpp
#define DecoratorPattern_hpp

#include <stdio.h>
#include <string>
#include <iostream>

class Hero {
public:
    virtual ~Hero();
    virtual void learnSkills() = 0;
};

class BlindMonk : public Hero {//盲僧
public:
    BlindMonk(std::string);
    void learnSkills();
private:
    std::string name;
};

class Skills : public Hero {
public:
    Skills(Hero *);
    ~Skills();
    void learnSkills();
private:
    Hero *pHero;
};

class Skill_Q : public Skills {
public:
    Skill_Q(Hero *, std::string);
    void learnSkills();
private:
    std::string skillName;
};

class Skill_W : public Skills {
public:
    Skill_W(Hero *, std::string);
    void learnSkills();
private:
    std::string skillName;
};

#endif /* DecoratorPattern_hpp */
