//
//  ALCmap.c
//  ALStructure
//
//  Created by lianzhandong on 2017/10/2.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include "ALCmap.h"
#include <stdlib.h>
#include <string.h>

HashNode *alloc_hash_node(char *name, void *data) {
    HashNode *node = (HashNode *)malloc(sizeof(HashNode));
    memset(node, 0, sizeof(HashNode));
    
    node->user_data = data;
    strcpy(node->name, name);
    
    return node;
}
// 将名字换成hash-value；使用hash算法
int hash_value(char *name) {
    unsigned long h = 0, g;
    int nKeyLength = (int)strlen(name);
    char *arEnd = ((char *)name) + nKeyLength;
    
    while (name < arEnd) {
        h = (h << 4) + *name++;
        if ((g = (h & 0xF0000000))) {
            h = h ^ (g >> 24);
            h = h ^ g;
        }
    }
    return h % HASH_AREA;
}

void free_hash_node(HashNode *node) {
    free(node);
}
#pragma mark - HashMap
//创建
HashMap *create_hash_map() {
    HashMap *map = (HashMap *)malloc(sizeof(HashMap));
    memset(map, 0, sizeof(HashMap));
    return map;
}
//存放元素
void hash_map_add(HashMap *map, char *name, void *user_data) {
    int index = hash_value(name);
    
    HashNode *node = alloc_hash_node(name, user_data);
    node->next = map->hash_area[index];
    map->hash_area[index] = node;
}
//删除元素
void hash_map_remove(HashMap *map, char *name) {
    int index = hash_value(name);
    HashNode **walk = &(map->hash_area[index]);
    while (*walk) {
        if (strcmp((*walk)->name, name) == 0) {
            HashNode *remove_node = *walk;
            *walk = remove_node->next;
            remove_node->next = NULL;
            free(remove_node);
        } else {
            walk = &(*walk)->next;
        }
    }
}
//查找
void *hash_find_data(HashMap *map, char *name) {
    int index = hash_value(name);
    HashNode *walk = map->hash_area[index];
    while (walk) {
        if (strcmp(walk->name, name) == 0) {
            return walk->user_data;
        }
        walk = walk->next;
    }
    return NULL;
}


void hash_map_clear(HashMap *map) {
    for (int i = 0 ; i < HASH_AREA; i ++) {
        HashNode *header = map->hash_area[i];
        while (header) {
            HashNode *node = header;
            header = node->next;
            node->next = NULL;
            free(node);
        }
    }
    memset(map, 0, sizeof(HashMap));
}
//销毁
void destory_hash_map(HashMap *map) {
    //释放所有的节点
    hash_map_clear(map);
    free(map);
}





















