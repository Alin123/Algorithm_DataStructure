//
//  main.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/10.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include <iostream>
#include <string>
#include "SantaCluasGifts.hpp"
#include "Filmfest.hpp"
#include "StallReservations.hpp"
#include "RadarInstallation.hpp"
#include "GoneFishing.hpp"

#include "MergeSort.hpp"
#include "BinarySearch.hpp"
#include "QuickSort.hpp"
#include "LinearTimeSelect.hpp"
#include "MostClosePoint.hpp"
#include "HalfNumberSet.hpp"
#include "MatrixMultipleSequence.hpp"
#include "ConversionOfNumberSystems.hpp"
#include "BracketMatching.hpp"
#include "RPN_Evaluation.hpp"
#include "NQueen.hpp"
#include "List.hpp"
#include "Hashtable.hpp"
#include "PQ_ComplHeap.hpp"
#include "BinaryHeap.hpp"

void whatIsReference();
void testConversionOfNumberSystems();
void testBracketMatching();
void testRPN_Evaluation();
void testFourQueen();

void printInt(int *p) {
    if (p) {
        std::cout << *p << std::endl;
    }
}

int main(int argc, const char * argv[]) {

    
//    std::cout << max_worth_full_sled(test_gift_array, 4, SLED_CAPACITY);
//    std::cout << max_variable_movies_amount(test_movie_array, 10);
//    std::cout << min_stall_reservations(all_cow_array, 10);
//    std::cout << min_radar_amount(text_all_island_positions, 10, island_corresponding_interval);
//    std::cout << max_fish_amount(test_all_lake, LAKE_AMOUNT, HOUR);
    
//    std::cout << minMultipleTimes(test_matrixScale_array, MATRIX_AMOUNT);

//    whatIsReference();
//    testConversionOfNumberSystems();
//    testBracketMatching();
//    testRPN_Evaluation();
    testFourQueen();
    
    ListNode<int> node0;
    node0.data = 0;node0.pred = NULL;
    ListNode<int> node1;
    node1.data = 1;  node1.pred = &node0;  node0.succ = &node1;
    
    ListNode<int> *node2 = new ListNode<int>();
    node2->data = 2; node2->pred = &node1; node1.succ = node2;
    
    ListNode<int> *node3 = new ListNode<int>();
    (*node3).data = 3; node3->pred = node2; node2->succ = node3;
    
    int array[] = {9, 1, 2, 3, 4, 5, 5, 6, 1, 9, 7, 7, 8};
    BinaryHeap<int> heap = BinaryHeap<int>();
    for (int i = 0; i < sizeof(array) / sizeof(int); i++) {
        heap.insert(array[i]);
    }
    while (!heap.empty()) {
        std::cout << heap.delMax() << " ";
    }
    
    return 0;
}


void whatIsReference() {
    int array[] = {0, 1, 2, 3};
    int& fist = array[0];  //fist应用array的第一个元素，fist与array[0]代表同一块内存空间
    int second = array[1]; //取出array的第二个元素赋值给second
    int anotherInt = fist; //取出fist的值，也即array的第一个元素赋值给anotherInt
    array[0] = -10;
    array[1] = -10;
    std::cout << fist << " " << second << " " << anotherInt << std::endl;
    fist = 100;
    second = 200;
    anotherInt = 300;
    std::cout << array[0] << " " << array[1] << " " << array[2] << std::endl;
    int* third_p = &array[2];
    int*& third_p_ref = third_p;
    int third = *third_p;
    int anotherThird = *third_p_ref;
    *third_p = 3333;
    *third_p_ref = 3444;
    std::cout << third << " " << anotherThird << " " << array[2] << std::endl;
}

void testConversionOfNumberSystems() {
    Stack<char> s = Stack<char>();
    convert_recursion(s, 12345, 8);
    while (!s.empty()) {
        char c = s.pop();
        printf("%c", c);
    }
    printf("\n");
    
    Stack<char>* heapS = new Stack<char>();
    convert_recursion(*heapS, 12345, 8);
    while (!heapS->empty()) {
        char c = heapS->pop();
        printf("%c", c);
    }
    printf("\n");
    delete heapS;
}

void testBracketMatching() {
    char chars[] = "a/(b[i-1][j+1])+(c[i+1]))([j-1])*2";//35 = 34 + '\0'
    std::cout << bracketMatching(chars) << std::endl;
}

void testRPN_Evaluation() {
    char chars[] = "143 101 - 2 ! 3 1 ^ * /";
    std::cout << RpnEvaluation(chars) << std::endl;
}

void testFourQueen() {
    printAllValidNQueenCouple(4);
}
