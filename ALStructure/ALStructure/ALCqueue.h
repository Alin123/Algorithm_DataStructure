//
//  ALCqueue.h
//  ALStructure
//
//  Created by lianzhandong on 2017/10/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef ALCqueue_h
#define ALCqueue_h

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct {
    int age;
    char name[10];
}Person;

void printInfo(Person *p);

typedef struct {
    Person *array;
    int capacity;
    int length;
    
    int front;
    int rear;
}Queue;

Queue *CreateQueue(int capacity);
void DestoryQueue(Queue *q);

bool QueueEmpty(Queue *q);
bool QueueFull(Queue *q);

bool EnQueue(Queue *q, Person p);
bool DeQueue(Queue *q, Person *p);

void QueueTraverse(Queue *q, void (*visit)(Person *));
int QueueLength(Queue *q);

#endif /* ALCqueue_h */
