//
//  Strategy.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/18.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "Strategy.hpp"

Duck::Duck(FlyBehavior *fb, QuackBehavior *qb) {
    flyBehavior = fb;
    quackBehavior = qb;
}

Duck::~Duck() {
    if (flyBehavior) {
        delete flyBehavior;
        flyBehavior = NULL;
    }
    if (quackBehavior) {
        delete quackBehavior;
        quackBehavior = NULL;
    }
}

void Duck::setFlyBehavior(FlyBehavior *fb) {
    flyBehavior = fb;
}

void Duck::setQuackBehavior(QuackBehavior *qb) {
    quackBehavior = qb;
}

void Duck::performFly() const {
    flyBehavior->fly();
}

void Duck::performQuack() const {
    quackBehavior->quack();
}

void Duck::swim() const {
    printf("All duck can swim!\n");
}

#pragma mark - FlyBehavior

FlyBehavior::~FlyBehavior() {
    
}
#pragma mark - QuackBehavior
QuackBehavior::~QuackBehavior() {
    
}

#pragma mark - subclass of FlyBehavior
void FlyRocketPowered::fly() const {
    printf("I'm flying with a rocket!\n");
}

void FlyWithWings::fly() const {
    printf("I'm flying!\n");
}

void FlyNoWay::fly() const {
    printf("I can't fly!\n");
}

#pragma mark - subclass of QuackBehavior

void Quack::quack() const {
    printf("Quack!\n");
}

void Squeak::quack() const {
    printf("Squeak!\n");
}

void MuteQuack::quack() const {
    printf("I can't quack!\n");
}

#pragma mark -

MallardDuck::MallardDuck():Duck(new FlyWithWings(), new Quack()) {
    
}

void MallardDuck::display() const {
    printf("I'm a real mallard duck!\n");
}


DecoyDuck::DecoyDuck():Duck(new FlyNoWay(), new MuteQuack()) {
    
}

void DecoyDuck::display() const {
    printf("I'm a decoy duck!\n");
}
