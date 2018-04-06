//
//  SingleFactory.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef SingleFactory_hpp
#define SingleFactory_hpp

#include <stdio.h>

class Fruit {//策略，处理需求的行为的抽象
public:
    virtual ~Fruit();
    virtual void plant() = 0;
    virtual void grow() = 0;
    virtual void harvest() = 0;
    
    bool getIsDelicious();
protected:
    bool isDelicious;
};

class Apple: public Fruit {//策略一，具体的行为（算法）
public:
    Apple();
    ~Apple();
    
    void plant();
    void grow();
    void harvest();
};

class Grape: public Fruit {//策略二，具体的行为（算法）
public:
    Grape();
    ~Grape();
    
    void plant();
    void grow();
    void harvest();
};

enum {
    APPLE = 0,
    GRAPE = 1
};

class Gardener {//工厂，根据需求产出不同的对象去处理～
public:
    Gardener();
    ~Gardener();
    
    Fruit *getFruit(int);
    
private:
    Apple *apple;
    Grape *grape;
};



#endif /* SingleFactory_hpp */
