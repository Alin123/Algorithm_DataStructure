//
//  PublishObserve.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/12/18.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "PublishObserve.hpp"

Subject::~Subject() {
    printf("");
}

Observer::~Observer() {
    printf("");
}

weaterData::weaterData() {
    temperature = 0.0;
    humidity = 0.0;
    pressulre = 0.0;
}

weaterData::weaterData(float t, float h, float p) {
    temperature = t;
    humidity = h;
    pressulre = p;
}

weaterData::~weaterData() {
    printf("");
}

void weaterData::registerObserver(Observer *o) {
    if (!o) {
        return;
    }
    observers.push_back(o);
}

void weaterData::removeObserver(Observer *o) {
    if (!o) {
        return;
    }
    observers.remove(o);
}

void weaterData::notifyObserver() const {
    for (std::list<Observer *>::const_iterator it = observers.begin(); it != observers.end(); ++it) {
        Observer *obj = *it;
        obj->update(temperature, humidity, pressulre);
    }
}

void weaterData::measurementsChanged() {
    notifyObserver();
}

void weaterData::setMeasurements(float t, float h, float p) {
    temperature = t;
    humidity = h;
    pressulre = p;
    measurementsChanged();
}


CurrentCondition::CurrentCondition():tem(0.0), hum(0.0) {
    
}

CurrentCondition::~CurrentCondition() {
    printf("");
}
void CurrentCondition::update(float t, float h, float p) {
    tem = t;
    hum = h;
    display();
}
void CurrentCondition::display() {
    printf("当前温度：%.0f°C，当前湿度：%.0f%%!\n", tem, hum * 100.0);
}

ForecastCondition::ForecastCondition():previousPressulre(0.0),newPressulre(0.0) {
    
}

ForecastCondition::~ForecastCondition() {
    
}

void ForecastCondition::update(float t, float h, float p) {
    previousPressulre = newPressulre;
    newPressulre = p;
    display();
}

void ForecastCondition::display() {
    if (newPressulre > previousPressulre) {
        printf("Improving weather on the way!\n");
    } else if (newPressulre < previousPressulre) {
        printf("Watch out for cooler, rainy weather!\n");
    } else {
        printf("More of the same!\n");
    }
}
