//
//  ALCqueue.c
//  ALStructure
//
//  Created by lianzhandong on 2017/10/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "ALCqueue.h"

#pragma mark - struct Person

void printInfo(Person *p) {
    printf("姓名：%s，年龄：%d\n", p->name, p->age);
}

#pragma mark - struct Queue

Queue *CreateQueue(int capacity) {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->capacity = capacity;
    q->array = (Person *)malloc(capacity * sizeof(Person));
    q->front = q->rear = 0;
    q->length = 0;
    return q;
}

void DestoryQueue(Queue *q) {
    free(q->array);
    q->array = NULL;
    free(q);
    q = NULL;
}

bool QueueEmpty(Queue *q) {
    return q->length == 0 ? true : false;
}
bool QueueFull(Queue *q) {
    return q->length == q->capacity ? true : false;
}

bool EnQueue(Queue *q, Person p) {
    if (QueueFull(q)) {
        return false;
    }
    q->array[q->rear] = p;
    q->rear = (q->rear + 1) % q->capacity;
    q->length ++;
    return true;
}

bool DeQueue(Queue *q, Person *p) {
    if (QueueEmpty(q)) {
        return false;
    }
    *p = q->array[q->front];
    q->front = (q->front + 1) % q->capacity;
    q->length --;
    return true;
}

void QueueTraverse(Queue *q, void (*visit)(Person *)) {
    for (int i = q->front; i < q->front + q->length; i ++) {
        Person pAtIdx = q->array[i % q->capacity];
        (*visit)(&pAtIdx);
    }
}

int QueueLength(Queue *q) {
    return q->length;
}
