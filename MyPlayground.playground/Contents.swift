//: Playground - noun: a place where people can play

import UIKit
import Foundation

struct Heap<Element> {
    var elements: [Element]
    let priorityFunction: (Element, Element) ->Bool
    
    init(elements:[Element] = [], priorityFunction:@escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        for index in (0..<count/2).reversed() {
            siftDown(elementAtIndex: index)
        }
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    var count: Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    
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
    //比较优先级
    //理论上，我们会多次的比较父节点或者孩子节点的元素的优先级。在这一节我们将明确指出一个节点及其子节点中哪个优先级最高。
    //在“父节点的秩“方法下面添加这个方法
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    //这个辅助函数是优先级计算属性的比较器。它接受两个秩，并且当第一个秩所对应的元素有较高优先级的时候返回true
    //在它的帮助下我们可以写其他两个辅助的比较函数，现在就让我们写在“isHigherPriority”函数下面吧！
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
    //让我们复审一下这两段代码。第一个假设父节点在数组中有一个有效的秩，如果子节点在数组中有一个有效的秩，那么就比较在相应秩的节点的优先级，并且返回一个有效的、更高优先级的节点的秩。
    //第二个也假设父节点的秩是有效的，并且比较两个左右孩子——如果存在的话。返回三者中优先级最高的秩。
    
    //最后一个辅助函数是另外一个交换函数，并且它是唯一一个改变堆结构的函数
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else {
            return
        }
        elements.swapAt(firstIndex, secondIndex)
    }
    //这个函数接受两个秩参数，并且交换两个秩所对应的元素。因为当调用者试图交换两个有相同秩的元素时，Swift会抛出一个运行时错误，所以我们警惕这种情况，并且当发生时及早返回。
    //入队新元素
    //如果我们已经写了一些有用的辅助函数，那么我们写大的重要的函数时就会变得容易。所以，我们准备写的第一个就是在堆尾入队新元素并且上滤的函数。
    //它看起来正如你期望的那样简单。在优先级队列中、peek()函数下完成它
    mutating func enqueue(_ element: Element) -> Void {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }
    //当新的元素加入时，count - 1是最大的有效的节点秩
    // 在没有写完siftUp函数之前，这一切都还没有完成。所以：
    mutating func siftUp(elementAtIndex index: Int) -> Void {
        let parent = parentIndex(of: index)
        guard !isRoot(parent), isHigherPriority(at: index, than: parent) else {
            return
        }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }
    //现在我们看到所有的辅助函数都得到很好的使用！让我们复审一下我们已经写的吧
    //1. 首先我们已经计算了参数秩的父节点的秩，因为它将在这个函数中被多次用到，所以你只需计算一次
    //2. 然后你要确保你没有试图对堆的根节点进行上移
    //3. 或者把一个元素上移到较高优先级的父节点的上面。当你试图做这些操作时这个函数将结束。
    //4. 一旦你知道一个节点比它的父节点有更高的优先级时，你就交换他们
    //5. 并起在父节点调用siftUp函数，以防这个元素仍然不在正确的位置上
    //这是一个递归函数，它将持续调用它自己直到结束条件成立
    //出队最高优先级的元素
    //我们可以上滤，当然我们也可以下滤
    //为了出队最高优先级的元素并且保证堆的结构性不变，把接下来这个函数写在siftUp下面
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
    //让我们重新看看我们已经写的
    //1. 首先你得保证堆中有第一个元素以供返回。如果没有的话你需要返回nil
    //2. 如果有第一个这么个元素，那么就把它和堆中最后一个元素交换
    //3. 现在你从堆最后一个位置移除最高优先级的元素，并且把它存放在element中
    //4. 如果现在堆中元素个数仍大于1，你就把当前根元素下移到适当优先级的位置
    //5. 最后从这个函数中返回最高优先级的元素
    //没有siftDown函数这一切都还没有完成
    mutating func siftDown(elementAtIndex index: Int) -> Void {
        let childIndex = highestPriority(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }
    //我们也重新这个函数
    //1.首先在参数秩以及它的孩子节点的秩中找出指向最高优先级元素的秩。记住，如果参数秩在堆中是一个叶子节点，它没有孩子，那么highestPriorityIndex(for:)将返回参数秩它本身
    //2. 如果参数秩已经是三个秩（参数秩自己、左孩子秩、右孩子秩）中最高优先级的那个，那么你就讲下滤停在这里
    //3. 否则，其中一个孩子元素有较高的优先级，交换这连个元素，并且将下滤递归进行下去
    //最后，哦不！第一件事
    //唯一遗留的事情是确保堆的初始化。因为这个堆是一个结构体，它来自于默认的初始化函数，它可以像这样调用
}

var heap = Heap(elements: [3, 2, 8, 5, 0], priorityFunction: >)
while (!heap.isEmpty) {
    heap.dequeue()
}
