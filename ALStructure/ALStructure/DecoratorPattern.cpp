//
//  DecoratorPattern.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/21.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "DecoratorPattern.hpp"

Hero::~Hero() {
    
}


BlindMonk::BlindMonk(std::string name) {
    this->name = name;
}

void BlindMonk::learnSkills() {
    std::cout << this->name + "学习了以上技能！\n";
}


Skills::Skills(Hero *p) {
    this->pHero = p;
}

Skills::~Skills() {
    if (pHero) {
        delete this->pHero;
        pHero = NULL;
    }
}

void Skills::learnSkills() {
    pHero->learnSkills();
}

Skill_Q::Skill_Q(Hero *p, std::string name): Skills(p) {
    this->skillName = name;
}

void Skill_Q::learnSkills() {
    std::cout << "学习了技能Q:" + skillName + "\n";
    Skills::learnSkills();
}

Skill_W::Skill_W(Hero *p, std::string name): Skills(p) {
    this->skillName = name;
}

void Skill_W::learnSkills() {
    std::cout << "学习了技能W:" + skillName + "\n";
    Skills::learnSkills();
}
