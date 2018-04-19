import UIKit

//## 范型
//### 范型所解决的问题
// 范型代码能够自定义的需要，编写出适合任意类型、灵活可重用的函数及类型。它能让你避免代码重复，用一种清晰和抽象的方式来表达代码的意图。
//### 范型所解决的问题
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}
func swapTwoStrings(_ a: inout String, _ b: inout String) {
    let temp = a
    a = b
    b = temp
}
func swapTwoDouble(_ a: inout Double, _ b: inout Double) {
    let temp = a
    a = b
    b = temp
}
//### 范型函数
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}
var a = 3, b = 107
swapTwoValues(&a, &b)
//### 类型参数：指定并命名一个占位类型，并且紧随在函数名后面，使用一对儿尖括号括起来。
//### 命名类型参数：单个字母T、U、V或大写字母开头的驼峰命名法MyTypeParameter等
//### 范型类型
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
//### 扩展一个范型类：不需要在扩展的定义中提供类型参数列表
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
//### 类型约束：可以指定一个类型参数必须继承自指定类、或者符合一个特定的协议或协议组合。
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14, 0.1, 5])
//### 关联类型
// 定义一个协议时，有时候声明一个或多个关联类型作为协议定义的一部分将会非常有用。关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定。
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct IntStack: Container {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    typealias ItemType = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}
//#### 通过扩展一个存在的类型来指定关联类型
extension Stack: Container {
    typealias ItemType = Element
    mutating func append(_ item: Stack<Element>.ItemType) {
        self.push(item)
    }
    var count: Int {
        return self.items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
//#### 约束关联类型
// 可以给协议里的关联类型添加类型注释，让遵守协议的类型必须遵守这个约束条件。

//### 范型where语句
func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
    // 检查两个容器含相同数量的元素
    if someContainer.count != anotherContainer.count {
        return false
    }
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
}
// C1必须符合Container协议，写作C1: Container
// C2必须符合Container协议，写作C2: Container
// C1的ItemType必须和C2的ItemType类型相同，写作C1.ItemType == C2.ItemType
// C1的ItemType必须符合Equatable协议，写作C1.ItemType: Equatable

extension Array: Container {}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
var arrayOfStrings = ["uno", "dos", "tres"]
if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}

//### 具有范型where子句的扩展
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}

struct NotEqutable { }
var notEquatableStack = Stack<NotEqutable>()
let notEquatableValue = NotEqutable()
notEquatableStack.push(notEquatableValue)
//notEquatableStack.isTop(notEquatableValue)

extension Container where ItemType: Equatable {
    func startsWith(_ item: ItemType) -> Bool {
        return count >= 1 && self[0] == item
    }
}
if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}
extension Container where ItemType == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())

//### 具有范型where子句的关联类型
protocol ContainerProtocol {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}
/*
struct Queue<Element>: ContainerProtocol {
    var items = [Element]()
    mutating func dequeue() -> Element {
        return items.removeFirst()
    }
    mutating func enqueue(_ item: Element) {
        return items.append(item)
    }
    
    
    typealias Item = Element
    mutating func append(_ item: Element) {
        self.enqueue(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
    func makeIterator() -> Queue<Element>.Iterator {
        return items.makeIterator()
    }
}
*/
//### 范型下标
extension Container {
    subscript<Indices: Sequence>(indeces: Indices) -> [ItemType]
    where Indices.Iterator.Element == Int {
        var result = [ItemType]()
        for index in indeces {
            result.append(self[index])
        }
        return result
    }
}

