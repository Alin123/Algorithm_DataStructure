# Algorithm_DataStructure
持续探究算法与数据结构，暨邓俊辉《数据结构》（C++语言版）&amp;王晓东《计算机算法设计与分析》读书笔记

### 算法设计策略与实例(上)
#### 1.枚举：基于逐个尝试答案的一种求解策略
有些问题可以通过数学公式计算出结果。比如，计算连续整数a到b的和sum[a, b]。借鉴求梯形面积的公式（上底加下底乘以高除以二）可知__sum[a, b] = (a+b)(b-a+1)/2__，此算法的时间复杂度为O(1)。当然也可以通过循环累加的方法计算sum[a, b]，此时时间复杂度为O(n)。

然而更多的问题没有数学公式可用。
##### 例1.1：求小于N的最大素数。
此时找不到一个数学公式，使得根据N就可以计算出这个素数。而是要通过判断N-1是不是素数、N-2是不是素数...的方式逐个排查可能是素数的值。

```
bool isPrim(unsigned int x) { //判断一个数是不是素数
    for (int i = 2; i * i <= x; i++) {
        if (x % i == 0) {
            return false;
        }
    }
    return true;
}
int primLessThan(unsigned int N) { //小于N的最大素数
    int x = N - 1;
    if (x < 2)
        return -1;
    while (x > 2) {
        if (isPrim(x))
            return x;
        else
            x --;
    }
    return 2;
}
```
##### 例1.2：完美立方
问题描述：形如a<sup>3</sup>=b<sup>3</sup>+c<sup>3</sup>+d<sup>3</sup>的等式被称作完美立方。例如12<sup>3</sup>=6<sup>3</sup>+8<sup>3</sup>+10<sup>3</sup>。给定正整数N（N<=100），寻找所有的四元组（a，b，c，d）使得它们满足完美立方，其中a，b，c，d大于1，小于等于N，且b<=c<=d。

```
void perfectCube(unsigned int N) {
    for (int a = 2; a <= N; a ++) {
        for (int b = 2; b < a; b ++) {
            for (int c = b; c < a; c ++) {
                for (int d = c; d < a; d ++) {
                    if (a*a*a == b*b*b + c*c*c + d*d*d) {
                        printf("(%d,%d,%d,%d)\n", a, b, c, d);
                    }
                }
            }
        }
    }
}
```

##### 例1.3：生理周期
问题描述：人有体力、情商、智商的高峰日子，它们分别每隔23、28、33天出现一次。对于每个人，我们想知道合适三个高峰落在同一天。给定三个高峰出现的日子p、e、i，在给定另一个指定的日子d，问在距离d多少天后三个高峰落在同一天。

```
int getLuckyDay(int p, int e, int i, int givenDay) {
    int after = 0;
    for (; (givenDay + after - p) % 23 != 0; after ++);
    for (; (givenDay + after -e) % 28 != 0; after += 23);
    for (; (givenDay + after - i) % 33 != 0; after += 23 * 28);
    return after;
}
```
##### 例1.4：称硬币
有12枚硬币（A～L），其中有11枚真币和1枚假币。真币和假币重量不同，到不知道假币比真币轻还是重。现在用一架天平称这些硬币三次，告诉你称的结果，请你找出假币并且确定假币是轻还是重。<br/>
输入样例：<br/>
ABCD EFGH even（其中up、down、even）表示右端高、右端低、平衡<br/>
ABCI EFJK up<br/>
ABIJ EFGH even<br/>
输出样例：<br/>
K is the counterfeit coin and it is light.

```
char Left[3][7];  //天平左边的硬币
char Right[3][7]; //天平右边的硬币
char Result[3][7];//每次称量的结果
for (char c = 'A'; c <= 'L'; c++) {
    if(isFake(c, true)){
        printf("%c is the counterfeit coin and it is light.", c);
        break;
    } else if (isFake(c, false)) {
        printf("%c is the counterfeit coin and it is heavy.", c);
        break;
    }
}

bool isFake(char c, bool light) {
    for (int i = 0; i < 3; i++) {
        char *pLeft, *pRight;
        if (light) {
            pLeft = Left[i];
            pRight = Right[i];
        } else {
            pLeft = Right[i];
            pRight = Left[i];
        }
        switch (Result[i][0]) {
            case 'u':
                if (strchr(pRight, c) == NULL) { // 字符c在pRight中首次出现的位置
                    return false;
                }
                break;
            case 'e':
                if (strchr(pLeft, c) || strchr(pRight, c)) {
                    return false;
                }
                break;
            case 'd':
                if (strchr(pLeft, c) == NULL) {
                    return false;
                }
                break;
            default:
                break;
        }
    }
    return true;
}

```
##### 例1.5：熄灯问题
问题描述：

1. 有一个由按钮组成的矩阵，其中每行6个按钮，共5行
2. 每个按钮的位置上有一盏灯
3. 当按下一个按钮后，该按钮以及周围位置（上边、下边、左边、右边）的灯都会改变一次（点亮->熄灭，熄灭->点亮）
4. 在矩阵角上的按钮改变3盏灯的状态，在矩阵边上的按钮改变4盏灯的状态，其他的按钮改变5盏灯的状态

对矩阵中的每一盏灯设置一个初始状态，问哪种按钮组合恰好使得所有的灯都熄灭？<br/>
由问题可知：

1. 第二次按下同一个按钮时，将抵消第一次按下时所产生的效果，所以每个按钮最多需要按下一次
2. 各个按钮按下的顺序对最终的结果没有影响
3. 对于第1行中每盏点亮的灯，按下第2行对应的按钮，就可以熄灭第1行的全部灯
4. 重复3中的操作即可熄灭第1、2、3、4行的全部灯

__解法一__：枚举所有按钮的状态，对每一种结果计算灯最后的状态，若全部熄灭则该结果就是最终的状态。然而，每个按钮有两个状态，一共有30个按钮，所以有2<sup>30</sup>中需要枚举的结果。太多，会超时！该方法不可行。<br/>
如何减少枚举的数目呢？<br/>
__基本思路__：如果存在某个局部，一旦这个局部的状态被确定，那么剩余其他部分的状态只能是确定的一种，或者不多的n种，那么就只需枚举这个局部的状态即可<br/>
__结论&解法二__：矩阵中的第1行（或第1列）就是这个局部。一旦第1行的按钮的状态确定(0,0,0,0,0,1)，那么要想让第一行的灯熄灭只需改变和第1行中点亮灯位置对应的、在第2行的按钮的状态(0,0->1,0,0,0->1,0)。然后是第3行、第4行...当第5行的按钮的状态确定时，前4行的灯都是熄灭的，若此时第5行的灯也是熄灭的，那么假设的第一行的按钮的状态是正确的，否者枚举下一个第1行按钮的状态。

```
char oriLights[5];//每个元素对应矩阵中的一行灯
char lights[5];   //变化中的灯
char result[5];   //每次枚举的开关的状态
int getBit(char c, int i) {
    return (c >> i) & 1;
}
void setBit(char &c, int i, int v) {
    if (v) {
        c |= (1 << i);
    } else {
        c &= ~(1 << i);
    }
}
void flipBit(char &c, int i) {
    c ^= (1 << i);
}
void getAllState() {
    for (int n = 0; n < 64; n++) { //n表示第一行开关的状态
        memcpy(lights, oriLights, sizeof(oriLights));
        
        int switchs = n;
        for (int i = 0; i < 5; i++) {
            result[i] = switchs; //存储第i行开关的状态
            for (int j = 0; j < 6; j++) {//处理第i行的开关对矩阵中灯的影响
                if(getBit(switchs, j)) {
                    if (j > 0) {
                        flipBit(lights[i], j - 1);
                    }
                    flipBit(lights[i], j);
                    if (j < 5) {
                        flipBit(lights[i], j + 1);
                    }
                }
            }
            if (i < 4) {
                lights[i + 1] ^= switchs;
            }
            switchs = lights[i];//确定下一行开关的状态，根据第i行灯的状态就可以确定i+1行开关的状态
        }
        if (lights[4] == 0) {//最后一行的灯是否全部熄灭
            break;
        }
    }
}
```
##### 枚举总结
1. 定义好边界
2. 对可能的、有限的结果进行枚举
3. 剔除不必要的枚举
4. 根据条件判断出符合的结果，并及时结束枚举过程

#### 2.递归：一个过程或函数在其定义或说明中有直接或间接调用自身的一种方法。
它通常把一个大型复杂的问题层层转化为一个与原问题相似的规模较小的问题来求解，递归策略只需少量的程序就可描述出解题过程所需要的多次重复计算，大大地减少了程序的代码量。递归的能力在于用有限的语句来定义对象的无限集合。一般来说，递归需要有边界条件、递归前进段和递归返回段。当边界条件不满足时，递归前进；当边界条件满足时，递归返回。
##### 例2.1：斐波那契数列，指的是这样一个数列：1、1、2、3、5、8、13...从第三项开始（含第三项），每一项的数字是前两项数字的和。
```
int Fibonacci(int n) { //n从0开始表示第一项
	if (n < 2) 
		return 1;
	return Fibonacci(n - 1) + Fibonacci(n - 2); 
}
```
递归式：f(n)=f(n-1)+f(n-2)，n ≥ 2<br/>
终止条件：f(0)=1、f(1)=1，2 > n ≥ 0
##### 例2.2：汉诺塔问题
问题描述：大梵天创造世界的时候做了三根金刚石柱子，在一根柱子上从下往上按照大小顺序摞着64片黄金圆盘。大梵天命令婆罗门把圆盘从下面开始按大小顺序重新摆放在另一根柱子上。并且规定，在小圆盘上不能放大圆盘，在三根柱子之间一次只能移动一个圆盘。<br/>
思路：

1. 当有一个盘子的时候可直接从原位置移动到目标位置，不用借助中转位：src->dest
2. 当有两个盘子的时候，将问题拆解。
 * 先移动最上面的盘子到中转的盘子（此时中转的盘子对于最上面的盘子来说就是目标位置），src->mid，__也即重复步骤1__
 * 再把下面的盘中移动到目标位置，src->dest，__也即重复步骤1__
 * 再把上面的盘子移动到目标位置，mid->dest，__也即重复步骤1__
3. 当有三个盘子的时候，可以将上面两个盘子看成一个整体，问题变成了先将上面一个整体（两个盘子）移动到中转位置...__也即重复步骤2__
4. 当有四个盘子的时候，可以将上面三个盘子看成一个整体，问题变成了先将上面一个整体（三个盘子）移动到中转位置...__也即重复步骤3__。三个盘子移动到mid的位置需要借助“中转位置”，此时最下面的盘子是最大的，所以最大的盘子所在的位置即可当作“中转位置”

```
void Hanoi(int n, char src, char mid, char dest) {
    if (n == 1) {
        printf("%c -> %c\n", src, dest);
        return;
    }
    Hanoi(n-1, src, dest, mid);
    printf("%c -> %c\n", src, dest);
    Hanoi(n-1, mid, src, dest);
}
```

递归式：Hanoi(n, Src, Mid, Dest) = Hanoi(n-1, Src, Dest, Mid) <font color=red>__+__</font> Move(1, Src, Dest) <font color=red>__+__</font> Hanoi(n-1, Mid, Src, Dest)，n ≥ 2<br/>
终止条件：Hanoi(1, Src, Mid, Dest) = Move(1, Src, Dest) = [Src->Dest]，n=1
##### 例2.3：爬楼梯问题：递推朝着两或有限（常数）个方向发展
问题描述：树老师爬楼梯，他可以每次走1级或2级台阶，问一个N个台阶的楼梯（n≥1）树老师有多少种不同的爬楼梯方法。<br/>
思路：N级台阶分成两部分，第一步要走的台阶和剩余要走的台阶。此时走法总和是<font color=red>1\*剩余台阶走法种数</font> ，即f(N)=1*f(N-x)，其中x取值1或2，表示第一步走1级台阶或走2级台阶。爬楼梯的方法被分成两类，一种是第一步爬1个台阶，另一种要爬两个台阶。那么总的方法数就是这两种方法的和<br/>
递归式：f(N)=1\*f(N-1)+1\*f(N-2)，N ≥ 3<br/>
终止条件：f(1)=1，f(2)=2，2 ≥ n > 0

```
int ClimbStairs(int n) {
	if (n < 3)
		return n;
	return ClimbStairs(n - 1) + ClimbStairs(n - 2);
}
```
##### 例2.4：放苹果问题
问题描述：把M个同样的苹果放在N个同样的盘子里，允许有的盘子空着不放，问总共有多少种不同的分法f(M, N)？对于7个苹果放入三个篮子，5、1、1和1、5、1是同一种分法。<br/>
			
思路：当M<N时，f(M, N)=f(M, M)；当M<=N时，总放法=有盘子为空的方法 + 没盘子为空的方法。其中有盘子为空的方法总数是f(M, N-1)，因为是递归，一个盘子为空的情形也包含了两个盘子为空的情形。没盘子为空的方法总数是f(M-N, N)，每个盘子放一个后，问题成了把M-N个放到N个盘子里。

递归式：f(M, N)=f(M, N-1)+f(M-N, N)<br/>
终止条件：f(0, N)=1，f(M, 0)=0

```
int AppleToPlate(int m, int n) {
	if (m < n) 
		return AppleToPlate(m, m);
	if (m == 0)
		return 1;
	if (n == 0)
		return 0;
	return AppleToPlate(m, n-1) + AppleToPlate(m-n, n);
}
```
##### 例2.5：N皇后问题
__分析一__：由问题的描述可知两个皇后Q1(x, y)、Q2(row, col)不符合要求，则以下四个条件之一必符合。

1. x == row（Q1、Q2在同一行）
2. y == col（Q1、Q2在同一列）
3. x + y == row + col（Q1、Q2在对角线上）
4. x - y == row - col（Q1、Q2在对角线上）

对于有具体个皇后的问题可以通过枚举解决问题，枚举常用于处理有上下边界的问题，有了上下边界就可以确定枚举的范围。若N=4，即4皇后问题，枚举每行所有可能的位置，去除所有不符合的位置的组合，剩下的就是符合条件的组合。

```
void fourQueen() {
    for (int r0 = 0; r0 < 4; r0 ++) {
        for (int r1 = 0; r1 < 4; r1 ++) {
            if (r1 == r0) {//也不能在同一列
                continue;
            }
            // r0 的对角线 在第1行的位置(即列号)
            if ((0 + r0) == (1 + r1) || (0 - r0) == (1 - r1)) {
                continue;
            }
            for (int r2 = 0; r2 < 4; r2 ++) {
                if (r2 == r1 || r2 == r0) {
                    continue;
                }
                // r0 的对角线 在第2行的位置(即列号)
                if ((0 + r0) == (2 + r2) || (0 - r0) == (2 - r2)) {
                    continue;
                }
                // r1 的对角线 在第2行的位置(即列号)
                if ((1 + r1) == (2 + r2) || (1 - r1) == (2 - r2)) {
                    continue;
                }
                for (int r3 = 0; r3 < 4; r3 ++) {
                    if (r3 == r2 || r3 == r1 || r3 == r0) {
                        continue;
                    }
                    // r0 的对角线 在第3行的位置(即列号)
                    if ((0 + r0) == (3 + r3) || (0 - r0) == (3 - r3)) {
                        continue;
                    }
                    // r1 的对角线 在第3行的位置(即列号)
                    if ((1 + r1) == (3 + r3) || (1 - r1) == (3 - r3)) {
                        continue;
                    }
                    // r2 的对角线 在第3行的位置(即列号)
                    if ((2 + r2) == (3 + r3) || (2 - r2) == (3 - r3)) {
                        continue;
                    }
                    printf("%d---%d---%d---%d\n", r0, r1, r2, r3);
                }
            }
        }
    }
}
```

然而对于不确定的N（N并非一个已知的常量），因无法写出n层循环。所以对于N皇后无法用枚举的策略。

__分析二__：<font color=red>从整体到局部，若整体是那么局部也是</font>，对于N*N的皇后布局，前N-1行中即`N*(N-1)`的矩阵，也满足N皇后的条件。<font color=red>再从局部再到整体</font>，若前x行已满足条件，记为matrix[N, x]，然后遍历第x+1行所有的位置，并逐个校验，对于所有满足条件的矩阵matrix[N, x+1]，继续往下校验出x+2行满足条件的位置......直到x=N，证明前N行已经满足条件，则该矩阵就是一个满足条件的布局方式。

```
#define N 8              //皇后个数
int Queen[N];            //记录每一行皇后所在的位置
int vaildMatrixCount = 0;//记录有效的布局个数

void printResult() {  //输出结果
    vaildMatrixCount ++;
    for (int i = 0; i < N; i++) {
        int location = Queen[i];
        for (int j = 0; j < N; j ++) {
            printf("%s", j == location ? "🔴" : "⚪️");
        }
        printf("\n");
    }
    printf("\n");
}

bool checkVaildMatrix(int row, int location) {
    for (int i = 0; i < row; i++) {
        if (location == Queen[i]) //第row行和第i行的皇后在同一列，不符合条件
            return false;
        if ((i + Queen[i]) == (row + location) //第row行和第i行的皇后在同一对角线，不符合条件
            || (i - Queen[i]) == (row - location)) //第row行和第i行的皇后在另一条对角线上，不符合条件
            return false;
    }
    return true;
}

void backtrackingQueen(int row) {
    if (row == N) {// row == N表示前N行，即0至N-1行已经满足N皇后的条件，输出结果并结束回溯
        printResult();
        return;
    }
    for (int i = 0; i < N; i++) {//逐个尝试第row行的各个位置
        Queen[row] = i;
        if (checkVaildMatrix(row, i)) { //如果该行符合条件
            backtrackingQueen(row + 1); //进行下一行
        }
    }
}
```
调用的时候从`backtrackingQueen(0)`开始。

回溯的过程即是问题规模从n缩小到1或0的过程。当问题的规模是1或0时，问题的解往往有一个或者特定的几个。由这几个特定的结果向n的方向推广开来，得到k(n)个结果，其中符合条件的记为f(n)。

##### 例2.6：24点。若给出4个小于等于10的数，用加、减、乘、除(可加括号)使得这四个数的运算结果为24(其中每个数字只能用一次)，那么称这四个数字的组合是有效的24点组合。

整体：4个数字(a, b, c, d)<br>
第一步：算其中任意两个数字的和、差、商、积记为k<br>
__问题规模减少__<br>
整体：3个数字(k, c, d)<br>
第二步：再算其中任意两个数字的和、差、商、积记为l<br>
__问题规模减少__<br>
整体：2个数字(l, d)<br>
第三步：这两个数字的和、差、商、积记为m<br>
__问题规模减少到1__<br>
此时若m=24，那么这个计算过程是正确的<br>

```
bool isZero(double num) {
    if (fabs(num) < 0.000001)
        return true;
    return false;
}

bool is24Comb(double numbers[4], int count) {
    if (count == 1) {
        if (numbers[0] == 24) {
            return true;
        }
        return false;
    }
    double lessNumber[4] = {0.0};
    for (int i = 0; i < count - 1; i++) {
        double num1 = numbers[i];
        for (int j = i + 1; j < count; j ++) {//取出两个数
            double num2 = numbers[j];
            for (int k = 0, l = 0; k < count; k++) {
                if (k == i || k == j) {
                    continue;
                }
                lessNumber[l] = numbers[k];
                l ++;
            }
            lessNumber[count - 2] = num1 + num2;//剩余count - 1个数，其中最后一个是两个数运算的结果
            if (is24Comb(lessNumber, count -1))
                return true;
            lessNumber[count - 2] = num1 - num2;
            if (is24Comb(lessNumber, count -1))
                return true;
            lessNumber[count - 2] = num2 - num1;
            if (is24Comb(lessNumber, count -1))
                return true;
            lessNumber[count - 2] = num1 * num2;
            if (is24Comb(lessNumber, count -1))
                return true;
            if(!isZero(num2)) {
                lessNumber[count - 2] = num1 / num2;
                if (is24Comb(lessNumber, count - 1)) {
                    return true;
                }
            }
            if (!isZero(num1)) {
                lessNumber[count - 2] = num2 / num1;
                if (is24Comb(lessNumber, count - 1)) {
                    return true;
                }
            }
        }
    }
    return false;
}
```


##### 例2.7：波兰表达式求解，`3*(5-4)`的波兰式是`* 3 - 5 4`，已知逆波兰式求表达式的结果。
```
```
##### 递归总结
1. 把问题规模变小(一般采用分治的策略)，找到问题的初始规模
2. 局部到整体的演进关系
3. 第一步应该干什么？进行第一步(对局部问题求解的过程)后得到结果R(0)
	* R(0)对问题规模的影响(应当使问题规模变小)
	* R(0)对问题从局部到整体的演进关系的影响(应当不影响演进关系，递归式一直可用)
4. 递归操作一般流程是：
 1. 由递归基(初始条件)直接得到结果并返回
 2. 开始第一步操作，得到结果R(0)
 3. 进行第k步操作，得到结果R(k)，问题变成了[R(k), ..., n]
 4. 最后得到R(n)

#### 3.分治：把一个任务，分成形式和原任务相同，但规模更小的几个部分任务（通常是两个），分别完成，或只需要选一部分完成。然后再处理完成后的这一个或几个部分的结果，实现整个任务的完成。

##### 例3.1：归并排序

思路：数组的排序任务可以如下完成：

1. 把前一半排序，得到有序序列
2. 把后一半排序，得到有序序列
3. 把两个有序数列归并到一个新的有序数组，然后再拷贝回原数组，排序完成

```
void merger(int array[], int start, int mid, int end, int temp[]) {
    int l = start;
    int r = mid + 1;
    int pt = 0;
    while (l <= mid && r <= end) {
        if (array[l] > array[r]) {
            temp[pt] = array[r];
            r ++;
        } else {
            temp[pt] = array[l];
            l ++;
        }
        pt ++;
    }
    while (l <= mid) {
        temp[pt ++] = array[l ++];
    }
    while (r <= end) {
        temp[pt ++] = array[r ++];
    }
    for (int i = 0 ; i < end - start + 1; i++) {
        array[start + i] = temp[i];
    }
}

void mergerSort(int array[], int start, int end, int newArray[]) {
    if (start >= end) {
        return;
    }
    int mid = start + (end - start) / 2;      //把数组分成前后两段
    mergerSort(array, start, mid, newArray);  //把前半段排成有序数列
    mergerSort(array, mid + 1, end, newArray);//把后半段排成有序数列
    merger(array, start, mid, end, newArray); //合并
}
```

##### 例3.2：快速排序
思路：

1. 设k=a[0]，将k挪到合适的位置，使得比k小的元素都在k的左边，比k大的元素都在k的右边，和k相等的在k的左右出现均可；该过程可在O(n)的时间内完成。
2. 把k左边的部分快速排序。
3. 把k的右半部分快速排序。

对于步骤1：取k=a[0]=7

`i`<font color=white>`1``2``3``4``5``6``7``9`</font>`j`<br />
<font color=red>`7`</font>`2``5``6``9``0``1``3``4``8`<br />
从后往前，找到第一个小于k的数，进行交换（偶数次交换）<br>
`i`<font color=white>`1``2``3``4``5``6``7`</font>`j`<font color=white>`9`</font><br />
`4``2``5``6``9``0``1``3`<font color=red>`7`</font>`8`<br />
从前往后，找到第一个大于k的数，进行交换（奇数次交换）<br>
<font color=white>`0``1``2``3`</font>`i`<font color=white>`5``6``7`</font>`j`<font color=white>`9`</font><br />
`4``2``5``6`<font color=red>`7`</font>`0``1``3``9``8`<br />
然后再从后往前找，找到第一个小于k的数，进行交换<br />
<font color=white>`0``1``2``3`</font>`i`<font color=white>`5``6`</font>`j`<font color=white>`8``9`</font><br />
`4``2``5``6``3``0``1`<font color=red>`7`</font>`9``8`<br />
然后再从前往后找，直到i==j时，停止寻找。
<font color=white>`i``1``2``3``4``5``6`</font>`ij`<font color=white>`8``9`</font><br />
`4``2``5``6``3``0``1`<font color=red> `7`</font>`9``8`<br />
此时数字被分成3部分<br>
`{4, 2, 5, 6, 3, 0, 1}``7``{9, 8}`<br>
以分别对k=7所在的位置`i`(此时i==j)前面的部分[0, i-1]和后面部分[i+1, 9]进行排序就分别完成了步骤2、3

```
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
void quickSort(int array[], int start, int end) {
    if (start >= end) {
        return;
    }
    int l = start;
    int r = end;
    int key = array[start];
    while (l != r) {
        while (r > l && array[r] >= key) {
            r --;
        }
        swap(&array[l], &array[r]);
        while (l < r && array[l] <= key) {
            l ++;
        }
        swap(&array[l], &array[r]);
    }//此时，l == r，array[l] == array[r] == k
    quickSort(array, start, r - 1);
    quickSort(array, r + 1, end);
}
```

##### 例3.3：输出前M大的数
问题描述：已知N个数字的集合，统计其前M大的数并把这M个数按从大到小的顺序输出。

思路一：N个数字降序排列，按顺序输出前M个数字。<br/>
思路二：(其中的关键是在O(n)时间内把前M大的数移动到一端)

1. 把前M大的数都移动到数字的最右(左)边，
2. 然后对这M个数字进行排序。

```
void moveToRight(int array[], int start, int end, int count) {
    if ((end - start + 1) == count) {
        return;
    }
    int l = start;
    int r = end;
    int k = array[l];
    while (l != r) {
        while (r > l && array[r] >= k) {
            r --;
        }
        swap(&array[l], &array[r]);
        while (l < r && array[l] <= k) {
            l ++;
        }
        swap(&array[l], &array[r]);
    }
    int right = end - l + 1;
    if (right == count) {
        return;
    } else if (right > count) {
        moveToRight(array, l + 1, end, count);
    } else {
        moveToRight(array, start, l - 1, count - right);
    }
}
```
移动前M大的数到一端的时间复杂度分析：<br/>
T(n) = T(n/2) + a\*n 其中a\*n表示将n个数分成左右两边，右边的都比左边的大；T(n/2)表示在右边找出前m大的数所需数间<br>
T(n) = T(n/4) + a\*n/2 + a\*n<br/>
T(n) = T(n/8) + a\*n/4 + a\*n/2 + a\*n<br/>
......<br/>
T(n) = T(1) + ... + a\*n/b + a\*n/4 + a\*n/2 + a\*n<br/>
T(n) < 2\*a\*n = O(n)<br/>
快速排序时间复杂度分析：<br/>
T(n) = T(n/2) + T(n/2) + a\*n = 2\*T(n/2) + a\*n<br/>
T(n) = 2\*(2*T(n/4) + a\*n/2) + a\*n = 4\*T(n/4) + 2\*a\*n<br/>
T(n) = 2<sup>k</sup>\*T(n/2<sup>k</sup>) + k\*a\*n<br>
一直做到n/2<sup>k</sup> = 1，也即k = log<sub>2</sub>n<br/>
T(n) = n\*T(1) + a\*(log<sub>2</sub>n)\*n = O(nlogn)<br/> 
两者差了logn倍，原因在于“移动”只需处理一边，而“排序”两边都要处理。

##### 例3.4：求排列的逆序数
问题描述：1、2、...、n的排列：[a<sub>0</sub>, a<sub>1</sub>, a<sub>2</sub>, ... , a<sub>n-1</sub>]，若有存在j、k满足j\<k且a<sub>j</sub>>a<sub>k</sub>，那么称(a<sub>j</sub>>a<sub>k</sub>)是这个排列的一个逆序。例如排列[2, 1, 3]的逆序有(2, 3)、(1, 3)，该排列的逆序个数是2。先给定1、2、...、n的排列，求该排列的逆序的个数。

__解法一__：枚举的思想

```
int getInverseNumberCount(int array[], int start, int end) {
    int count = 0;
    for (int i = start; i < end ; i ++) {
        for (int j = i + 1; j < end + 1; j ++) {
            if (array[i] > array[j]) {
                count ++;
            }
        }
    }
    return count;
}
```
时间复杂度O(n<sup>2</sup>)

__解法一__：递归的思想<br>
排列[a, b, c, <font color=red>d</font>]的逆序总数可以分成两部分：逆序中含有d的和逆序中不含d的；其中后者即是排列[a, b, <font color=red>c</font>]的逆序总数，前者只要遍历除d外的其他元素即可。当排列中有一个元素时，逆序个数为0。

```
int backtrackingGetInverseNumberCount(int array[], int start, int end) {
    if (start >= end) {
        return 0;
    }
    int withLast = 0;
    for (int i = 0; i < end; i ++) {
        if (array[i] > array[end]) {
            withLast ++;
        }
    }
    return backtrackingGetInverseNumberCount(array, start, end - 1) + withLast;
}
```


__解法三__：采用分治的思想

```
int preToSuf(int array[], int start, int mid, int end, int temp[]) {
    int l = start;
    int r = mid + 1;
    int count = 0;
    int pt = 0;
    while (l <= mid && r <= end) {
        if (array[l] > array[r]) {
            temp[pt] = array[l];
            count += (end - r + 1);
            l ++;
        } else {//不考虑相等的情况
            temp[pt] = array[r];
            r ++;
        }
        pt ++;
    }
    while (l <= mid) {
        temp[pt++] = array[l++];
    }
    while (r <= end) {
        temp[pt++] = array[r++];
    }
    for (int i = 0; i < pt; i ++) {
        array[start + i] = temp[i];
    }
    return count;
}
int megerAndCount(int array[], int start, int end, int temp[]) {//数组array中从start到end区间中逆序的个数
    if (start >= end) {
        return 0;
    }
    int mid = start + (end - start) / 2;
    int preCount = megerAndCount(array, start, mid, temp); // 前半部逆序的总数
    int sufCount = megerAndCount(array, mid + 1, end, temp);   // 后半部逆序的总数
    int pre_suf = preToSuf(array, start, mid, end, temp);
    return preCount + sufCount + pre_suf;
}
```
通常来说，能采用分治策略的问题都能采用递归的策略解决；能采用递归的策略解决的问题，若各子问题可独立求解，且由子问题的解可推演出父问题的解，那么该问题应该是可以采用分治策略解决的。<br/>
递归针对最小的字问题进行解决，然后考虑子问题规模+1时的解决，最后直到N；分治的N个子问题(规模为1)独立解决，把N个结果分组再解决得到N/2(或N/a)个结果，直到聚合成变成1个整体。

##### 分治(分而治之)总结
1. 把问题的规模分成两部分或若干部分
2. 各个部分的求解互相独立，得到若干个解
3. 整体的解可由若干部分的解推演得到

### 算法设计策略与实例(下)
#### 4.动态规划
##### 例4.1：数字三角形
`3`<br/>
`7``1`<br/>
`5``2``8`<br/>
`4``9``2``6`<br/>
在上面的数字三角形中寻找一条从顶部到底部的路线，使得路径上所经历的数字之和最大。路径上的每一步都只能往右下方或正下方走。已知N层的数字三角形和对应的矩阵matrix[N][N]，求最大和即可，不必给出具体路径。

__解法一：__<br/>
问题的整体规模N层<br/>
问题的初始规模1层，把一层当成问题规模减1的单位<br/>
1层时f(1)=matrix[1][1]<br/>
2层时f(2)=Max(matrix[2][1] + f(1)[1], matrix[2][2] + f(1)[1])<br/>
...<br/>
若已知，第n-1层时f(n-1)=Max(f(n-1)[1], ..., f(n-1)[k], ..., f(n-1)[n-1])，其中f(n-1)[k]表示第n-1行第k个数，f(n-1)表示第n-1层所有路径<br/>
第n层f(n)=Max(a<sub>1</sub> + f(n-1)[1], a<sub>2</sub> + Max(f(n-1)[1], f(n-1)[2]), ..., a<sub>k</sub> + Max(f(n-1)[k-1], f(n-1)[k]), ..., a<sub>n</sub> + f(n-1)[n-1])<br>
即，从第一行起逐行向下相加，同一个位置取两个方向↘️⬇️上较大的那个，直到最后一行，取最后行中最大的一个。

```
#define MSize 4
int Matrix[MSize][MSize] = {
    {1, 0, 0, 0},
    {2, 3, 0, 0},
    {3, 4, 5, 0},
    {4, 5, 5, 6}
};
int getMaxPath(int k, int deep, int kArray[]) {//k(行数)：从1开始；deep(矩阵总深度)：从1开始，大于等于k；kArray：前k行所有较大路径的数组，初始的时候是deep个0
    if (k > deep) {
        int max = 0;
        int i = deep;
        while (i > 0) {
            if (kArray[i - 1] > max)
                max = kArray[i - 1];
            i --;
        }
        return max;
    }
    for (int i = k - 1; i >= 0; i --) {
        if (i == 0) {
            kArray[i] = kArray[i] + Matrix[k - 1][i];
        } else {
            kArray[i] = Matrix[k - 1][i] + MAX(kArray[i], kArray[i - 1]);
        }
    }
    return getMaxPath(k + 1, deep, kArray);
}
//调用
int array[4] = {0, 0, 0, 0};
int res = getMaxPath(1, 4, array);
```
时间复杂度O(n<sup>2</sup>)

__解法二：__<br/>
若考虑问题的整体规模N\*N<br/>
那么问题的初始规模1\*1，即矩阵中的一个数<br/>
对于规模2\*2，初始规模应该指数字<font color=red>`4`</font>，初始规模问题的解是已知的且固定不变，要求解的是`5`往下两个路径中那个大，即f(5)=5+Max(4, 9)<br/>
`5`<br/>
<font color=red>`4`</font>`9`<br/>
对于规模3\*3，即f(7)=7+Max(f(5), f(2))<br/>
`7`<br/>
`5``2`<br/>
`4``9``2`<br/>
由此可知要知道f(Matrix[i, j])，需知道f(Matrix[i+1, j])和f(Matrix[i+1, j+1])<br/>
`未知`<br/>
`计算``计算`<br/>
`已知``已知``已知`<br/>

```
int getMaxPathAt(int row, int column) {//row(行数)：从1开始；column(列数)：从1开始
    if (row == MSize) {
        return Matrix[MSize - 1][column -1];
    }
    int num = Matrix[row - 1][column -1];
    return num + MAX(getMaxPathAt(row + 1, column), getMaxPathAt(row + 1, column + 1));
}
```
时间复杂度O(n)=2<sup>n</sup>，因为该递归的解决方法存在大量的重复计算

__解法三：针对解放二借助辅助空间存储已经计算过的f(Matrix[i, j])，从而避免重复计算__<br/>

```
int MaxSum[MSize][MSize] = {
    {-1, -1, -1, -1},
    {-1, -1, -1, -1},
    {-1, -1, -1, -1},
    {-1, -1, -1, -1}
};
int getMaxPathAt_2(int row, int column) {
    if (MaxSum[row - 1][column -1] != -1) {
        return MaxSum[row - 1][column -1];
    }
    if (row == MSize) {
        MaxSum[row - 1][column -1] = Matrix[MSize - 1][column -1];
    }
    int num = Matrix[row - 1][column -1];
    MaxSum[row - 1][column -1] = num + MAX(getMaxPathAt(row + 1, column), getMaxPathAt(row + 1, column + 1));
    return MaxSum[row - 1][column -1];
}
```

##### 例4.2：最长上升子序列
问题描述：N个数组成的序列[a<sub>1</sub>, a<sub>2</sub>, ... , a<sub>N</sub>]，若存在一个子序列[a<sub>x1</sub>, a<sub>x2</sub>, ... , a<sub>xn</sub>]，使得任意的xi < xj都有a<sub>xi</sub> < a<sub>xj</sub>，那么这个序列就是上升子序列，求所有自序列中最长的长度。

子问题：求序列中的前k个元素的最长子序列的长度为R(k)？<br/>
若已知R(k)，由R(k)和序列中的第k+1个元素我们无法得到R(k+1)，即R(k+1)不仅与R(k)相关，还与如何得到R(k)的过程有关。不符合无后效性。

子问题：求以a<sub>k</sub>为终点的最长上升子序列的长度R(k)?<br/>
若已知R(1)、R(2)...R(k)它们的终点a<sub>1</sub>、a<sub>2</sub>...a<sub>k</sub>，若想以a<sub>k+1</sub>结尾，需在前k中找出一个结尾小于a<sub>k+1</sub>的a<sub>x</sub>，且最长的序列，那么R(k+1) = R(x) + 1，若找不到则R(k+1) = 1。

`1``7``3``5``9``4``8`<br/>

|终点|最长上升子序列|长度|
|:--:|:--:|:--:|
|`1`|`1`|1|
|`7`|`1``7`|2|
|`3`|`1``3`|2|
|`5`|`1``3``5`|3|
|`9`|`1``3``5``9`|4|
|`4`|`1``3``4`|3|
|`8`|`1``3``4``8`|4|
对于以`8`结尾的，在前面找结尾小于8且最长的一个即可，如`1``3``4`，那么新序列是`1``3``4``8`，长度是R(6)=R(5)+1=4，且同样以`8`结尾的序列`1``3``5``8`对后续无影响。

```
int getLIS(int array[], int start, int end, int lenArr[]) {
    for (int i = start; i <= end; i ++) {
        int lastNum = array[i];
        int length = 0;
        for (int j = i - 1; j >= start; j --) {
            if (lastNum > array[j] && lenArr[j - start] > length) {
                length = lenArr[j - start];
            }
        }
        length += 1;//加上自身
        lenArr[i - start] = length;
    }
    int max = lenArr[0];
    for (int i = 1; i <= end - start; i ++) {
        if (lenArr[i] > max) {
            max = lenArr[i];
        }
    }
    return max;
}
```

[时间复杂度为O(nlogn)的算法](https://www.cnblogs.com/wxjor/p/5524447.html)

使用动态规划解题的一般思路：

1. 把原问题分解为子问题
 * 把原问题分解为若干个子问题，子问题和原问题形式相同或类似，只不过规模变小了。子问题都解决，原问题即解决。
 * 子问题的解一旦求出就会被保存，所以每个子问题只需求解一次。
2. 确定状态
 * 在用动态规划解题时，我们往往将和子问题相关的各个变量的一组取值，成之为一个<font color=red>状态</font>。一个<font color=red>状态</font>对应于一个或多个字问题，所谓某个<font color=red>状态</font>下的<font color=red>值</font>，就是这个<font color=red>状态</font>所对应的子问题的解。
3. 确定一些初始化状态(边界状态)的值
4. 确定状态装一方程
 * 定义出什么是<font color=red>状态</font>，以及在该<font color=red>状态</font>下的<font color=red>值</font>后，就要找出不同的状态之间如何转移——即如何从一个或多个<font color=red>值</font>已知的<font color=red>状态</font>，求出另一个<font color=red>状态</font>的<font color=red>值</font>（__人人为我__递推型）。状态的迁移可以用递推公式表示，此递推公式也可被称作<font color=red>状态转移方程</font>。
5. 能用动态解决的问题的特点
 * 问题具有最优子结构的性质。如果问题的最优解所包含的子问题的解也是最优的，我们就称问题具有最优子结构性质。
 * 无后效性。当前的若干个状态值一旦确定，则此后过程的演变就只和这若干个状态的值有关，和之前是采取哪种手段或经过那条路径演变到当前的这若干个状态，没有关系。

动态规划的常见两种形式：

1. 递推：由已知1，通过循环，推出未知N
2. 递归：假设我们已经知道状态k下的值R(k)，那么进行何种操作F才能得到k的下一个状态n的值R(n)，R(k)--<sup>F</sup>--> R(n)

##### 例4.3：最长公共子序列
问题描述：给出两个字符串，求出这样的一个最长的公共子序列的长度：子序列中的每个字符都能在两个原串中找到，而且每个字符的先后顺序和原串中的先后循序一致。

确定<font color=red>状态</font>：<br/>
对于两个串s1、s2，设MaxLen(i, j)表示：s1的左边i个字符形成的子串，与s2左边的j个字符形成的子串的最长公共子序列的长度(i、j从0开始计算)<br/>
假定len1 = strlen(s1)、len2 = strlen(s2)，那么题目要求就是求MaxLen(len1, len2)？<br/>
确定<font color=red>边界</font>：<br/>
MaxLen(n, 0) = 0，其中n从0到len1<br/>
MaxLen(0, n) = 0，其中n从0到len2<br/>
确定<font color=red>状态转移方程</font>：<br/>
MaxLen(i, j) = MaxLen(i - 1, j - 1) + 1; 当s1[i - 1] == s2[i - j]<br/>
MaxLen(i, j) = Max(MaxLen(i, j - 1), MaxLen(i - 1, j)); 当s1[i - 1] != s2[i - j]<br/>
[这里有证明第二个状态转移方程正确性的方法](https://www.icourse163.org/learn/PKU-1001894005?tid=1002445041#/learn/content?type=detail&id=1003305232&cid=1003960758&replay=true)

递归方法：

```
int getLCS(char s1[], int i, char s2[], int j) {
    if (i == 0 || j == 0) {
        return 0;
    }
    if (s1[i - 1] == s2[j - 1]) {
        return getLCS(s1, i - 1, s2, j - 1) + 1;
    } else {
        return MAX(getLCS(s1, i, s2, j - 1), getLCS(s1, i - 1, s2, j));
    }
}
//调用
char s1[] = {'a', 'b', 'c', 'f', 'b', 'c', 'e'};
char s2[] = {'a', 'b', 'f', 'c', 'a', 'b'};
int res = getLCS(s1, 7, s2, 6);
```

递推方法：
考虑状态转移方程中的四个状态的值：MaxLen(i - 1, j - 1)、MaxLen(i - 1, j)、MaxLen(i - 1, j)、MaxLen(i, j)，正好是矩阵中相邻的一个2\*2的子矩阵<br/>
`MaxLen(i-1, j-1)``MaxLen(i-1, j)`<br/>
`MaxLen(i-1, j)` `MaxLen(i, j)`<br/>
由此可知__右下__角的值等于__左上__角的值+1，或__正上__和__正左__边中大的那个<br>
`0``a``b``c``f``b``c``e`<br/>
`a`<font color=red>`1``1``1``1``1``1``1`</font><br/>
`b`<font color=red>`1``2``2``2``2``2``2`</font><br/>
`f`<font color=red>`1``2``2``3``3``3``3`</font><br/>
`c`<font color=red>`1``2``3``3``3``4``4`</font><br/>
`a`<font color=red>`1``2``3``3``3``4``4`</font><br/>
`b`<font color=red>`1``2``3``3``4``4``4`</font><br/>

```
int lengthMatrix[101][101];
int getLCS_loop(char s1[], int len1, char s2[], int len2) {
    for (int i = 0; i <= len1; i ++)
        lengthMatrix[i][0] = 0;
    for (int j = 0; j <= len2; j ++)
        lengthMatrix[0][j] = 0;
    for (int i = 1; i <= len1; i ++) {
        for (int j = 1; j <= len2; j ++) {
            if (s1[i - 1] == s2[j - 1]) {
                lengthMatrix[i][j] = lengthMatrix[i - 1][j - 1] + 1;
            } else {
                lengthMatrix[i][j] = MAX(lengthMatrix[i - 1][j], lengthMatrix[i][j - 1]) ;
            }
        }
    }
    return lengthMatrix[len1][len2];
}
```

##### 例4.4：神奇的口袋
问题描述：有一个神奇的口袋，总的容积是40，用这个口袋可以变出一些物品，这些物品的总体积必须是40。John现在有n个想要得到的物品，每个物品的体积分别是a<sub>1</sub>、a<sub>2</sub>、...、a<sub>n</sub>。John可以从这些物品中选择一些，如果选出的物体的总体积是40，那么利用这个神奇的口袋，John就可以得到这些物品。现在的问题是，John有多少种不同的选择物品的方式。


考虑前k个物品的放法，对于第k个物品可以选择放入口袋或不放入口袋，那么组成体积和为w的方法数可以定义为__放入k的方法数__与__不放入k的方法__之和；由此可知递推式：f(w, k) = f(w, k - 1) + f(w - a[k], k - 1)<br/>


```
int a[21];//物品的体积，a[0] = 0占位
int getKindCount(int w, int k) {//取前k个组成体积w的方法数
    if (w == 0) return 1;
    if (k <= 0) return 0;
    return getKindCount(w, k - 1) + getKindCount(w - a[k], k - 1);
}
```

考虑递推式若以重量w为横坐标，物品可取范围k为纵坐标，那么：
`f(w-a[k], k-1)``...``f(w, k-1)`<br/>
<font color=white>`...................`</font>`f(w, k)`<br/>
元素(x, y)的值等于__正上的值__ + __正上左边距离为a[k]的值__<br/>

<font color=white>`W``K`</font>`0``1``2``3``4``5``6``7``8``9``<体积`<br/>
<font color=blue>`0`</font>`0`<font color=red>`1``0``0``0``0``0``0``0``0``0`</font><br/>
<font color=blue>`2`</font>`1`<font color=red>`1``0``1``0``0``0``0``0``0``0`</font><br/>
<font color=blue>`3`</font>`2`<font color=red>`1``0``1``1``0``1``0``0``0``0`</font><br/>
<font color=blue>`5`</font>`3`<font color=red>`1``0``1``1``0``2``0``1``1``0`</font><br/>
<font color=blue>`7`</font>`4`<font color=red>`1``0``1``1``0``2``0``2``1``1`</font><br/>
<font color=blue>`4`</font>`5`<font color=red>`1``0``1``1``1``2``1``3``1``3`</font><br/>
<font color=blue>`6`</font>`6`<font color=red>`1``0``1``1``1``2``2``3``2``4`</font><br/>
<font color=blue>`1`</font>`7`<font color=red>`1``1``1``2``2``3``4``5``5``6`</font><br/>

```
#define W 9                       //总的体积W
#define GoodAmount 7              //物品的数量
int K_SIZE[GoodAmount + 1][W + 1];//存放结果的矩阵
int getMatrixResult(int w, int k, int kArray[]) {
    K_SIZE[0][0] = 1;
    for (int j = 1; j <= w; j ++) {
        K_SIZE[0][j] = 0;
    }
    for (int i = 1; i <= k; i ++) {
        for (int j = 0; j <= w; j ++) {
            K_SIZE[i][j] = K_SIZE[i - 1][j];
            if (j - kArray[i] >= 0) {
                K_SIZE[i][j] += K_SIZE[i - 1][j - kArray[i]];
            }
        }
    }
    for (int i = 0; i <= k; i ++) {
        for (int j = 0; j <= w; j ++) {
            printf("%d", K_SIZE[i][j]);
        }
        printf("\n");
    }
    return K_SIZE[k][w];
}
// 调用
int array[8] ={0, 2, 3, 5, 7, 4, 6, 1};
int result = getMatrixResult(W, GoodAmount, array);
```

##### 例4.5：0-1背包问题

有N件物品和一个容积为M的背包。第i件物品的体积w<sub>i</sub>、价值d<sub>i</sub>。求解将哪些物品放入背包使得价值总和最大。每件物品只有一件，可以选择放或者不放。其中N≤3500、M≤13000。

确定状态：当问题规模变小时那么条件相应的也要减小。此处就是物品的个数N减少的话，问题规模会变小；背包的容积M减少的话，问题规模会变小。而一个物品的体积w<sub>i</sub>和价值d<sub>i</sub>只会对最终的结果有印象，不会使问题的规模减小。那么一般情况下引起问题规模变小的组合(N, M)就是问题的状态(状态一般是要出现在函数的参数中的)，问题的解记为F(N, M)即取前N个物品，使得体积不大于M的最大价值的和。<br/>
确定操作：操作会引起状态的变化，也就是递归函数中由编程语言描述的过程。对于第N件物品是跳过，还是放入背包，这两种操作会产生两种结果，那么价值最大的就是两种操作产生的结果中最大的那么个。跳过使得N的规模减少为N-1，M的规模不变；放入使得使得N的规模减少为N-1，M的规模减小为M-w<sub>N</sub>。<br/>
确定状态转移方程：由操作引起的变化可知，操作前的F(N, M) = Max(F(N-1, M), F(N-1, M-w<sub>N</sub>) + d<sub>N</sub>)<br/>
确定边界：重复操作，当剩余1件物品时若该物品的体积w<sub>1</sub>小于背包剩余的容积j，那么F(1, j)=d<sub>1</sub>，否者F(1, j)=0；还有就是F(i, 0)=0，F(0, j)=0。<br/>

递归：

```
int array_W[] = {0, 10, 3, 8, 7, 6, 5, 4};
int array_D[] = {0, 7, 5, 9, 6, 3, 2, 4};
int getMaxSum(int n, int m) {
    if(n < 1 || m < 1)
        return 0;		
    if (n == 1) {
        if (array_W[n] <= m)
            return array_D[n];
        return 0;
    }
    return MAX(getMaxSum(n - 1, m), getMaxSum(n - 1, m - array_W[n]) + array_D[n]);
}
```

递推：用滚动数组代替举证，前提是下一行(列)的值仅跟前一行(列)的值相关，且下一行的第i个值仅跟前一行第i个之前或之后(包含第i个)的值有关。

```
int N,M;
struct Item {
	int w;
	int d;
};
Item items[3500];
int volume[13000];
void F(int N, int M) {
	for(int j = 0; j <= M; ++ j)
		if( items[1].w <= j )
			volume[j] = items[1].d;
		else
			volume[j] = 0;
	for(int i = 2; i <= N; ++i) {
		for( int j = M; j >= 0; --j) {
			if(items[i].w <= j) 
				volume[j] = MAX(volume[j], volume[j-items[i].w] + items[i].d);
		} 
	}
}
```

#### 5.贪心算法
每一步行动总是按某种指标选取最优的操作来进行，该指标只看眼前，并不考虑以后可能造成的影响。贪心算法需要证明其正确性。

##### 例5.1：圣诞老人的礼物(Santa Clau's Gifts)
问题描述：圣诞节来临了，圣诞老人准备分发糖果，现在有多箱不同的糖果，每箱糖果有自己的价值和重量，每箱糖果都可以拆分成任意散装组合带走。圣诞老人的驯鹿雪橇只能装下重量W的糖果，请问圣诞老人最多能带走多大价值的糖果。

1. 先按糖果的单价(价值/重量)从大到小排序；
2. 从前往后，每次取足够多的当前单价的糖果，直到总重量等于W，或把所有的糖果取完。

SantaCluasGifts.hpp

```
typedef struct Gift { //糖果结构体
    int worth;        //总价值
    int weight;       //总重量
}Gift;

#define GIFT_KIND_COUNT 4    //糖果有多少种
#define SLED_CAPACITY 15     //雪橇能容纳的总重量

extern Gift test_gift_array[GIFT_KIND_COUNT]; //所有种类的糖果

void quick_sort(Gift array[], int start, int end); //快速排序
float max_worth_full_sled(Gift array[], int kindAmount, int sledCapacity); //求解
```
~.cpp

```
Gift test_gift_array[] = {
    {100, 4},//25
    {412, 8},//51.5
    {266, 7},//35
    {591, 2},//295.5
};

void swap(Gift & a, Gift & b) {
    Gift temp = a;
    a = b;
    b = temp;
}

bool is_expensive(Gift & a, Gift & b) {
    if ((float(a.worth) / a.weight - float(b.worth) / b.weight) > 1e-6) {
        return true;
    }
    return false;
}

void quick_sort(Gift array[], int start, int end) {
    if (start >= end) {
        return;
    }
    int i = start;
    int j = end;
    Gift k = array[i];
    while (i <= j) {
        while (j >= i && !is_expensive(array[j], k)) {
            j --;
        }
        swap(array[i], array[j]);
        while (i <= j && is_expensive(array[i], k)) {
            i ++;
        }
        swap(array[i], array[j]);
    }
    quick_sort(array, start, i - 1);
    quick_sort(array, i + 1, end);
}

float max_worth_full_sled(Gift candyArray[], int kindAmount, int sledCapacity) {
    quick_sort(candyArray, 0, kindAmount - 1);
    for (int i = 0; i < kindAmount; i ++) {
        printf("%d, %d\n", candyArray[i].worth, candyArray[i].weight);
    }
    int i = 0;
    int remainCapacity = sledCapacity;
    float maxWorth = 0.0f;
    while (i < kindAmount && remainCapacity > 0) {
        if (candyArray[i].weight <= remainCapacity) {
            maxWorth += float(candyArray[i].worth);
            remainCapacity -= candyArray[i].weight;
        } else {
            maxWorth += float(candyArray[i].worth) / candyArray[i].weight * remainCapacity;
            remainCapacity = 0;
        }
    }
    return maxWorth;
}

```

##### 例5.2：电影节(Filmfest)
问题描述：大学生电影节在Shirley的学校举办！这天学校各地放了多部电影。给定每部电影的放映时间区间，区间重叠的电影不可能同时看(但可以端点是重合)，问Shirley最多可以看 多少部电影。

1. 按结束时间升序排列所有电影；
2. 从前往后，依次看结束时间尽可能早的电影。

```
#include <algorithm>
typedef struct Movie {
    int start;
    int end;
    bool operator<(const Movie &m) const {
        return end < m.end;
    }
}Movie;
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
```

##### 例5.3：分配畜栏(Stall Reservations)
问题描述：有N头牛(1≤N≤50000)要挤奶，给定每头牛挤奶的时间区间[A, B]，其中1≤A≤B≤1000000，且A、B为整数。牛需要呆在畜栏里才能挤奶。一个畜栏同一时间只能容纳一头牛。问至少需要多少个畜栏，才能完成全部挤奶工作，以及每头牛都放哪个畜栏里(Special judged)。去同一个畜栏的两头牛，它们挤奶的时间区间在端点也不能重合。

StallReservations.hpp 

```
typedef struct Cow {
    int start;
    int end;
    int No;
    int stallNo;
    bool operator<(const Cow &c) const {
        return start < c.start;
    }
}Cow;
typedef struct Stall {
    int end;
    int No;
    bool operator<(Stall const &s) const {
        return end > s.end;
    }
    Stall(int e, int n):end(e),No(n) {}
}Stall;
extern Cow all_cow_array[10];
int min_stall_reservations(Cow cows[], int amount);
```
~.cpp

```
#include <algorithm>
#include <queue>
#define NO_START_VALUE 1000
Cow all_cow_array[10] = {
    {1, 2, NO_START_VALUE + 1, -1},
    {1, 3, NO_START_VALUE + 2, -1},
    {2, 4, NO_START_VALUE + 3, -1},
    {2, 4, NO_START_VALUE + 4, -1},
    {3, 7, NO_START_VALUE + 5, -1},
    {1, 5, NO_START_VALUE + 6, -1},
    {6, 8, NO_START_VALUE + 7, -1},
    {4, 9, NO_START_VALUE + 8, -1},
    {5, 8, NO_START_VALUE + 9, -1},
    {2, 3, NO_START_VALUE + 10, -1},
};
int min_stall_reservations(Cow cows[], int amount) {
    std::sort(cows, cows + amount);
    std::priority_queue<Stall> pq;
    int index = 0;
    while (index < amount) {
        Cow &cow = cows[index];
        if (pq.empty()) {
            Stall s = {cow.end, int(pq.size()) + 1};
            pq.push(s);
            cow.stallNo = s.No;
        } else {
            Stall stall = pq.top();
            if (stall.end < cow.start) {
                cow.stallNo = stall.No;
                pq.pop();
                pq.push(Stall(cow.end, stall.No));
            } else {
                Stall s = {cow.end, int(pq.size()) + 1};
                pq.push(s);
                cow.stallNo = s.No;
            }
        }
        index ++;
    }
    return int(pq.size());
}
```

##### 例5.4：放置雷达(Radar Installation)
问题描述：x轴是海岸线，x轴上方是海洋。海洋中有n(1≤n≤1000)个岛屿，可以看作点。给定每个岛屿的坐标(x, y)，其中x、y都是整数。当一个雷达(可以看作点)到岛屿的距离不超过d(整数)，则认为该雷达覆盖了该岛屿。雷达只能放在x轴上。问至少需要多少个雷达才可以覆盖全部岛屿。

分析：对于一个岛屿P，以其坐标(x, y)为圆心，d为半径作圆，圆与x轴相交与两点(Ps, 0)，(Pe, 0)。若这两给点确实存在，且Ps≤Pe，那么能覆盖岛屿P的雷达的区间就是[Ps, Pe]；否者，无论雷达安放在哪儿都不能覆盖到岛屿P。<br/>
模型转换：由分析可把二维问题转换成一维问题。对于n个岛屿，对应n个区间[P1s, P1e]，...，[Pis, Pie]，...，[Pns，Pne]。需要k个数，使得任意的区间[Pis, Pie]总能在这k个数中找到一个落在该区间内。求k的最小值。<br/>
__使用贪心策略分析问题时同样可以从最小的规模开始__：

1. 当只有1个区间[P1s, P1e]时，Min(k)=1，Radar的x轴坐标P1x≤Rx≤P1e
2. 2个区间[P1s, P1e]、[P2s, P2e]。若两个区间有交集[P2s, P1e]，那么只需1个Radar。不防假设Rx=P2s，即雷达处于第二个区间的起始点上。若两个区间没有交集那么需要2个Radar。
3. 3个区间按起始点升序排序[P1s, P1e]、[P2s, P2e]、[P3s, P3e]，若3个区间有公共子集，那么需1个雷达，且Rx=P3s。否者参照#2。

由此可以得到一个结论：如果一个雷达同时覆盖多个区间，那么把这么多个区间按起点坐标从小到大排序。则最后一个区间的起点，就能覆盖所有区域。根据这个结论就可以只挑区间的起点放置雷达了。

贪心算法：

1. 将所有区间按照起点从小到大排序，并编号0～(n-1)
2. 依次考察每个区间的起点，看要不要在那放雷达。开始，所有区间都没有被覆盖，所以目前编号最小的未被覆盖的区间的编号fistNoConverd=0
3. 考察一个区间i的起点x<sub>i</sub>的时候，要看从fistNoConverd到区间i-1中是否存在某个区间c没有被x<sub>i</sub>覆盖。如果没有这样的c，则先不急于在x<sub>i</sub>放雷法，接着往下看。如果有，那么c的终点肯定在x<sub>i</sub>的左边，因此不可能用同一个雷达覆盖c和i。即能覆盖c的点，已经不可能覆盖后面的i以及后面的区间了。因此为了覆盖c，必须放一个雷达了，放在区间i-1的起点即可覆盖所有从fistNoConverd到i-1的区间。因为当初考察i-1的起点z的时候，并没有发现z覆盖了从fistNoConverd到i-2之间的任何一个区间
4. 放完雷法后，将fistNoConverd改成i，再做下去。

证明贪心算法的正确性：替换法，不用贪心法得到的最佳雷达安放坐标序列X={x1，x2...}，贪心法得到的序列Y={y1，y2...}。

RadarInstallation.hpp

```
typedef struct Island {
    int x;
    int y;
}Island;
typedef struct Interval {
    float start;
    float end;
    bool operator<(const Interval &i) const {
        return start < i.start;
    }
}Interval;
#define D 50
extern Island text_all_island_positions[10];
extern Interval island_corresponding_interval[10];
extern float radar_x[10];
int min_radar_amount(Island array[], int amount, Interval tempArray[]);
```

~.cpp

```
Island text_all_island_positions[10] = {
    {-50, 45},
    {-40, 38},
    {-35, 39},
    {-25, 19},
    {0, 26},
    {70, 28},
    {48, 48},
    {52, 36},
    {4, 47},
    {330, 37},
};
int min_radar_amount(Island array[], int amount, Interval tempArray[]) {
    int index = 0;
    while (index < amount) {
        Island &island = array[index];
        float distance = sqrt(D * D - island.y * island.y);
        Interval &interval = tempArray[index];
        interval.start = float(island.x) - distance;
        interval.end = float(island.x) + distance;
        index ++;
    }
    std::sort(tempArray, tempArray + amount);
    int min = 0;
    float start = tempArray[0].start;
    float end = tempArray[0].end;
    index = 1;
    while (index < amount) {
        Interval &interval = tempArray[index];
        if (interval.start <= end) {
            start = interval.start;
            end = std::min(end, interval.end);
        } else {
            radar_x[min] = tempArray[index - 1].start;
            min += 1;
            start = interval.start;
            end = interval.end;
        }
        index ++;
    }
    radar_x[min] = tempArray[index - 1].start;
    min += 1;
    return min;
}
```

##### 例5.5：钓鱼(Gone Fishing)
问题描述：有n(2≤n≤25)个湖从左到右一字排开。从第i个湖走到第i+1个湖要耗时t[i]个时间片(每个时间片5分钟)。John有h(1≤h≤16)个小时可以用这些湖钓鱼(包括湖间行走的时间)。在每个湖待的时间必须是整数个时间片或0。就算钓不到鱼了，也可以在湖边待着。对于湖i，John在那里的第一个时间片可以钓到鱼f(i)条，且后续的每个时间片能钓到的鱼数量都比上一个时间片少d(i)条。注意John只能从第一个湖出发，从左往右，不能回头。最后John要停在哪里都可以。问John最多能钓多少条鱼。输出钓鱼方案，即在每个湖各待多长时间，如果存在多种方案，则优先选择在第一个湖待时间最长的，如果还有多种，则优先选择在第二个湖待的时间最长的...

分析：问题的难点在于，走路的时间可多可少，不知道到底该花多长时间纯钓鱼才最好。(可能有好的湖在很右边)<br/>
解决：枚举最终停下来的湖，将方案分成n类。每类方案的走路时间就是确定的。在每类方案里找最优解，然后再优中选优。<br/>
贪心策略：在确定停下来的湖是x的情况下，假定纯钓鱼的时间是k个时间片。用三元组(F, i, j)1≤i≤x，1≤j≤k表示湖i的第j个时间片能够钓的鱼的数目是F。将所有的(F, i, j)共x\*k个，按F的值从大到小排序，选前k个，就构成了最佳的钓鱼方案。

对于x=3，k=4

|湖编号|1|2|3|
|:--:|:--:|:--:|:--:|
|时间片#1|<font color=red>18|<font color=red>17|<font color=red>27|
|时间片#2|10|<font color=red>14|7|
|时间片#3|2|11|0|
|时间片#4|0|8|0|


```
typedef struct Lake {
    int No;
    int t;
    int f;
    int d;
}Lake;

typedef struct Slice {
    int F;
    int lakeNo;
    int sliceNum;
    bool operator<(const Slice &s) const {
        if(F == s.F) {
            return lakeNo < s.lakeNo;
        }
        return F > s.F;
    }
}Slice;

#define HOUR 4
#define LAKE_AMOUNT 6

extern Lake test_all_lake[LAKE_AMOUNT];
extern Slice all_slice_temp[HOUR * 12 * LAKE_AMOUNT];
extern Slice all_slice_result[HOUR * 12 * LAKE_AMOUNT];

int max_fish_amount(Lake array[], int amount, int hour);
```

```
Lake test_all_lake[LAKE_AMOUNT] = {
    {1, 0, 20, 2},
    {2, 5, 30, 3},
    {3, 3, 25, 2},
    {4, 1, 20, 2},
    {5, 4, 30, 3},
    {6, 6, 25, 2},
};

Slice all_slice_temp[HOUR * 12 * LAKE_AMOUNT] = {
    {0, 0, 0},
};
Slice all_slice_result[HOUR * 12 * LAKE_AMOUNT] = {
    {0, 0, 0},
};



int max_fish_stop_at(Lake array[], int index, int allHour, int &fishSliceAmount) {
    int amount = allHour * 12;
    for (int i = 0; i <= index; i ++) {
        amount -= array[i].t;
    }
    for (int i = 0; i <= index; i ++) {
        Lake &lake = array[i];
        for (int j = 0; j < amount; j ++) {
            Slice &sli = all_slice_temp[index * amount + j];
            sli.lakeNo = lake.No;
            sli.sliceNum = j + 1;
            sli.F = lake.f - lake.d * j;
            sli.F = sli.F > 0 ? sli.F : 0;
        }
    }
    std::sort(all_slice_temp, all_slice_temp + amount * (index + 1));
    
    int fish = 0;
    for (int i = 0; i < amount; i ++) {
        Slice &sli = all_slice_temp[i];
        fish += sli.F;
    }
    fishSliceAmount = amount;
    return fish;
}

bool aggregationByLakeNo(Slice &s1, Slice &s2) {
    if (s1.lakeNo == s2.lakeNo) {
        return s1.sliceNum < s2.sliceNum;
    }
    return s1.lakeNo < s2.lakeNo;
}

int max_fish_amount(Lake array[], int amount, int hour) {
    int max = 0;
    int fishSliceAmount = 0;
    int index = 0;
    while (index < amount) {
        int time = 0;
        int fishAtIndex = max_fish_stop_at(array, index, hour, time);
        if (max < fishAtIndex) {
            max = fishAtIndex;
            fishSliceAmount = time;
            for (int i = 0; i < fishSliceAmount; i ++) {
                all_slice_result[i] = all_slice_temp[i];
            }
        }
        index ++;
    }
    std::sort(all_slice_result, all_slice_result + fishSliceAmount, aggregationByLakeNo);
    for (int i = 0; i < fishSliceAmount; i ++) {
        std::cout << all_slice_result[i].lakeNo << ' ' << all_slice_result[i].sliceNum << ' ' << all_slice_result[i].F << '\n';
    }
    return max;
}
```