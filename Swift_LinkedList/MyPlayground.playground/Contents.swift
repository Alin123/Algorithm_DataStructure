//: Playground - noun: a place where people can play

import UIKit

public class Node<T> {
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(value: T) {
        self.value = value;
    }
}

public class LinkedList<T>: CustomStringConvertible {
    fileprivate var head: Node<T>?
    private var tail: Node<T>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public var last: Node<T>? {
        return tail
    }
    
    func append(value: T) -> Void {
        let newNode = Node(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
            newNode.previous = tail
        } else {
            head = newNode
        }
        tail = newNode;
    }
    
    func nodeAt(index: Int) -> Node<T>? {
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
    
    public var description: String {
        var text = "["
        var node = head
        while node != nil {
            text += "\(node!.value)"
            if node!.next != nil  {
                text += ", "
            }
            node = node!.next
        }
        text += "]"
        return text;
    }
    
    func removeAll() -> Void {
        head = nil
        tail = nil
    }
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

let dogBreeds = LinkedList<String>()
dogBreeds.append(value: "Labrador")
dogBreeds.append(value: "Bulldog")
dogBreeds.append(value: "Beagle")
dogBreeds.append(value: "Husky")

print(dogBreeds)

let intLL = LinkedList<Int>()
intLL.append(value: 2)
intLL.append(value: 2)
intLL.append(value: 2)
intLL.append(value: 5)
intLL.append(value: 8)
print(intLL)


