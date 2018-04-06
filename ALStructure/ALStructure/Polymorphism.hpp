//
//  Polymorphism.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef Polymorphism_hpp
#define Polymorphism_hpp

#include <stdio.h>

class Intellectual {
public:
    void study();
    virtual void working();
    virtual ~Intellectual();
};

class Teacher: public Intellectual {
public:
    void study();
    virtual void working();
    virtual ~Teacher();
};

class Stu: public Intellectual {
public:
    void study();
    virtual void working();
    virtual ~Stu();
};

#pragma mark -- pure virtual class

class Shape {
public:
    Shape(double x, double y);
    virtual ~Shape();
    virtual double getArea() = 0;
protected:
    double x;
    double y;
};

class Square: public Shape {
public:
    Square(double x, double y):Shape(x, y) {};
    virtual ~Square();
    virtual double getArea();
};

class Circle: public Shape {
public:
    Circle(double x, double y):Shape(x, y) {};
    virtual ~Circle();
    virtual double getArea();
};

#endif /* Polymorphism_hpp */
