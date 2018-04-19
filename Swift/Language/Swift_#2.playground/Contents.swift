import UIKit

//#### 检测API的可用性
if #available(iOS 10, macOS 10.12, *) {
    print("这段代码在iOS 10或macOS 10.12及以上版本上可用！")
} else {
    print("Not working!")
}

//## 函数Functions：一段完成特定任务的独立代码块儿
//### 函数定义与调用
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}

//### 函数参数与返回值
//#### 无参数函数
func sayHelloWorld() -> String {
    return "Hello, world"
}
//#### 多参数函数
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return "Hello again, " + person + "!"
    } else {
        return greet(person: person)
    }
}
//#### 无返回值函数
//严格上来说，虽然没有返回值被定义，greet(person:) 函数依然返回了值。没有定义返回类型的函数会返回一个特殊的Void值。它其实是一个空的元组（tuple），没有任何元素，可以写成()。
func greet(person: String) {
    print("Hello, \(person)!")
}

//#### 多重返回值函数
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var min = array[0]
    var max = array[0]
    for n in array[1..<array.count] {
        if n < min {
            min = n
        } else if n > max {
            max = n
        }
    }
    return (min, max)
}

//#### 可选元组返回类型
func nullableMinMax(array: [Int]) -> (min: Int, max: Int)? {
    guard !(array.isEmpty) else {
        return nil
    }
    return minMax(array: array)
}

//### 函数参数标签和参数名称
//#### 指定参数标签
func someFunction(argumentLabel parameterName: Int) -> Void {
    // 在函数体内，parameterName代表参数值
    return ()
}

//#### 忽略参数标签
func greet(_ person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)"
}
greet("Bill", from: "Cupertino")

//#### 默认参数值
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
}

//#### 可变参数Variadic Parameter
func arithmeticMean(_ numbers: Double...) ->Double {
    var total = 0.0
    for n in numbers {
        total += n
    }
    return total / Double(numbers.count)
}

//#### 输入输出参数In-Out Parameter
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3, anotherInt = 107
swap(&someInt, &anotherInt)

//### 函数类型：每一个函数都有种特定的函数类型，函数的类型由函数的参数类型和返回类型组成。
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

//#### 使用函数类型
var mathFunction: (Int, Int) -> Int = addTwoInts; mathFunction(2, 3)
mathFunction = multiplyTwoInts;                   mathFunction(2, 3)

//#### 函数类型作为参数类型
func printMathResult(_ mathFouction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)

//#### 嵌套函数&函数类型作为返回类型
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(_ input: Int) -> Int { return input + 1 }
    func stepBackward(_ input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = 3
let moveToNearerToZero = chooseStepFunction(backward: currentValue > 0)
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveToNearerToZero(currentValue)
}

//## 闭包Closures：自包含的代码块，可以在代码中被传递和使用

// 1. 全局函数是一个有名字但不会捕获任何值的闭包
// 2. 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
// 3. 闭包表达式是一个利用轻量级语法所写的可以捕获上下文中变量或常量值的匿名闭包

//### 闭包表达式：一种利用简洁语法构建内联闭包的方式
//#### sorted
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
let names = ["Chris", "Alex", "Ema", "Barry", "Daniella"]
var reversedNames = names.sorted(by: backward)

//#### 闭包表达式语法

// { (parameters) -> returnType in
//     statements
// }

//#### 根据上下文推断类型
reversedNames = names.sorted(by: { s1, s2 in
    return s1 > s2
})

//#### 单表达式闭包隐式返回
reversedNames = names.sorted(by: {s1, s2 in s1 > s2})

//#### 参数名缩写
reversedNames = names.sorted(by: { $0 > $1 })

//#### 运算符方法
reversedNames = names.sorted(by: >)

//### 尾随闭包：当需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性。
let digitName = [
    0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
let strings = numbers.map {// 当闭包是唯一的参数时可省去()
    (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitName[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}

//### 值捕获与闭包是引用类型
// 闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTatal = 0
    func incrementer() -> Int { //一等类型，像类的对象，runningTatal和amount是其成员属性
        runningTatal += amount
        return runningTatal
    }
    return incrementer //返回引用类型，只要持有该引用的常/变量不被消耗，那么该函数已经其捕获的值都不会被销毁
}

//incrementer() 函数并没有任何参数，但是在函数体内访问了 runningTotal 和 amount 变量。这是因为它从外围函数捕获了 runningTotal 和 amount 变量的引用。捕获引用保证了 runningTotal 和 amount 变量在调用完 makeIncrementer 后不会消失，并且保证了在下一次执行 incrementer 函数时，runningTotal 依旧存在。为了优化，如果一个值不会被闭包改变，或者在闭包创建后不会改变，Swift 可能会改为捕获并保存一份对值的拷贝。 Swift 也会负责被捕获变量的所有内存管理工作，包括释放不再需要的变量。
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()
let anotherIncrement = incrementByTen
anotherIncrement()

//### 逃逸闭包：当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。当定义接收闭包作为参数的时候，需在参数名之前标注@escaping，用来指明这个闭包是允许“逃逸”出这个函数的。
var completionHandlers: [()->Void] = []
func someFuncWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
func someFuncWithNoescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        someFuncWithEscapingClosure {
            self.x = 100
        }
        someFuncWithNoescapingClosure {
            x = 200
        }
    }
}
let instance = SomeClass()
instance.doSomething()
instance.x
completionHandlers.first?()
instance.x

//### 自动闭包
// 一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
customersInLine.count
let customerProvider = {customersInLine.remove(at: 0)}
customersInLine.count
print("Now serving \(customerProvider())")
customersInLine.count

//#### 延时求值：函数定义的时候不求值，调用的时候才求值
func serve(customer customerProvide: () -> String) {// 接受一个返回顾客名字的显式的闭包。
    print("Now serving \(customerProvider())")
}
serve(customer: { customersInLine.remove(at: 0) })

//#### @autoclosure
func serveWithAutoclosure(customer customerProvider: @autoclosure () -> String ) {
    print("Now serving \(customerProvider())")
}
serveWithAutoclosure(customer: customersInLine.remove(at: 0))

//## 枚举：为一组相关的值定义了一个共同的类型，在代码中以类型安全的方式来使用这些值。
//### 枚举语法
enum CompassPoint {
    case north
    case south
    case east
    case west
}
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
// 每隔枚举定义了一个全新的类型。
var directonToHead = CompassPoint.west
directonToHead = .east

//### 使用switch语句匹配枚举值
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

let ace = Rank.ace
var RankValue = ace.rawValue
RankValue = 2

//### 关联值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = Barcode.qrCode("ABCDEFGHIJKLMNOP")
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

//### 原始值
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
print("pre\(ASCIIControlCharacter.lineFeed.rawValue)suf")

//#### 原始值的隐式赋值
enum Suit: Int {
    case spades, hearts, diamonds, clubs
}
let suitFirst = Suit.spades.rawValue // suitFirst是整形的0

//#### 使用原始值初始化枚举实例
if let cardColor = Suit(rawValue: 3) {
    print("The color of card is \(cardColor)")
}

//### 递归枚举
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case .number(let value):
        return value
    case .addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}
evaluate(product)
