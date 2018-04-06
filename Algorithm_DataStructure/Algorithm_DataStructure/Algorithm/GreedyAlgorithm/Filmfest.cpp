//
//  Filmfest.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/10.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "Filmfest.hpp"

Movie test_movie_array[10] ={
    {7, 9},
    {1, 2},
    {3, 4},
    {3, 5},
    {6, 8},
    {3, 6},
    {10, 12},
    {13, 16},
    {15, 17},
    {17, 19},
};

int max_variable_movies_amount(Movie array[], int moviesAmount) {
    std::sort(array, array + moviesAmount);
    int maxAmount = 0;
    int endTime = -1;
    int index = 0;
    while (index < moviesAmount) {
        if (array[index].start >= endTime) {
            maxAmount += 1;
            endTime = array[index].end;
        }
        index ++;
    }
    return maxAmount;
}
