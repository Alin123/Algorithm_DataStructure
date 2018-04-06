//
//  MatrixMultipleSequence.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/16.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef MatrixMultipleSequence_hpp
#define MatrixMultipleSequence_hpp

#include <stdio.h>

typedef struct MatrixScale {
    int row;
    int column;
}MatrixScale;

#define MATRIX_AMOUNT 6

extern MatrixScale test_matrixScale_array[MATRIX_AMOUNT];

int minMultipleTimes(MatrixScale array[], int n);

#endif /* MatrixMultipleSequence_hpp */
