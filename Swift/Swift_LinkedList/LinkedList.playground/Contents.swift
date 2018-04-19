import UIKit

class Node<Element> {
    var data: Element!
    var prec: Node?
    var succ: Node?
    init() {}
    init(data: Element, prec: Node? = nil, succ: Node? = nil) {
        self.data = data
        self.prec = prec
        self.succ = succ
    }
    
    func insertAsPrec(_ newElement: Element) -> Node {
        let node = Node(data: newElement, prec: self.prec, succ: self)
        self.prec?.succ = node
        self.prec = node
        return node
    }
    
    func insertAsSucc(_ newElement: Element) -> Node {
        let node = Node(data: newElement, prec: self, succ: self.succ)
        self.succ?.prec = node
        self.succ = node
        return node
    }
    deinit {
        print("Node being destroy!")
    }
}



class LinkList<Element: Equatable> {
    var head: Node<Element> = Node()
    var tail: Node<Element> = Node()
    var size = 0
    
    init() {
        head.succ = tail
        tail.prec = head
    }
    
    var count: Int {
        return size
    }
    var isEmpty: Bool {
        return size == 0
    }
    
    func append(_ newElement: Element) {
        tail.insertAsPrec(newElement)
        size += 1
    }
    
    func insert(_ newElemnt: Element, at: Int) {
        var node = head, index = at
        while index > 0 && node.succ !== tail {
            node = node.succ!
            index -= 1
        }
        node.insertAsSucc(newElemnt)
        size += 1
    }
    func insert(_ newElement: Element, after: Element) {
        var node = tail
        while node.prec != nil {
            if node.data == after {
                break
            }
            node = node.prec!
        }
        node.insertAsSucc(newElement)
        size += 1
    }
    func remove(_ element: Element) -> Element? {
        var node = tail
        var found = false
        while node.prec != nil {
            if node.data == element {
                found = true
                break
            }
            node = node.prec!
        }
        if found {
            let ele = node.data
            node.prec?.succ = node.succ
            node.succ?.prec = node.prec
            size -= 1
            return ele
        } else {
            return nil
        }
    }
    func remove(at: Int) -> Element? {
        guard at >= 0 && at < size else {
            return nil
        }
        var node = head, index = at
        while index > 0 {
            node = node.succ!
            index -= 1
        }
        let ele = node.data
        node.prec?.succ = node.succ
        node.succ?.prec = node.prec
        size -= 1
        return ele
    }
}

extension LinkList: CustomStringConvertible {
    var description: String {
        var string = "["
        var node = head.succ!
        while node.succ != nil {
            string += (node.succ === tail) ? "\(node.data!)" : "\(node.data!), "
            node = node.succ!
        }
        string += "]"
        return string
    }
}

extension LinkList: Sequence {
    typealias Iterator = LinkListIterator<Element>
    func makeIterator() -> LinkListIterator<Element> {
        return LinkListIterator(self)
    }
}



class LinkListIterator<T: Equatable>: IteratorProtocol {
    typealias Element = T
    
    var currentNode: Node<T>
    var tail: Node<T>
    init(_ list: LinkList<T>) {
        currentNode = list.head.succ!
        self.tail = list.tail
    }
    func next() -> LinkListIterator.Element? {
        if currentNode === tail {
            return nil
        }
        let ele = currentNode.data
        currentNode = currentNode.succ!
        return ele
    }
}
/*
extension LinkList: Collection {
    typealias Index = Int
    var startIndex: Int {
        return 0
    }
    var endIndex: Int {
        return size - 1
    }
    subscript(position: Int) -> Element {
        var currentNode = head.succ!
        var index = position
        while index > 0 {
            currentNode = currentNode.succ!
            index -= 1
        }
        return currentNode.data!
    }
    func index(after i: Int) -> Int {
        return i + 1
    }
}
*/


var array = Array<Int>()
array.count
array.isEmpty
array.append(1)
array.insert(0, at: 0)
array

let linkedList = LinkList<Int>()
linkedList.append(3)
linkedList.append(4)
linkedList.insert(100, at: 100)
if let x = linkedList.remove(100) {
    print("The too big element \(x) has been removed!")
} else {
    print("The too big element does not exsist")
}
if let x = linkedList.remove(1000) {
    print("The too big element \(x) has been removed!")
} else {
    print("The too big element does not exsist")
}
linkedList.insert(7, after: 3)
linkedList.insert(0, at: 0)
linkedList.insert(2, at: 1)
linkedList.count

for item in linkedList {
    print("\(item)")
}

linkedList.map { (x) -> Int in
    10 + x
}
linkedList.filter { (x) -> Bool in
    x >= 4
}
