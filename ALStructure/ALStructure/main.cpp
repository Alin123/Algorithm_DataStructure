//
//  main.cpp
//  ALStructure
//
//  Created by lianzhandong on 2017/10/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#include <iostream>
#include "ALCircleQueue.hpp"
#include "ALStack.hpp"
#include "Programer.hpp"
#include "RMB.hpp"
#include "Polymorphism.hpp"
#include "SingleFactory.hpp"
#include "TemplateStack.hpp"
#include "PublishObserve.hpp"
#include "Strategy.hpp"
#include "DecoratorPattern.hpp"

extern "C" {
    #include "ALCqueue.h"
    #include "ALCmap.h"
    #include "ALDynamicArray.h"
    #include "ALLinkList.h"
    #include "ALCmap.h"
}

void testCircleQueue() {
    std::cout << __FUNCTION__ << '\n';
    ALCircleQueue *queue = new ALCircleQueue(10);
    int i = 1;
    while (queue->EnQueue(i)) {
        i ++;
    }
    queue->QueueTraverse();
    std::cout << queue->QueueLength();
    
    queue->DeQueue(&i);
    queue->DeQueue(&i);
    queue->DeQueue(&i);
    queue->QueueTraverse();
    std::cout << queue->QueueLength();
    
    queue->EnQueue(1555);
    queue->EnQueue(1555);
    queue->EnQueue(1555);
    queue->EnQueue(1555);
    queue->EnQueue(1555);
    
    queue->QueueTraverse();
    std::cout << queue->QueueLength();
    
    queue->ClearQueue();
    queue->QueueTraverse();
    std::cout << queue->QueueLength();
}

void testCqueue() {
    std::cout << __FUNCTION__ << '\n';
    Person shirly = {23, "郭雪莉"};
    Person alin = {25, "廉占东"};
    /*
     ------------------
0x01 | shirly |  23   |
0x02 |        | 郭雪莉 |
     ------------------
0x03 |  alin  |  23   |
0x04 |        | 廉占东 |
     ------------------
     */
    
    Person *p = NULL;
    p = &alin;
    std::cout << (*p).name << '\n';// (*p).name、p->name、alin.name
    std::cout << p->age;
    
    Person girl = shirly;
    girl.age = 2;
    std::cout << shirly.age << '\n';
    std::cout << girl.age << '\n';
    /*
     ------------------
0x05 |    p   | 0x03  |   // p是一个指针变量，它的值为内存地址，在64位OS占8字节，地址指向其他内存空间(alin结构体首地址)
     ------------------
0x06 |  girl  |   2   |   //结构体是一些基本数据类型的集合，赋值的时候开辟空间，集合内的基本数据类型赋值
0x07 |        | 廉翘儿 |
     ------------------
     */

    Queue *family = CreateQueue(3);
    EnQueue(family, alin);
    EnQueue(family, shirly);
    EnQueue(family, girl);
    QueueTraverse(family, &printInfo);
    int length = QueueLength(family);
    std::cout << length;
}

void hexConversion() {
    std::cout << __FUNCTION__ << '\n';
    int number = 456;
    ALStack *charStack = new ALStack(10);
    while (number != 0) {
        int les = number % 2;
        char c = les + '0';
        charStack->pushStack(c);
        number = number / 2;
    }
    charStack->printStack(false, ' ');
}

//http://www.cnblogs.com/kaituorensheng/archive/2012/10/23/2736069.html
char *getString_1() {
    char *str = "我是在常量区";
    std::cout << &str;//0x7ffeefbff538
    //str = strcat(str, "是从常量区拷贝到栈区的。");//Thread 1: EXC_BAD_ACCESS (code=2, address=0x100002e48)，可见常量区地址0x100002e48
    return str;
    /*
      -----------------
0xff1 |   str  | 0x048 |
      -----------------
0x048 |        | 我是在 |
0x049 |        | 常量区 |
      -----------------
     */

}

char *getString_2() {
    char str[50] = "\0";
    strcpy(str, "我在栈区,");
    std::cout << &str;//0x7ffeefbff500，str在栈区
    //So, an array name is not a modifiable lvalue hence, you cannot assign anything to it. This is the reason behind the error message.
    //str = strcat(str, "是从常量区拷贝到栈区的。");//Array type 'char [14]' is not assignable. str的类型是char [14]，不是char *，它就指向50个字节的首地址，不能重新赋值
    //strcat(str, "是从常量区拷贝到栈区的。");这是可以的
    char *p = str;
    while (*p != '\0') {
        p ++;
    }
    strcat(p, "是从常量区拷贝到栈区的。");
    std::cout << str << '\n';
    return str;//Address of stack memory associated with local variable 'str' returned. str是栈空间的地址，出了作用域str代表的占空间会被回收，别的变量接收它之后，代表的东西已经被回收。
}

char *getString_3() {
    static char str[] = "我在静态区。";
    std::cout << &str;//0x100003150
    return str;
}
char *g_String = "";
char *getString_4() {
    std::cout << &g_String;//0x100003178
    g_String = "我在静态区。";
    std::cout << &g_String;//0x100003178
    return g_String;
}

int *malloc_relloc() {
    int *member = (int *)malloc(50 * sizeof(int));
    for (int i = 0; i < 50; i ++) {
        member[i] = i;
    }
    int *re_member = (int *)realloc(member, 100 * sizeof(int));
    for (int i = 50; i < 100; i ++) {
        re_member[i] = i;
    }
    return re_member;
}

void printMember(int *member, int cout) {
    for (int i = 0; i < cout; i ++) {
        std::cout << member[i];
    }
}

void use_memset() {
    int a[20];
    memset(a, 0, sizeof(int) * 20);
    // 1.是针对内存里面的字节的数据的初始化
    // 2.要保证这个内存是合法的，而且范围是合法的
}

void use_memcpy() {
    // 1
    char charArray[10];
    char str[] = "I love shirley!!!!";
    memcpy(charArray, str, 10);//两个地址要合法，n个字节也要合法，从低地址一个一个字节的拷贝
    std::cout << charArray;
}

void use_memove() {//如果原地与目标地址有重叠就用memove
    char c[8] = {'a','b','c'};
    memmove(c + 2, c, 4);
    std::cout << c;
}

void testDynamicArray() {
    typedef struct {
        int x;
        int y;
    }Point;
    ALDynamicArray *array = dynamicArray_malloc();
    dynamicArray_define(array, sizeof(Point));
    Point point = {3, 4};
    dynamicArray_add_elem(array, &point);
    point.x = 5,point.y = 6;
    dynamicArray_add_elem(array, &point);
    point.x = 7,point.y = 8;
    dynamicArray_add_elem(array, &point);
    point.x = 9,point.y = 10;
    dynamicArray_add_elem(array, &point);
    Point *p = (Point *)dynamicArray_elem_at(array, 0);
    if (p != NULL) {
        for (int i = 0; i < dynamicArray_length(array); i ++) {
            std::cout << "x: " << p[i].x << " " << "y: " << p[i].y << '\n';
        }
    }
    std::cout << "-------------------------" << '\n';
    dynamicArray_remove_elem(array, 1, NULL);
    p = (Point *)dynamicArray_elem_at(array, 0);
    if (p != NULL) {
        for (int i = 0; i < dynamicArray_length(array); i ++) {
            std::cout << "x: " << p[i].x << " " << "y: " << p[i].y << '\n';
        }
    }
    std::cout << "-------------------------" << '\n';
    point.x = 11, point.y = 12;
    dynamicArray_insert_elem(array, -1, &point);
    point.x = 12, point.y = 13;
    dynamicArray_insert_elem(array, -1, &point);
    p = (Point *)dynamicArray_elem_at(array, 0);
    if (p != NULL) {
        for (int i = 0; i < dynamicArray_length(array); i ++) {
            std::cout << "x: " << p[i].x << " " << "y: " << p[i].y << '\n';
        }
    }
    std::cout << "-------------------------" << '\n';
    point.x = 14, point.y = 15;
    dynamicArray_insert_elem(array, 40, &point);
    p = (Point *)dynamicArray_elem_at(array, 0);
    if (p != NULL) {
        for (int i = 0; i < dynamicArray_length(array); i ++) {
            std::cout << "x: " << p[i].x << " " << "y: " << p[i].y << '\n';
        }
    }
    
    dynamicArray_destory(array);
}

void testLinkList() {
    Node *header = alloc_node();
    init_node(header, (char *)"头节点", 0);
    
    Node *node = alloc_node();
    init_node(node, "第二个节点", 1);
    list_add_tail(&header, node);
    
    node = alloc_node();
    init_node(node, "第三个节点", 2);
    list_add_tail(&header, node);
    
    output_list(header, print_node);
    list_delete_all(&header);
}

typedef struct {
    char name[64];
    int age;
    int grade;
    int cls;
}Student;

Student *student_alloc(char *name, int age, int grade, int cls) {
    Student *student = (Student *)malloc(sizeof(Student));
    memset(student, 0, sizeof(Student));
    strcpy(student->name, name);
    student->age = age;
    student->grade = grade;
    student->cls = cls;
    return student;
}

void student_pint(Student *student) {
    std::cout << "name:" << student->name << " age:" << student->age << " grade:" << student->grade << " class:" << student->cls << '\n';
}

void testMap() {
    HashMap *map = create_hash_map();
    
    Student *s = student_alloc("Alin", 25, 3, 14);
    hash_map_add(map, s->name, s);
    
    s = student_alloc("Shirley", 23, 3, 14);
    hash_map_add(map, s->name, s);
    
    s = student_alloc("Tom", 20, 5, 1);
    hash_map_add(map, s->name, s);
    
    s = student_alloc("Jerry", 20, 5, 1);
    hash_map_add(map, s->name, s);
    
    Student *studentPtr = (Student *)hash_find_data(map, "Tom");
    student_pint(studentPtr);
    
    destory_hash_map(map);
}

void foo(Programer pgm) {
    printf("foo: 看是否调用了拷贝构造函数！");
}
void goo(const Programer& pgm) {
    printf("goo: 看是否调用了拷贝构造函数！");
}

void test_new_stack() {
    Programer alin = Programer();
    alin.setProperty(25);
    
    Programer *pAlin = new Programer();
    pAlin->setProperty(26);
    
    printf("%p", &alin);
    printf("%p", pAlin);
    Programer copyAlin = alin;//初始化，调用拷贝构造函数 //copyAlin = (age = 62420, name = "\x01"),因为重写了拷贝构造函数，若没有给新的对象的成员变量做相应的赋值，则值是随机的。
    Programer shirley;//由默认构造函数创建！
    shirley = Programer();//由默认构造函数创建！根据赋值运算符创建！由析构函数销毁！
    foo(alin);//由拷贝构造函数创建！foo: 看是否调用了拷贝构造函数
    goo(alin);//goo: 看是否调用了拷贝构造函数
}

void test_operator_overload() {
    RMB r1 = RMB(19, 1);
    RMB r2(2, 78);
    while (r1 > r2) {
        r2 ++;
        r2.printRMB();
    }
}

void study(Intellectual& intellectual) {
    intellectual.study();
}

void working(Intellectual& intellectual) {
    intellectual.working();
}

void get(Shape *s1, Shape& s2) {
    s1->getArea();
    s2.getArea();
}

void test_polymorphism() {
    Stu stu = Stu();
    Teacher tea = Teacher();
    study(stu);
    study(tea);
    working(stu);
    working(tea);
    
    Square square = Square(3.0, 4.0);
    Circle circle = Circle(5.0, 0.0);
}

void test_singleFactory() {
    Gardener alin;
    
    int i = 10;
    while (i-- > 0) {
        Fruit *fruit = alin.getFruit(arc4random() % 2);
        fruit->plant();
        fruit->grow();
        if (fruit->getIsDelicious()) {
            fruit->harvest();
        }
    }
}

void test_template_class() {
    Stack<int> stack = Stack<int>();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    StackIterator<int> iterator = StackIterator<int>(stack);//游标类，Stack的友元类
    for (int i = 0; i < 3; i ++) {
        printf("%d", iterator++);
    }
}

void test_publish_observe() {
    weaterData data = weaterData();
    
    CurrentCondition con1 = CurrentCondition();
    ForecastCondition con2 = ForecastCondition();
    
    data.registerObserver(&con1);
    data.registerObserver(&con2);
    
    data.setMeasurements(30.0f, 0.31, 100.0);
    data.setMeasurements(20.0f, 0.51, 80.0);
}

void test_strategy() {
    Duck *dDuck = new DecoyDuck();
    MallardDuck rDuck = MallardDuck();
    Duck& duck1 = rDuck;
    Duck& duck2 = *dDuck;
    
    duck1.performFly();
    duck2.performQuack();
    duck1.swim();
    duck2.swim();
    duck1.display();
    duck2.display();
}

void test_decorator() {
    BlindMonk *monk = new BlindMonk("盲僧");
    
    Skill_Q *q = new Skill_Q(monk, "天音波/回音击");
    Skill_W *w = new Skill_W(q, "金钟罩/铁布衫");
    
    w->learnSkills();
}

int main(int argc, const char * argv[]) {
#if 1
    test_decorator();
#else
    test_strategy();
    test_publish_observe();
    test_singleFactory();
    test_polymorphism();
    test_operator_overload();
    test_new_stack();
    testCircleQueue();
    testCqueue();
    hexConversion();
    std::cout << getString_1();
    std::cout << getString_2();//我在\346\240\365\277\357\376
    std::cout << getString_3();
    std::cout << getString_4();
    printMember(malloc_relloc(), 100);
    use_memcpy();
    use_memove();
    testDynamicArray();
    testLinkList();
    testMap();
#endif
    return 0;
}
