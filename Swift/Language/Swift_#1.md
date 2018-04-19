
## 常量和变量
###### 声明
```
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempt = 0
```

###### 类型标注
```
var welcomeMessage: String
var red, green, blue: Double
```

###### 命名
```
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"
```


## 数据类型
#### 整数
###### 整数范围
```
let minValue = UInt8.min
let maxValue = UInt8.max
```

###### Int/UInt 长度与当前平台的原生字长相同
```
let fourByteIn32BitOS: Int = Int(Int32.max)
let eightByteIn64BitOS: Int = Int(Int64.max)
```

#### 浮点数
* Double表示64位浮点数，可存储很大或者很高精度的浮点数。精度很高，至少有15位数字。
* Float表示32位浮点数，可存储精度要求不高的浮点数。只有6位数字。

```
let piExplicitFloat: Float = 3.14
type(of: piExplicitFloat)
let piDefaultDouble = 3.14
type(of: piDefaultDouble)
```

###### 数值型字面量
```
let decimalInteger = 17
let binaryInteger = 0b10001
let octalInteger = 0o21
let hexadecimalInteger = 0x11
```

###### 类型别名
```
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min
```

#### 布尔值
```
let expression = "is a expression not only a value"
if expression == "is a expression not only a value" {}
```
#### 元组tuples
```
let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
print("The status message is \(statusMessage)")
let (justTheStatusCode, _) = http404Error
let justTheStatusMessage = http404Error.1
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode), message is \(http200Status.description)")
```
#### 可选类型
###### 可选类型Optionals：表示有值等于x或者没有值
```
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
type(of: convertedNumber)
```

###### nil：可以给可选变量赋值为nil表示它没有值，但不能用于非可选的常量和变量。
```
var surveyAnswer: String?
```
###### if语句及强制解析：可以使用if语句和nil比较来判断一个可选值是否包含值。
```
if convertedNumber != nil {
    print("converteNumber contains some integer value.")
}
```
###### 解包：当确定可选类型确实包含值之后，可以在可选的名字后加一个感叹号！来获取值。表示“我知道这个可选有值，请使用它”
```
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}
```
###### 可选绑定optional binding：作用于可选类型，通过if语句将不为空的值绑定到一个变量或常量上
```
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
} else {
    print("\'\(possibleNumber)\' could not be converted to an integer")
}
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
```
###### 隐式解析可选类型
其实就是一个普通的可选类型，但是可以被当做非可选类型来使用，并不需要每次都使用解析来获取可选值。如果一个变量之后可能变成nil的话请不要使用隐式解析可选类型。如果你需要在变量的生命周期中判断是否是nil的话，请使用普通可选类型。可以把隐式解析可选类型当做一个可以自动解析的可选类型。如果在隐式解析可选类型没有值的时候尝试取值，会触发运行时错误。在和没有值的普通可选类型后面加一个惊叹号一样。

```
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! //需要感叹号来获取值
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString //不需要感叹号
```

## 异常处理
###### 错误处理
```
func canThrowAnError() throws {
    // 这个函数可能抛出错误
}
do {
    try canThrowAnError()
    // 没有错误信息抛出
} catch {
    // 有一个错误消息抛出
}
```
###### 断言
用它来检查在执行后续代码之前是否一个必要的条件已经被满足了。

```
let age = 3
assert(age >= 0, "A person's age connot be less than zero!")
```

###### 先决条件，当一个条件可能为false(假)，但是继续执行代码要求条件必须为true(真)的时候，需要使用先决条件。
```
let idx = 1
precondition(idx >= 0, "Index must be greater than zero!")
```
> 断言和先决条件的不同点是，他们什么时候进行状态检测：断言仅在调试环境运行，而先决条件则在调试环境和生产环境中运行。

## 运算符
###### 赋值运算符
```
let (x, y) = (1, 2)
```

###### 算术运算符
```
1 + 2
5 - 3
2 * 3
10.0 / 2.5
```

###### 求余运算符
```
9 % 4
-9 % 4
```

###### 一元负号运算符
```
let three = 3
let minusThree = -three
let plusThree = -minusThree
```

###### 一元正号运算符
```
let minusSix = -6
let alsoMinusSix = +minusSix
```

###### 组合赋值运算符
```
var a = 1
a += 2
```

###### 比较运算符
```
1 == 1
2 != 1
2 > 1
1 < 2
1 >= 1
2 <= 1
let name = "world"
if name == "world" {
    print("hello, world")
} else {
    print("I'm sorry \(name), but I don't recognize you")
}
(1, "zebra") < (2, "apple")
(3, "apple") < (3, "bird")
(4, "dog") == (4, "dog")
//("blue", false) < ("purple", true)
```

###### 三目运算符
```
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 30)
```

###### <font color=red>空合运算符Nil Coalescing Operator</font>
空合运算符(a ?? b)将对可选类型a进行空判断，如果a包含一个值就进行解封，否则就返回一个默认值b。

```
let defaultColorName = "red"
var userDefinedColorName: String? //默认值为nil
var colorNameToUse = userDefinedColorName ?? defaultColorName
colorNameToUse = (userDefinedColorName != nil) ? userDefinedColorName! : defaultColorName
```

###### 比区间运算符
```
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
```
###### 半开闭区间运算符
```
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("第\(i+1)个人叫\(names[i])")
}
```
###### 单侧区间
```
for name in names[2...] {
    print(name)
}
for name in names[...2] {
    print(name)
}
```
###### 逻辑运算符Logical Operators
```
let enteredDoorCode = true, passedRetinaScan = false, hasDoorKey = false, knowsOverridePassword = true
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
```
## 字符串
###### 字符串字面量
```
let someString = "Some string literal value"
```

###### 多行字符串字面量
```
let quotation = """
The White Rabbit put on his spectacles. "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```

###### 字符串字面量的特殊字符
* 转义字符\0(空字符)、\\(反斜线)、\t(水平制表符)、\n(换行符)、\r(回车符)、\"(双引号)、\'(单引号)。
* Unicode 标量，写成\u{n}(u为小写)，其中n为任意一到八位十六进制数且可用的 Unicode 位码。

``` 
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
let dollarSign = "\u{24}"
let blackHeart = "\u{2665}"
let sparklingHeart = "\u{1F496}"
```

###### 初始化空字符串
```
var emptyString = ""
var anotherEmptyString = String()
if emptyString == anotherEmptyString, emptyString.isEmpty {
    print("They are equal and empty")
}
```
###### 字符串可变性
```
var variableString = "Horse"
variableString += " and carriage"
```

###### 字符串是值类型
```
var originalString = "water"
var copyString = originalString
originalString += "mellon"
if copyString == originalString {
    print("String is reference type!")
} else {
    print("String is value type!")
}
```
###### 使用字符
```
for character in "Dog!🐶" {
    print(character)
}
let exclamationMark: Character = "!"
let catCharacters: [Character] = ["C", "a", "t", exclamationMark, "🐱"]
let catString = String(catCharacters)
```

###### 链接字符串和字符
```
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2
var instruction = "look over"
instruction += string2
welcome.append(exclamationMark)
```

###### 字符串插值
```
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
```
#### Unicode
Unicode是一个国际标准，用于文本的编码和表示。它使得可以用标准格式来表示任何语言几乎所有的字符，并能够对文本文件或网页这样的外部资源中的字符进行读和写操作。Swift的String和Character类型完全兼容Unicode标准。

###### Unicode标量
* Swift的String类型是基于Unicode标量建立的。Unicode标量是对应字符或者修饰符的唯一的21位数字，例如U+0061表示小写的拉丁字母a，U+1F425表示小鸡表情🐥
* Swift每一个Swift的Character类型代表一个可扩展的字形群。一个可扩展的字形群是一个或多个可生成人类可读的字符Unicode标量的有序排列。

```
let eAcute: Character = "\u{E9}"
let combineEAcute: Character = "\u{65}\u{301}"
```
* 在这两种情况中，字母é代表了一个单一的Swift的Character值，同时代表了一个可扩展的字形群。 在第一种情况，这个字形群包换一个单一标量；而在第二种情况，它是包含两个标量的字形群。

###### 计算字符数量
```
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")
```
> 在Swift中，使用可拓展的字符群集作为Character值来连接或改变字符串时，并不一定会更改字符串的字符数量。

#### 访问和修改字符串
###### 字符串索引
* 每一个String值都有一个关联的索引(index)类型，String.Index，它对应着字符串中的每一个Character的位置。
* 前面提到，不同的字符可能会占用不同数量的内存空间，所以要知道Character的确定位置，就必须从String开头遍历每一个 Unicode 标量直到结尾。因此，Swift 的字符串不能用整数(integer)做索引。

```
var greeting = "Guten Tag!"
for index in greeting.indices {
    print("\(greeting[index])", separator: " ", terminator: "")
}
```
###### 插入和删除
```
welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex))
welcome.remove(at: welcome.index(before: welcome.endIndex))
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
```

###### 子字符串
```
greeting = "Hello, world!"
let index = greeting.index(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index] //只有在短时间内需要操作字符串时，才会使用SubString(会占用原有String的内存空间)。
let newString = String(beginning)  // 把结果转化为 String 以便长期存储。
```


#### 字符串表示形式
###### Unicode表示
```
let dogString = "Dog\u{203C}\u{1F436}"
```
###### URF-8表示
```
var byte_utf_8 = 0
for codeUnit in dogString.utf8 {
    print("\(codeUnit)", terminator: " ")
    byte_utf_8 += 1
}
byte_utf_8
dogString.lengthOfBytes(using: .utf8)
```
###### URF-16表示
```
var byte_urf_16 = 0
for codeUnit in dogString.utf16 {
    print("\(codeUnit)", terminator: " ")
    byte_urf_16 += 2
}
byte_urf_16
dogString.lengthOfBytes(using: .utf16)
```

###### Unicode标量表示
```
for scalar in dogString.unicodeScalars {
    print("\(scalar.value)", terminator: " ")
}
dogString.lengthOfBytes(using: .unicode)
```
## 集合类型Collection Type
###### 集合的可变性
* 创建一个Arrays、Sets或Dictionaries并且把它分配成一个变量，这个集合将会是可变的。
* 把Arrays、Sets或Dictionaries分配成常量，那么它就是不可变的，它的大小和内容都不能被改变。

#### 数组Array
###### 创建一个空数组
```
var someInts = [Int]()
someInts.append(3)
someInts = []
```

###### 创建一个带有默认值的数组
```
var threeDoubles = Array(repeating: 0.0, count: 3)
```

###### 通过两个数组相加创建一个数组
```
var anotherThreeDoubles = [2.5, 2.5, 2.5]
var sixDoubles = threeDoubles + anotherThreeDoubles
```

###### 数组的遍历
```
for (index, value) in sixDoubles.enumerated() {
    print("#\(index + 1) is \(value)")
}
```
#### 集合Sets
###### 集合基本操作
```
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]
oddDigits.union(evenDigits).sorted()
oddDigits.intersection(evenDigits).sorted()
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
```
###### 集合成员关系和相等
```
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]
houseAnimals.isSubset(of: farmAnimals); houseAnimals.isStrictSubset(of: farmAnimals)
farmAnimals.isSuperset(of: houseAnimals); farmAnimals.isStrictSuperset(of: houseAnimals)
farmAnimals.isDisjoint(with: cityAnimals)
```

#### 字典
###### 创建一个空字典
```
var nameOfIntegers = [Int: String]()
nameOfIntegers[0] = "zero"
nameOfIntegers = [:]
if let oldValue = nameOfIntegers.updateValue("one", forKey: 1) {
    print("The old value of 1 is \(oldValue)")
}
```
###### 遍历
```
for (key, value) in nameOfIntegers {
    print("#\(key) named \(value)")
}
let allKeys = nameOfIntegers.keys
let allValues = [String](nameOfIntegers.values)
```

## 控制流Control Flow
###### For-In循环
Swift还提供了for-in循环，用来更简单地遍历数组(Array)，字典(Dictionary)，区间(Range)，字符串(String)和其他序列类型。

```
let minuteInterval = 5
for _ in stride(from: 0, to: 60, by: minuteInterval) {
    // 每5分钟渲染一个刻度线
}
```
###### while循环
```
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0
repeat {
    // 顺着梯子爬上去或者顺着蛇滑下去
    square += board[square]
    // 掷骰子
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    // 根据点数移动
    square += diceRoll
} while square < finalSquare
```
###### 区间匹配
```
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings)")
```

###### 元组匹配
```
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}
```

###### where与值绑定Value Bindings
```
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
```

###### 符合匹配
```
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an anix, \(distance) from the origin")
default:
    print("Not on an anix")
}
```
###### 控制转移语句，continue、break、fallthrough、return、throw
###### switch语句中的break
swift所有的分支中不允许为空的分支，有时为了使意图明确，在想忽略的分支上加break语句。当这个分支被匹配到时，分支内的break语句立即结束switch代码块。
###### 带标签的语句
```
square = 0
print("game start!")
gameLoop: while square != finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // 骰子数刚好使玩家移动到最终的方格里，游戏结束。
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // 骰子数将会使玩家的移动超出最后的方格，那么这种移动是不合法的，玩家需要重新掷骰子
        continue gameLoop
    default:
        // 合法移动，做正常的处理
        square += diceRoll
        square += board[square]
    }
}
```
###### 提前退出
```
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "Tim", "location": "Cupertino"])
```
