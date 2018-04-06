//
//  Strategy.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/18.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef Strategy_hpp
#define Strategy_hpp

#include <stdio.h>

class FlyBehavior;
class QuackBehavior;
class Duck {
public:
    void setFlyBehavior(FlyBehavior *fb);
    void setQuackBehavior(QuackBehavior *qb);
    void performFly() const;
    void performQuack() const;
    void swim() const;
    virtual void display() const = 0;
protected:
    Duck(FlyBehavior *, QuackBehavior *);
    virtual ~Duck();
private:
    FlyBehavior *flyBehavior;
    QuackBehavior *quackBehavior;
};

class FlyBehavior {//策略Strategy，
public:
    virtual ~FlyBehavior() = 0;
    virtual void fly() const = 0;
};

class QuackBehavior {
public:
    virtual ~QuackBehavior() = 0;
    virtual void quack() const = 0;
};

class FlyRocketPowered: public FlyBehavior {
    virtual void fly() const;
};

class FlyWithWings: public FlyBehavior {
    virtual void fly() const;
};

class FlyNoWay: public FlyBehavior {
    virtual void fly() const;
};

class Quack: public QuackBehavior {
    virtual void quack() const;
};

class Squeak: public QuackBehavior {
    virtual void quack() const;
};

class MuteQuack: public QuackBehavior {
    virtual void quack() const;
};

#pragma mark -

class MallardDuck: public Duck {//野鸭
public:
    MallardDuck();
    virtual void display() const;
};

class DecoyDuck: public Duck {//诱捕鸭
public:
    DecoyDuck();
    virtual void display() const;
};

#endif /* Strategy_hpp */
