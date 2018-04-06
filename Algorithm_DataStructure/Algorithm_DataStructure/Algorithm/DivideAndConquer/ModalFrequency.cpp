//
//  ModalFrequency.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/17.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "ModalFrequency.hpp"
#include "Swap.hpp"

int modalFrequency(int array[], int start, int end, int& modal) {// start must less than or equal to end
    if (start > end) {
        modal = array[end];
        return 0;
    }
    if (start == end) {
        modal = array[start];
        return 1;
    }
    int i = start;
    int j = end;
    int standard = array[start];
    int leftAmount = 0;
    int rightAmount = 0;
    while (i < j) {
        while (j > i && array[j] >= standard) {
            if (array[j] == standard) {
                rightAmount += 1;
            }
            j --;
        }
        if (j != i) {
            swap(array[i], array[j]);
        }
        while (i < j && array[i] <= standard) {
            if (array[i] == standard) {
                leftAmount += 1;
            }
            i ++;
        }
        if (i != j) {
            swap(array[i], array[j]);
        }
    }
    int allAmount = leftAmount + rightAmount + 1;
    modal = standard;
    //i == j
    int leftRemain = i - leftAmount - start;
    int rightRemain = end - (i + rightAmount);
    
    if (allAmount < leftRemain) {
        int leftModal = 0;
        int leftFrequency = modalFrequency(array, start, i - leftAmount - 1, leftModal);
        if (allAmount < leftFrequency) {
            allAmount = leftFrequency;
            modal = leftModal;
        }
    }
    
    if (allAmount < rightRemain) {
        int rightModal = 0;
        int rightFrequency = modalFrequency(array, i + rightAmount + 1, end, rightModal);
        if (allAmount < rightFrequency) {
            allAmount = rightFrequency;
            modal = rightFrequency;
        }
    }
    return allAmount;
}
