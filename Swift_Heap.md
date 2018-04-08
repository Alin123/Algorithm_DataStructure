### 实现一个Swift堆
让我们开始编码吧！
首先创建一个Swift Playground，并且把接下来的结构体声明添加进去：

```
struct Heap<Element> {
    var elements: [Element]
    let priorityFunction: (Element, Element) ->Bool
    //TODO:优先级队列函数
    //TODO:辅助函数
}
```

你已经声明了一个叫做Heap的结构体。语法声明这是一个通用结构，允许它在调用的方法推断自己的类型信息。这个堆有两个属性：Element类型的数组，和一个优先级函数。这个函数接收两个元素，并可当第一个元素比第二个元素有较高优先级的时候返回true。<br />
你也为优先级队列函数预留了一些地方————添加一个新的元素和移除最高优先级的元素；也为辅助函数预留一些地方，以帮助你的代码清晰和可读。<br />
### 简单的函数
这一节的代码片段都是小的、独立的计算属性或函数。移除优先级队列函数的TODO描述，并用一下代码代替

```
var isEmpty: Bool {
    return elements.isEmpty
}
var count: Int {
    return elements.count
}
```
你可能在使用数组或队列数据结构中认出了这些属性的名字。如果elements数组是空的那么Heap堆也是空的，并且它的元素个数也是数组的元素个数。在接下来的代码中我们需要知道有多少元素在堆里面。<br />
在连个计算属性下面添加这个函数：

```
func peek() -> Element? {
    return elements.first
}
```
你将对这种定义熟悉如果你使用过Queue队列的话。它所做的一切就是返回数组中的第一个元素————这允许调用者获取到堆中最高优先级的元素。<br />
现在移除辅助函数的TODO描述，并且用这四个函数代替：

```
func isRoot(_ index: Int) -> Bool {
    return index == 0
}
    
func leftChildIndex(of index: Int) -> Int {
    return index * 2 + 1
}
    
func rightChildIndex(of index: Int) -> Int {
    return index * 2 + 2
}
    
func parentIndex(of index: Int) -> Int {
    return (index - 1) >> 1
}
```
这四个函数全都讲的是计算数组中子节点和父节点的秩的公式，隐藏他们的实现细节会使得调用时可读性增强。你可能注意到计算子节点秩的公式仅告诉你左右子节点的秩应该是多少。他们没有用可选类型或者抛出错误去表明这个堆可能太小了以至于没有这些秩对应的元素。我们需要记住这一点。<br />
你可能也注意到因为左右子节点秩的计算公式，左子节点有奇数的秩，右子节点有偶数的秩。然而，parentIndex函数没有试图判断index参数是一个左孩子还是右孩子，它仅整数的除法得到结果。
### 比较优先级

理论上，我们会多次的比较父节点或者孩子节点的元素的优先级。在这一节我们将明确指出一个节点及其子节点中哪个优先级最高。<br />
在parentIndex函数下面添加这个方法：

```
func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
    return priorityFunction(elements[firstIndex], elements[secondIndex])
}
```
这个辅助函数是优先级计算属性的比较器。它接受两个秩，并且当第一个秩所对应的元素有较高优先级的时候返回true。<br />
在它的帮助下我们可以写其他两个辅助的比较函数，现在就让我们写在isHigherPriority函数下面吧！

```
func highestPriority(of parentIndex: Int, and childIndex: Int) -> Int {
    guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
        else {
            return parentIndex
    }
    return childIndex
}
func highestPriority(for parent: Int) -> Int {
    return highestPriority(of: highestPriority(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
}
```
让我们重新看一下这两段代码。第一个假设父节点在数组中有一个有效的秩，如果子节点在数组中有一个有效的秩，那么就比较在相应秩的节点的优先级，并且返回一个有效的、更高优先级的节点的秩。第二个也假设父节点的秩是有效的，并且比较两个左右孩子——如果存在的话。返回三者中优先级最高的秩。<br />    
最后一个辅助函数是另外一个交换函数，并且它是唯一一个改变堆结构的函数。

```
mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
    guard firstIndex != secondIndex else {
        return
    }
    elements.swapAt(firstIndex, secondIndex)
}
```
这个函数接受两个秩参数，并且交换两个秩所对应的元素。因为当调用者试图交换两个有相同秩的元素时，Swift会抛出一个运行时错误，所以我们警惕这种情况，并且当发生时及早返回。

### 入队新元素
如果我们已经写了一些有用的辅助函数，那么我们写大的重要的函数时就会变得容易。所以，我们准备写的第一个就是在堆尾入队新元素并且上滤的函数。它看起来正如你期望的那样简单。在优先级队列中、peek()函数下完成它：

```
mutating func enqueue(_ element: Element) -> Void {
    elements.append(element)
    siftUp(elementAtIndex: count - 1)
}
```
当新的元素加入时，count - 1是最大的有效的节点秩
在没有写完siftUp函数之前，这一切都还没有完成。所以：

```
mutating func siftUp(elementAtIndex index: Int) -> Void {
    let parent = parentIndex(of: index) //#1
    guard !isRoot(parent), //#2
    	isHigherPriority(at: index, than: parent) else { //#3
        return
    }
    swapElement(at: index, with: parent) //#4
    siftUp(elementAtIndex: parent)       //#5
}
```

现在我们看到所有的辅助函数都得到很好的使用！让我们重新看一下一下我们已经写的吧！

1. 首先我们已经计算了参数秩的父节点的秩，因为它将在这个函数中被多次用到，所以你只需计算一次
2. 然后你要确保你没有试图对堆的根节点进行上移
3. 或者把一个元素上移到较高优先级的父节点的上面。当你试图做这些操作时这个函数将结束。
4. 一旦你知道一个节点比它的父节点有更高的优先级时，你就交换他们
5. 并起在父节点调用siftUp函数，以防这个元素仍然不在正确的位置上
这是一个递归函数，它将持续调用它自己直到结束条件成立。

### 出队最高优先级的元素
我们可以上滤，当然我们也可以下滤。为了出队最高优先级的元素并且保证堆的结构性不变，把接下来这个函数写在siftUp下面

```
mutating func dequeue() -> Element? {
    guard !isEmpty else {
        return nil
    }
    elements.swapAt(0, count - 1)
    let ele = elements.removeLast()
    if count > 1 {
        siftDown(elementAtIndex: 0)
    }
    return ele
}
```
让我们重新看看我们已经写的

1. 首先你得保证堆中有第一个元素以供返回。如果没有的话你需要返回nil
2. 如果有第一个这么个元素，那么就把它和堆中最后一个元素交换
3. 现在你从堆最后一个位置移除最高优先级的元素，并且把它存放在element中
4. 如果现在堆中元素个数仍大于1，你就把当前根元素下移到适当优先级的位置
5. 最后从这个函数中返回最高优先级的元素

没有siftDown函数这一切都还没有完成

```
mutating func siftDown(elementAtIndex index: Int) -> Void {
    let childIndex = highestPriority(for: index)
    if index == childIndex {
        return
    }
    swapElement(at: index, with: childIndex)
    siftDown(elementAtIndex: childIndex)
}
```
我们也重新审视一下这个函数

1.首先在参数秩以及它的孩子节点的秩中找出指向最高优先级元素的秩。记住，如果参数秩在堆中是一个叶子节点，它没有孩子，那么highestPriorityIndex(for:)将返回参数秩它本身
2. 如果参数秩已经是三个秩（参数秩自己、左孩子秩、右孩子秩）中最高优先级的那个，那么你就讲下滤停在这里
3. 否则，其中一个孩子元素有较高的优先级，交换这连个元素，并且将下滤递归进行下去

### 最后，哦不！第一件事
唯一遗留的事情是确保堆的初始化。因为这个堆是一个结构体，它来自于默认的初始化函数，它可以像这样调用：

```
var heap = Heap(elements: [3, 2, 8, 5, 0], priorityFunction: >)
```
Swift的类型推断将假设变量heap的类型是高优先级在低优先级上面的堆，并且>操作符确保了它是大顶堆。但是那样做有一个危险的地方。你能找出它吗？数组中的元素不是按堆定义的顺序排列的。你需要创建一个显式的初始化函数，它会对元素进行一些初始的优先排序。<br />
把这个函数写在堆结构体的开始，两个属性的下面：

```
init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) { // 1 // 2
  self.elements = elements
  self.priorityFunction = priorityFunction // 3
  buildHeap() // 4
}

mutating func buildHeap() {
  for index in (0 ..< count / 2).reversed() { // 5
    siftDown(elementAtIndex: index) // 6
  }
}
```
让我们看看这个函数

1. 首先你已经写了一个现实的初始化函数，它接收一个元素的数组和一个优先级函数最为参数，就像以前一样。然而你也通过一个空数组制定了它默认值，这样调用者可以仅通过一个优先级函数就初始化一个堆，如果他们选择这样做的话。
2. 您还必须显式地指定优先级函数是@escaping，因为在这个函数完成之后，struct将保留它。
3. 现在你显式地将参数分配给堆的属性。
4. 通过构建堆来完成init()函数，将其置于优先级顺序。
5. 在buildHeap()函数中，您以相反的顺序遍历数组的前一半。如果你还记得,每一个级别的堆空间元素水平的两倍以上,还可以工作,每堆的水平有一个比各个层面上面组合元素,所以上半年堆堆中的每个父节点。
6. 一个接一个的将每个父节点筛选到它的子节点中。反过来，这将把高优先级的子节点筛选到根。

### 测试
```
var heap = Heap(elements: [3, 2, 8, 5, 0], priorityFunction: >)
while (!heap.isEmpty) {
    heap.dequeue()
}
```

就是这样。你用Swift写了一堆!
