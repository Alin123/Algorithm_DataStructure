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
    
    func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
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
    
    mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else {
            return
        }
        elements.swapAt(firstIndex, secondIndex)
    }
    mutating func enqueue(_ element: Element) -> Void {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }
    
    mutating func siftUp(elementAtIndex index: Int) -> Void {
        let parent = parentIndex(of: index)
        guard !isRoot(parent), isHigherPriority(at: index, than: parent) else {
            return
        }
        swapElement(at: index, with: parent)
        siftUp(elementAtIndex: parent)
    }
    
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
    mutating func siftDown(elementAtIndex index: Int) -> Void {
        let childIndex = highestPriority(for: index)
        if index == childIndex {
            return
        }
        swapElement(at: index, with: childIndex)
        siftDown(elementAtIndex: childIndex)
    }
}

var heap = Heap(elements: [3, 2, 8, 5, 0], priorityFunction: >)
while (!heap.isEmpty) {
    heap.dequeue()
}
