//
//  Filmfest.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/10.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Filmfest_hpp
#define Filmfest_hpp

#include <stdio.h>
#include <algorithm>

typedef struct Movie {
    int start;
    int end;
    bool operator<(const Movie &m) const {
        return end < m.end;
    }
}Movie;
extern Movie test_movie_array[10];
int max_variable_movies_amount(Movie array[], int moviesAmount);

#endif /* Filmfest_hpp */
