//
//  MatrixMultipleSequence.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/16.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "MatrixMultipleSequence.hpp"
#include <math.h>

//f(i:j) = min{f(i:k) + f(k+1:j) + i.row * k.column + j.column} 其中i≤k<j

MatrixScale test_matrixScale_array[MATRIX_AMOUNT] = {
    {30, 35},
    {35, 15},
    {15, 5},
    {5, 10},
    {10, 20},
    {20, 25},
};

int oneDimensional(int row, int column, int n) {
    return row * n + column;
}

void fullAllTimes_DP(MatrixScale array[], int n, int* times) {
    for (int i = 0; i < n; i ++) {
        times[oneDimensional(i, i, n)] = 0;
    }
    int less = 1;
    for (int i = 1; i < n; i ++) {
        for (int j = 0; j < n - i; j ++) {
            int column = i + j;
            int row = column - less;
            int mulTimes = __INT_MAX__;
            for (int k = row; k < column; k ++) {
                int kTimes = times[oneDimensional(row, k, n)] + times[oneDimensional(k + 1, column, n)] + (array[row].row) * (array[k].column) * (array[column].column);
                if (kTimes < mulTimes) {
                    mulTimes = kTimes;
                }
            }
            times[oneDimensional(row, column, n)] = mulTimes;
        }
        less += 1;
    }
    for (int i = 0; i < n; i ++) {
        for (int j = 0; j < n; j ++) {
            printf("%5d ", times[oneDimensional(i, j, n)]);
        }
        printf("\n");
    }
}

int minMultipleTimes(MatrixScale array[], int n) {
    int* allTimes = new int[n * n]{-1};
    fullAllTimes_DP(array, n, allTimes);
    int min = allTimes[oneDimensional(0, n - 1, n)];
    delete [] allTimes;
    return min;
}


