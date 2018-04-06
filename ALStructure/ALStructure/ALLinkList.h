//
//  ALLinkList.h
//  ALStructure
//
//  Created by lianzhandong on 2017/10/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef ALLinkList_h
#define ALLinkList_h

#include <stdio.h>

typedef struct Node {
    char name[16];
    int data;
    struct Node *next;
}Node;

Node *alloc_node();

void init_node(Node *node, char *name, int data);

void free_node(Node *node);

void print_node(Node *node);

void list_add_front(Node **header, Node *node);

void list_add_tail(Node **header, Node *node);

void list_delete_node(Node **header, Node *node);

void list_delete_all(Node **header);

void output_list(Node *header, void (*func)(Node *));

#endif /* ALLinkList_h */
