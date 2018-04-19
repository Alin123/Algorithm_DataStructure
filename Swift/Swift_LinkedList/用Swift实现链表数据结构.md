## 用Swift实现链表数据结构
[原文链接](https://www.raywenderlich.com/144083/swift-algorithm-club-swift-linked-list-data-structure)
### 开始
链表是数据项的一个序列，每一项被称作一个节点。链表有两种重要的类型：<br/>
单链表：每个节点仅有一个到下一个节点的引用。
双向链表：每个节点有一个到前一个节点的引用和到下一个节点的引用。
你需要记录列表的开始和结束。做到这一点通常会用叫做head和tail的指针。
### 实现
在这一节，你将用Swift实现链表。
记住，链表由节点组成。所以，开始的时候创建一个基础的节点类。创建一个新的Swift Playground并且添加接下来的空的类。

```
public class Node {
    
}
```
#### 值
一个节点需要一个值和它关联。把下面的添加花括号之间：

```
var value: String
    
init(value: String) {
    self.value = value;
}
```
你已经声明了一个叫做value类型为Sting的属性。在你自己的应用中，它应该存储任何你想存储的类型。
你也声明了一个构造器，对于你的类来说，初始化所有的非可选存储属性它是必须的。

### 后继
除了value以外，在列表中每个节点需要一个指向后继的指针。为了做到这一点，在类中添加接下来的属性

```
var next: Node?
```
你已经声明了一个叫做next类型为Node的属性。注意你已经让next是可选类型的了。这是因为链表中最后一个节点不指向其他节点。

### 前驱
因为我们正在完成的是一个双向链表，所以在列表中我们需要一个指向前驱节点的指针。
为了做到这一点，添加最后一个属性到类中：

```
weak var previous: Node?
```

注意：为了避免循环引用，我们将前驱声明为弱类型。在列表中如果节点B跟随着节点A，A指向B、B也指向A。在某种情况下，这种循环拥有权会引起当你删除它们的时候节点依然存在。我们并不想那样，所以我们让一个指针弱引用以打破这个循环。点击[Swift中的ARC和内存管理](https://www.raywenderlich.com/134411/arc-memory-management-swift)学习更多关于循环引用的东西。

### 链表
现在你已经创建完成了Node，你也需要记录列表的起始和结束的位置。为了做到这一点，在Playground的底部添加新的LinkedList类。

```
public class LinkedList {
    fileprivate var head: Node?
    private var tail: Node?
    
    public var isEmpty: Bool {
        return head == nil
    }
    public var first: Node? {
        return head
    }   
    public var last: Node? {
        return tail
    }
}
```
这个类记录了列表起始和结束的位置。它也将提供一些其他的辅助函数。

### 拼接
为了处理在列表中拼接一个新的节点，你将声明一个`append(value:)`方法在你的LinkedList类中。添加下面的新的方法到LinkedList类中：

```
func append(value: String) -> Void {
    let newNode = Node(value: value)
    if let tailNode = tail {
        tailNode.next = newNode
        newNode.previous = tail
    } else {
        head = newNode
    }
    tail = newNode;
}
```
让我们来回顾一下这个部分:

* 创建一个包含这个值的新节点。请记住，Node类的目的是使链表中的每一个项目都可以指向上一个节点和下一个节点。
* 如果尾节点不为空，那意味着链表中已经有一些东西。如果那样的话，配置新的节点，让列表的尾节点作为它的前驱指向它。同样的，配置链表的尾节点，让新的节点作为它的后继指向它。
* 最后，在两种情况下设置新的节点为列表的尾。

### 输出你的链表
让我们测试你的新的链表。在Playground中LinkedList类实现的外面写一下代码：

```
let dogBreeds = LinkedList()
dogBreeds.append(value: "Labrador")
dogBreeds.append(value: "Bulldog")
dogBreeds.append(value: "Beagle")
dogBreeds.append(value: "Husky")
```

定义完列表后，我们尝试把列表输出到控制台：

```
print(dogBreeds)
```
通过组合键`Command-Shift-Y`来唤起控制台。你应该能看到接下来的输出：

```
LinkedList
```

这并没有太大帮助。为了展示一个更具可读性的输出字符串，你可以让LinkedList实现CustomStringConvertable协议。要做到这一点，请在LinkedList类的实现下面添加以下内容：
```
public var description: String {
    var text = "["
    var node = head
    while node != nil {
        text += node!.value
        if node!.next != nil  {
            text += ", "
        }
        node = node!.next
    }
    text += "]"
    return text;
}
```

这段代码是这样工作的：

1. 你已经声明了为你的LinkedList声明了一个扩展，并且已经实现了CustomStringConvertible协议。这个协议期望你实现一个计算属性，属性名是description，类型是String类型。
2. 你已经声明了description属性。这是一个计算属性，返回一个字符串的只读属性
3. 你已经声明了一个叫text的变量。它将保存整个字符串。现在，它包含了一个左大括号以表示列表的开始。
4. 然后循环遍历列表，将每个项的值附加到文本字符串。
5. 你添加一个右大括号在text变量的结尾。

现在当你调用LinkedList类的输出方法时，你将得到像这样的更好的表述：

```
[Labrador, Bulldog, Beagle, Husky]
```

### 获取节点
当你按顺序通过前驱和后继穿过节点，链表看起来工作的很好，但有时通过秩访问元素是很便利的。为了做到这一点，在链表里我们将声明`nodeAt(index:)`方法。它将返回在指定秩的节点。更新LinkedList类的实现让它包含下面的代码：

```
func nodeAt(index: Int) -> Node? {
    if index >= 0 {
        var node = head
        var i = index
        while node != nil {
            if i == 0 {
                return node
            }
            i -= 1
            node = node!.next
        }
    }
    return nil
}
```
你都做了：

1. 加了一个非负的检查。这样做可以阻止无效的循环如果index是一个负数的话。
2. 遍历节点直到你到达了指定的秩，并返回这个节点。
3. 如果节点小于0或者大于元素个数，那么返回空。

### 移除所有节点
移除所有节点很简单。我们只需将head和tail赋为空即可：

```
func removeAll() -> Void {
    head = nil
    tail = nil
}
```

### 移除单个节点
为了移除单个节点，我们将必须处理三种情形：

1. 移除第一个节点。这需要更新head和前驱指针。
2. 移除列表中间的节点。这需要更新钱去和后继指针。
3. 移除列表中最后一个节点。这需要更新后继指针和tail。

更新LinkedList的实现以包含下面的代码：

```
public func remove(node: Node) -> String {
  let prev = node.previous
  let next = node.next
  if let prev = prev {
    prev.next = next // 1
  } else { 
    head = next // 2
  }
  next?.previous = prev // 3
  if next == nil { 
    tail = prev // 4
  }
  // 5
  node.previous = nil 
  node.next = nil
  // 6
  return node.value
}
```

你所做的事:

1. 如果你不是删除列表中的第一个节点，则更新后继指针。
2. 如果正在删除列表中的第一个节点，则更新head指针。
3. 将前驱指针更新为已删除节点的前驱指针。
4. 如果删除列表中的最后一个节点，则更新tail。
5. 将已删除节点的前驱和后继指针置空。
6. 返回已删除节点的值。

### 范型化

到目前为止你已经实现了一个通用的能存储String类型值的链表。在LinkedList类里面你提供了拼接、移除和获取节点的方法。在这一节，我们将使用泛型来从链表中抽象出类型需求。更新Node类的实现：

```

// 1
public class Node<T> {
  // 2
  var value: T
  var next: Node<T>?
  weak var previous: Node<T>?
  // 3
  init(value: T) {
    self.value = value
  }
}
```

这里所做的事:

1. 你已经更改了节点类的声明，以使用泛型类型T。
2. 你的目标是允许节点类接受任何类型的值，因此你将约束你的值属性为类型T而不是String。
3. 你还更新了初始化器以获取任何类型。

### 范型化挑战
试着用范型更新LinkedList类的实现。
解决方案在下面的剧透部分提供，但是先自己尝试一下!

```
// 1. Change the declaration of the Node class to take a generic type T
public class LinkedList<T> {
  // 2. Change the head and tail variables to be constrained to type T
  fileprivate var head: Node<T>?
  private var tail: Node<T>?

  public var isEmpty: Bool {
    return head == nil
  }
  
  // 3. Change the return type to be a node constrained to type T
  public var first: Node<T>? {
    return head
  }

  // 4. Change the return type to be a node constrained to type T
  public var last: Node<T>? {
    return tail
  }

  // 5. Update the append function to take in a value of type T
  public func append(value: T) {
    let newNode = Node(value: value)
    if let tailNode = tail {
      newNode.previous = tailNode
      tailNode.next = newNode
    } else {
      head = newNode
    }
    tail = newNode
  }

  // 6. Update the nodeAt function to return a node constrained to type T
  public func nodeAt(index: Int) -> Node<T>? {
    if index >= 0 {
      var node = head
      var i = index
      while node != nil {
        if i == 0 { return node }
        i -= 1
        node = node!.next
      }
    }
    return nil
  }

  public func removeAll() {
    head = nil
    tail = nil
  }

  // 7. Update the parameter of the remove function to take a node of type T. Update the return value to type T.
  public func remove(node: Node<T>) -> T {
    let prev = node.previous
    let next = node.next

    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev

    if next == nil {
      tail = prev
    }

    node.previous = nil
    node.next = nil
    
    return node.value
  }
}
```

你的代码也应该完成了，让我们测试一下吧！在Playground文件的结尾，添加接下来的代码以核实你的范型类是工作的。

```
let dogBreeds = LinkedList<String>()
dogBreeds.append(value: "Labrador")
dogBreeds.append(value: "Bulldog")
dogBreeds.append(value: "Beagle")
dogBreeds.append(value: "Husky")

let numbers = LinkedList<Int>()
numbers.append(value: 5)
numbers.append(value: 10)
numbers.append(value: 15)
```