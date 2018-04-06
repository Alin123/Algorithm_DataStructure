//
//  ALCmap.h
//  ALStructure
//
//  Created by lianzhandong on 2017/10/2.
//  Copyright © 2017年 ALin. All rights reserved.
//

#ifndef ALCmap_h
#define ALCmap_h

#include <stdio.h>

#define HASH_AREA 17

struct HashNode {
    char name[64];
    void *user_data;
    
    struct HashNode *next;
};
typedef struct HashNode HashNode;

typedef struct {
    HashNode *hash_area[HASH_AREA];
}HashMap;
//创建
HashMap *create_hash_map(void);
//销毁
void destory_hash_map(HashMap *map);
//存放元素
void hash_map_add(HashMap *map, char *name, void *user_data);
//删除元素
void hash_map_remove(HashMap *map, char *name);

void hash_map_clear(HashMap *map);
//查找
void *hash_find_data(HashMap *map, char *name);
#endif /* ALCmap_h */
