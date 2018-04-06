//
//  RPN_Evaluation.cpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/21.
//  Copyright © 2018年 ALin. All rights reserved.
//

#include "RPN_Evaluation.hpp"
#include "Stack.hpp"
#include <math.h>

int number(char array[], int start, int& length) {
    length = 0;
    int number = 0;
    while (array[start + length] != ' ') {
        number = number * 10 + (array[start + length] - '0');
        length ++;
    }
    return number;
}

int fac(int n) {
    int res = 1;
    while (n) {
        res *= n;
        n --;
    }
    return res;
}

int RpnEvaluation(char array[]) {
    Stack<int> stack = Stack<int>();
    for (int i = 0; array[i] != '\0';) {
        char c = array[i];
        switch (c) {
            case '0': case '1': case '2': case '3': case '4':
            case '5': case '6': case '7': case '8': case '9': {
                int numLen = 0;
                int num = number(array, i, numLen);
                i += numLen;
                stack.push(num);
            }
                break;
            case '+': {
                int numSuf = stack.pop();
                int numPre = stack.pop();
                stack.push(numPre + numSuf);
                i += 1;
            }
                break;
            case '-': {
                int numSuf = stack.pop();
                int numPre = stack.pop();
                stack.push(numPre - numSuf);
                i += 1;
            }
                break;
            case '*': {
                int numSuf = stack.pop();
                int numPre = stack.pop();
                stack.push(numPre * numSuf);
                i += 1;
            }
                break;
            case '/': {
                int numSuf = stack.pop();
                int numPre = stack.pop();
                stack.push(numPre / numSuf);
                i += 1;
            }
                break;
            case '^': {
                int numSuf = stack.pop();
                int numPre = stack.pop();
                stack.push(pow(numPre, numSuf));
                i += 1;
            }
                break;
            case '!': {
                int num = stack.pop();
                stack.push(fac(num));
                i += 1;
            }
                break;
            default:
                i += 1;
                break;
        }
    }
    return stack.pop();
}


