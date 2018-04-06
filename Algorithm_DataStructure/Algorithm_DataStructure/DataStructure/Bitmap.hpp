//
//  Bitmap.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/30.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Bitmap_hpp
#define Bitmap_hpp

#include <stdio.h>
#include <memory.h>

class Bitmap {
private:
    int N;   // 位图的所占的字节(1字节：8比特)数
    char* M; // M[]存放所有的比特位，共有N*sizeof(char)*8个比特，其中sizeof(char)在32位、64位机器上都占1个字节
protected:
    void init(int n) {
        N = (n + 7) / 8;
        M = new char[N];
        memset(M, 0, N);
    }
    /// @brief 扩展位图容量直至能容纳下i
    void expand(int i) {
        if (i < 8 * N) return;
        int oldN = N;
        char *oldM = M;
        init(i * 2);           //同样的扩容策略
        memcpy(M, oldM, oldN); //把数据复制过去
        delete [] oldM; oldM = NULL; //释放原有的内存空间
    }
public:
    /// @brief 默认构造器
    Bitmap(int n = 8) {
        init(n);
    }
    /// @brief 析构函数
    ~Bitmap() {
        delete [] M;
        M = NULL;
    }
    void set(int i) {
        expand(i);
        M[i >> 3] |= (0x80 >> (i & 0x07)); //位操作
    }
    void clear(int i) {
        expand(i);
        M[i >> 3] &= ~(0x80 >> (i & 0x07));
    }
    bool test(int i) {
        expand(i);
        return M[i >> 3] & (0x80 >> (i & 0x07));
    }
    char* bits2string(int i) {
        expand(i - 1);
        char* s = new char[i + 1];
        s[i] = '\0';
        for (int j = 0; j < i; j++) {
            s[j] = test(j) ? '1' : '0';
        }
        return s;
    }
};

#endif /* Bitmap_hpp */
