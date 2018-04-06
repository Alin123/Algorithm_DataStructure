//
//  PublishObserve.hpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/18.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef PublishObserve_hpp
#define PublishObserve_hpp

#include <stdio.h>
#include <list>

class Observer;
class Subject {
public:
    virtual ~Subject() = 0;
    virtual void registerObserver(Observer *) = 0;
    virtual void removeObserver(Observer  *) = 0;
    virtual void notifyObserver() const = 0;
};

class Observer {
public:
    virtual ~Observer() = 0;
    virtual void update(float, float, float) = 0;
};


class weaterData: public Subject {
public:
    weaterData();
    weaterData(float t, float h, float p);
    ~weaterData();
    
    void registerObserver(Observer *);
    void removeObserver(Observer  *);
    void notifyObserver() const;
    
    void measurementsChanged();
    void setMeasurements(float t, float h, float p);
    
private:
    float temperature;
    float humidity;
    float pressulre;
    
    std::list<Observer *> observers;
};

class CurrentCondition: public Observer {
public:
    CurrentCondition();
    ~CurrentCondition();
    
    void update(float t, float h, float p);
    void display();
    
private:
    float tem;
    float hum;
};

class ForecastCondition: public Observer {
public:
    ForecastCondition();
    ~ForecastCondition();
    
    void update(float t, float h, float p);
    void display();
    
private:
    float previousPressulre;
    float newPressulre;
};

#endif /* PublishObserve_hpp */
