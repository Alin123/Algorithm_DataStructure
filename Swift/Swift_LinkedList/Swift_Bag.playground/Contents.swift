import UIKit

struct Bag<Element: Hashable> {
    fileprivate var contents: [Element: Int] = [:]
    
    init() { }
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
            for ele in sequence {
                add(ele)
            }
    }
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Element, value: Int) {
            for (ele, count) in sequence {
                add(ele, occurence: count)
            }
    }
    
    var uniqueCount: Int {
        return contents.count
    }
    var totalCount: Int {
        return contents.values.reduce(0) { $0 + $1 }
    }
    
    mutating func add(_ member: Element, occurence: Int = 1) {
        precondition(occurence > 0, "Can only add a positive number of occurrences")
        if let currentCount = contents[member] {
            contents[member] = currentCount + occurence
        } else {
            contents[member] = occurence
        }
    }
    mutating func remove(_ member: Element, occurrences: Int = 1) {
        guard let currentCount = contents[member], currentCount >= occurrences else {
            preconditionFailure("Removed non-existent elements")
        }
        
        precondition(occurrences > 0, "Can only remove a positive number of occurrences")
        if currentCount > occurrences {
            contents[member] = currentCount - occurrences
        } else {
            contents.removeValue(forKey: member)
        }
    }
}
extension Bag: CustomStringConvertible {
    var description: String {
        return String(describing: contents)
    }
}

extension Bag: Sequence { //序列：一种提供顺序、迭代访问其元素的类型。
    typealias Iterator = AnyIterator<(element: Element, count: Int)>
    //只有一个必须实现的方法makeIterator()
    func makeIterator() -> Iterator { // 需要返回一个Iterator：迭代器，这个迭代器必须实现IteratorProtocol协议
        var iterator = contents.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }
}

/*
 迭代（Iteration)是一个简单概念，但它能给你的对象提供许多功能：
 map(_:): 用一个闭包将 Sequence 中的每个元素挨个进行转换，并构成另一个数组返回。
 filter(_:): 用一个闭包过滤所需的元素，将符合闭包谓词所指定条件的元素放到新数组中返回。
 reduce(_:_:): 用一个闭包将 Sequence 中的所有元素合并成一个值返回。
 sorted(by:): 根据指定的闭包谓词，将 Sequence 中的元素进行排序并返回排序后的数组
 */
struct BagIndex<Element: Hashable> {
    fileprivate let index: DictionaryIndex<Element, Int>
    
    fileprivate init(_ dictionaryIndex: DictionaryIndex<Element, Int>) {
        self.index = dictionaryIndex
    }
}

extension BagIndex: Comparable {
    static func ==(lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index == rhs.index
    }
    static func <(lhs: BagIndex, rhs: BagIndex) -> Bool {
        return lhs.index < rhs.index
    }
}

extension Bag: Collection {// 集合是能够通过索引进行访问并进行多次非破坏性迭代的结合。
    typealias Index = BagIndex<Element>
    var startIndex: Index {
        return BagIndex(contents.startIndex)
    }
    var endIndex: Index {
        return BagIndex(contents.endIndex)
    }
    subscript(position: Index) -> Iterator.Element {
        precondition((startIndex..<endIndex).contains(position), "Out of bounds")
        let dictionaryElement = contents[position.index]
        return (element: dictionaryElement.key, count: dictionaryElement.value)
    }
    func index(after i: Index) -> Index {
        return Index(contents.index(after: i.index))
    }
}


var shoppingCart = Bag<String>()
shoppingCart.add("Banana")
shoppingCart.add("Oriange", occurence: 6)
shoppingCart.add("Banana")
shoppingCart.remove("Oriange")
shoppingCart.remove("Oriange")

for (element, count) in shoppingCart {
    print("\(element) has \(count)")
}


