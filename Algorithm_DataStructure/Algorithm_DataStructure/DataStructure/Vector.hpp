//
//  Vector.hpp
//  Algorithm_DataStructure
//
//  Created by lianzhandong on 2018/3/17.
//  Copyright © 2018年 ALin. All rights reserved.
//

#ifndef Vector_hpp
#define Vector_hpp

#include <stdio.h>
#include <stdlib.h>
#include "Swap.hpp"

typedef int Rank;

#define DEFAULT_CAPACITY 3

template <typename T>
class Vector {
private:
    Rank _size;
    int _capacity;
    T* _elem;
protected:
    void copyFrom(T* const A, Rank lo, Rank hi) {//基于数组的复制构造，开闭区间[lo, hi)
        _capacity = 2 * (hi - lo);
        _elem = new T[_capacity];
        _size = 0;
        while (lo < hi) {//A[lo, hi)内的元素逐一
            _elem[_size++] = A[lo++];//复制到_elem[0, _size)
        }
    }
    void expand(){//空间不足时扩容
        if (_size < _capacity) {
            return;
        }
        if (_capacity < DEFAULT_CAPACITY) {
            _capacity = DEFAULT_CAPACITY;
        }
        T* oldElem = _elem;
        _elem = new T[_capacity *= 2];
        for (Rank i = 0; i < _size; i ++) {
            _elem[i] = oldElem[i];
        }
        delete [] oldElem;
    }
    void shrink() {//装载因子(_size/_capicity)过小时压缩
        //printf("容量：%d，数量：%d\n", _capacity, _size);
        if (_capacity < DEFAULT_CAPACITY) {
            return;
        }
        if (_size * 4 > _capacity) {
            return;
        }
        T* oldElem = _elem;
        _elem = new T[_capacity /= 2];
        for (Rank i = 0; i < _size; i ++) {
            _elem[i] = oldElem[i];
        }
        delete [] oldElem;
    }
    bool bubble(Rank lo, Rank hi){//一趟扫描交换
        bool sorted = true;
        while (++lo < hi) {
            if (_elem[lo - 1] > _elem[lo]) {
                sorted = false;
                swap(_elem[lo - 1], _elem[lo]);
            }
        }
        return sorted;
    }
    void bubbleSort(Rank lo, Rank hi) {
        while (!bubble(lo, hi--));
    }
    void exchange(Rank lo, Rank hi) {
        swap(_elem[lo], _elem[hi]);
    }
    void permute() {//置乱
        for (Rank i = _size; i > 0; i --) {
            swap(_elem[i - 1], _elem[rand() % i]);//
        }
    }
    Rank selectMax(Rank lo, Rank hi) {//从前往后找出最大的元素的秩
        Rank idx = lo;
        while (++lo < hi) {
            if (_elem[lo] > _elem[idx]) {
                idx = lo;
            }
        }
        return idx;
    }
    void selectionSort(Rank lo, Rank hi) {
        while (hi - lo > 1) { //当剩余两个数时
            Rank maxIdx = selectMax(lo, hi);//找出最大
            swap(_elem[maxIdx], _elem[hi - 1]);//交换位置
            hi --;//规模减小
        }
    }
    void merge(Rank lo, Rank mid, Rank hi) {
        T* A = _elem + lo;
        int lb = hi - lo;
        T* B = new T[lb];
        for (Rank i = 0; i < lb; B[i] = A[i++]);
        int lc = hi - mid; T* C = _elem + mid;
        Rank i = 0, j = 0, k = 0;
        while (j < lb && k < lc) {
            while (j < lb && B[j] <= C[k]) {
                A[i++] = B[j++];
            }
            while (k < lc && C[k] <= B[j]) {
                A[i++] = C[k++];
            }
        }
        while (j < lo) {
            A[i++] = B[j++];
        }
        delete [] B;
    }
    void mergeSort(Rank lo, Rank hi) {
        if (hi - lo < 2) {
            return;
        }
        Rank mid = (lo + hi) >> 2;
        mergeSort(lo, mid);//闭开区间[lo, mid)
        mergeSort(mid, hi);//闭开区间[mid, hi)
        merge(lo, mid, hi);
    }
    void quickSort(Rank lo, Rank hi) {
        if (hi - lo < 2) {
            return;
        }
        Rank i = lo;
        Rank j = hi - 1;
        T standard = _elem[i];
        while (i < j) {
            while (j > i && _elem[j] >= standard) {
                j--;
            }
            swap(_elem[i], _elem[j]);
            while (i < j && _elem[i] <= standard) {
                i++;
            }
            swap(_elem[i], _elem[j]);
        }
        quickSort(lo, i);
        quickSort(i + 1, hi);
    }
    static Rank percolateDown(T* E, Rank n, Rank i) {
        Rank lc = 2 * i + 1;
        Rank rc = 2 * i + 2;
        while (true) {
            if (rc < n) {//有右孩子，则
                Rank bigger = E[lc] < E[rc] ? rc : lc;//i与左、右孩子中较大者比较
                if (E[i] < E[bigger]) {//如果i小于较大的孩子
                    swap(E[i], E[bigger]); //交换
                    i = bigger;            //记录新的i位置
                } else {    //否者，下滤结束
                    break;
                }
            } else if (lc < n && E[i] < E[lc]) {//有左孩子，且i小于左孩子，则
                swap(E[i], E[lc]); //交换
                i = lc;            //记录新的i位置
            } else {  //否者无左孩子，或只有左孩子但左孩子小于等于i
                break;//下滤结束
            }
            lc = 2 * i + 1;
            rc = 2 * i + 2;
        }
        return i;
    }
    void heapSort(Rank lo, Rank hi) {
        int n = hi - lo;
        for (Rank i = (n - 1) >> 1; i > - 1; i--) {//对每一个内部节点进行下滤，构建堆
            percolateDown(_elem + lo, n, i);
        }
        while (hi - lo > 1) {//当还有两个元素时
            swap(_elem[lo], _elem[--hi]);//把最大的放后边，一个较小的放最前边
            percolateDown(_elem + lo, hi - lo, 0);//然后下滤
        }
    }
    void insertSort(Rank lo, Rank hi) {
        Rank p = lo + 1;
        while (p < hi) {
            T inserter = _elem[p];
            Rank i = p - 1;
            while (i >= lo && _elem[i] > inserter) {
                _elem[i + 1] = _elem[i];
                i --;
            }
            _elem[i + 1] = inserter;
            p++;
        }
    }
public:
//构造函数
    Vector(int c = DEFAULT_CAPACITY) {//默认构造函数
        _capacity = c;
        _elem = new T[_capacity];
        _size = 0;
    }
    Vector(T* A, Rank lo, Rank hi) {
        copyFrom(A, lo, hi);
    }
    Vector(T* A, Rank n) {
        copyFrom(A, 0, n);
    }
    Vector(Vector<T> const& V, Rank lo, Rank hi) {
        copyFrom(V._elem, lo, hi);
    }
    Vector(Vector<T> const& V, Rank n) {
        copyFrom(V._elem, 0, n);
    }
//析构函数
    ~Vector() {
        delete [] _elem;//只需释放用于存放元素的内部数组_elem[]. 将其占据的空间交还操作系统
        //_capicity，_size之类的内部变量，它们将作为向量对象自身的一部分被系统回收，此后无需也无法被引用
        //谁申请谁释放的原则，
    }
//只读访问接口
    Rank size() const {
        return _size;
    }
    bool empty() const {
        return _size <= 0;
    }
    int disordered() const {
        int n = 0;
        for (Rank i = 1; i < _size; i ++) {
            if (_elem[i - 1] > _elem[i]) {
                n ++;
            }
        }
        return n;
    }
    //无序向量查找
    Rank find(T const& e, Rank lo, Rank hi) const {
        while (lo < (hi--) && _elem[hi] != e);
        return hi;
    }
    Rank find(T const& e) const {
        return find(e, 0, _size);
    }
    //模糊定位，查找最后一个小于e的值
    Rank fuzzyLocalization(T const& e) const {
        Rank lo = 0;
        Rank hi = _size;
        while (lo < hi) {
            Rank mid = (lo + hi) >> 1;
            if (_elem[mid] < e) {//三分枝到两分枝
                lo = mid;
            } else {
                hi = mid - 1;
            }
        }
        return lo - 1;
    }
    //有序向量查找
    Rank binSearch(T const& e, Rank lo, Rank hi) const {
        while (lo < hi) {
            Rank mid = (lo + hi) >> 1;
            if (_elem[mid] == e) {
                return mid;
            } else if (_elem[mid] > e) {
                hi = mid;
            } else {
                lo = mid + 1;
            }
        }
        return -1;
    }
    Rank search(T const& e, Rank lo, Rank hi) const {
        return binSearch(e, lo, hi);
    }
    Rank search(T const& e) {
        return search(e, 0, _size);
    }
//可写访问接口
    T& operator[](Rank r) const {//重载下表运算符，可以像数组那样引用个元素，assert: 0≤r<_size
        return _elem[r];
    }
    Vector<T> & operator=(Vector<T> const& A) {
        if (_elem) {
            delete [] _elem;
        }
        copyFrom(A._elem, 0, A.size());
        return *this;
    }
    T remove(Rank r) {
        T e = _elem[r];
        remove(r, r + 1);
        return e;
    }
    int remove(Rank lo, Rank hi) {
        if (lo == hi) {
            return 0;
        }
        while (hi < _size) {
            _elem[lo++] = _elem[hi++];
        }
        _size = lo;
        shrink();
        return hi - lo;
    }
    Rank insert(Rank r, T const& e) {
        expand();
        for (Rank i = _size; i > r; i--) {
            _elem[i] = _elem[i - 1];
        }
        _elem[r] = e;
        _size ++;
        return r;
    }
    Rank insert(T const& e) {
        return insert(_size, e);
    }
    void sort(Rank lo, Rank hi) {
        switch (rand() % 5) {
            case 0: {
                printf("冒泡排序：");
                bubbleSort(lo, hi);
            }
                break;
            case 1: {
                printf("选择排序：");
                selectionSort(lo, hi);
            }
                break;
            case 2: {
                printf("用堆排序：");
                heapSort(lo, hi);
            }
                break;
            case 3: {
                printf("快速排序：");
                quickSort(lo, hi);
            }
                break;
            case 4: {
                printf("插入排序：");
                insertSort(lo, hi);
            }
                break;
            default:
                break;
        }
    }
    
    void sort() {
        sort(0, _size);
    }
    void unsort(Rank lo, Rank hi) {
        T* V = _elem + lo;
        for (Rank i = hi - lo; i > 0; i--) {
            swap(V[i - 1], V[rand() % i]);
        }
    }
    void unsort() {
        unsort(0, _size);
    }
    int deduplicate() {//无序去重
        int oldSize = _size;
        Rank i = 1;
        while (i < _size) {
            Rank r = find(_elem[i], 0, i);
            if (r > -1) {
                remove(r);
            } else {
                i ++;
            }
        }
        return oldSize - _size;
    }
    int uniquify() {//有序去重
        Rank i = 0, j = 0;
        while (++j < _size) {
            if (_elem[i] != _elem[j]) {
                _elem[++i] = _elem[j];
            }
        }
        _size = ++i;
        shrink();
        return j - i;
    }
//遍历
    void traverse(void (*visit)(T&)) {//使用函数指针，只读或局部性修改
        for (Rank i = 0; i < _size; i ++) {
            visit(_elem[i]);
        }
    }
    template <typename VST> void traverse(VST& visit) {//使用函数对象可全局性修改
        for (Rank i = 0; i < _size; i ++) {
            visit(_elem[i]);
        }
    }
};

#endif /* Vector_hpp */
