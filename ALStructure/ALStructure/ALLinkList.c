//
//  ALLinkList.c
//  ALStructure
//
//  Created by lianzhandong on 2017/10/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "ALLinkList.h"
#include <stdlib.h>
#include <string.h>

Node *alloc_node() {
    Node *node = (Node *)malloc(sizeof(Node));
    printf("create node!\n");
    memset(node, 0, sizeof(Node));
    return node;
}

void init_node(Node *node, char *name, int data) {
    strcpy(node->name, name);
    node->data = data;
}

void free_node(Node *node) {
    free(node);
}

void print_node(Node *node) {
    printf("name:%s, index:%d\n",node->name, node->data);
}

void list_add_front(Node **header, Node *node) {
    node->next = *header;
    *header = node;
}

void list_add_tail(Node **header, Node *node) {
    Node **walk = header;//改变已有指针的指向就用二级指针
    while (*walk) {
        walk = &(*walk)->next;
    }
    *walk = node;
}

void list_delete_node(Node **header, Node *node) {
    Node **walk = header;
    while (*walk) {
        if (*walk == node) {//
            *walk = node->next;
            node->next = NULL;
            return;
        }
        walk = &(*walk)->next;
    }
}

void list_delete_all(Node **header) {
    while (*header) {
        Node *node = *header;
        *header = (*header)->next;
        
        node->next = NULL;
        free(node);
        printf("free node!\n");
    }
    *header = NULL;
}

void output_list(Node *header, void (*func)(Node *)) {
    Node *walk = header;
    while (walk) {
        (*func)(walk);
        walk = walk->next;
    }
}
