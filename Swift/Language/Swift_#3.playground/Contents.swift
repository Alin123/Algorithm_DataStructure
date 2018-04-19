import UIKit

//## 类和结构体
//### 类和结构体对比
// 共同点
// 1. 定义属性用于存储值
// 2. 定义方法用于提供功能
// 3. 定义下标操作使得可以通过下标语法来访问实例所包含的值
// 4. 定义构造器用于生成初始值
// 5. 通过扩展增加默认实现的功能
// 6. 实现协议以提供某种标准功能
// 相比于结构体，类还附加了：
// 1. 继承允许一个类继承另一个类的特征
// 2. 类型转换允许在运行时检查和解释一个类实例的类型
// 3. 析构器允许一个类实例释放任何其所被分配的资源
// 4. 引用计数允许对一个类的多次引用

//#### 定义语法
struct Resolution { //分辨率
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

//#### 类和结构体实例
let someResolution = Resolution()
let someVideoMode = VideoMode()

//#### 属性访问：点语法
someVideoMode.resolution.width = 1280

//#### 结构体类型的成员逐一构造器
let vga = Resolution(width: 640, height: 480)

//### 结构体和枚举是值类型

//所有基本类型：整数、浮点数、布尔值、字符串、数组和字典，都是值类型；并且在底层都是以结构体的形式所实现。
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
print("hd is still \(hd.width) pixels wide")

var aName = "Not one"
var videoNames = ["Ready Player One", aName]
var newVideoNames = videoNames
videoNames[1].append(" less"); newVideoNames.removeLast()
videoNames    //["Ready Player One", "Not one less"]
newVideoNames //["Ready Player One"]

//### 类是引用类型
let tenEighty = VideoMode()
tenEighty.resolution = hd; tenEighty.interlaced = true; tenEighty.name = "1080i"; tenEighty.frameRate = 25.0
let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30

//#### 恒等运算符===
// “等价于===”表示两个类类型（class type）的常量或者变量引用同一个类实例。
// “等于==”表示两个实例的值“相等”或“相同”，判定时要遵照设计者定义的评判标准，因此相对于“相等”来说，这是一种更加合适的叫法。
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same Resolution instance.")
}

//#### 指针
// pointer：某块内存的其实地址，32位或64位01二进制序列
// refer：变量或常量的别名

//### 类和结构体的选择
// 当符合一条或多条以下条件时，请考虑构建结构体：
// 1. 该数据结构的主要目的是用来封装少量相关简单数据值。
// 2. 有理由预计该数据结构的实例在被赋值或传递时，封装的数据将会被拷贝而不是被引用。
// 3. 该数据结构中储存的值类型属性，也应该被拷贝，而不是被引用。
// 4. 该数据结构不需要去继承另一个既有类型的属性或者行为

//### 存储属性
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

//#### 常量结构体的存储属性
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// rangeOfFourItems.firstValue = 4 //Cannot assign to property: 'rangeOfFourItems' is a 'let' constant

//#### 延迟存储属性：指当第一次被调用的时候才会计算其初始值的属性。当属性的值依赖于在实例的构造过程结束后才会知道影响值的外部因素时，或者当获取属性的初始值需要复杂或大量计算时，可以只在需要的时候计算它。
class DataImporter {
    var fileName = "data.txt"
    // 这里会提供数据导入导出的功能
}
class DataMamager { // 管理数据，数据来自内存或文件，当来自内存时只有写入文件时才需要DataImporter类的对象。
    lazy var importer = DataImporter()
    var data = [String]()
}
let manager = DataMamager()
manager.data.append("Some data")
manager.data.append("Some more data")
print(manager.importer.fileName)// DataImporter实例的importer属性现在被创建了

//> 注意：如果一个被标记为 lazy 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次。

//### 计算属性：计算属性不直接存储值，而是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或变量的值。
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width * 0.5)
            let centerY = origin.y + (size.height * 0.5)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width * 0.5)
            origin.y = newCenter.y - (size.height * 0.5)
        }
    }
}

//#### 简化setter声明：若计算属性的setter没有定义表示新值的参数名，则可以使用默认名称newValue

struct Square {
    var origin = Point()
    var sideLength = 0.0
    var area: Double {
        get {
            return self.sideLength * self.sideLength
        }
        set {
            self.sideLength = sqrt(newValue)
        }
    }
}
var square = Square()
square.area = 4.0
square.sideLength

//#### 只读计算属性
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")

//### 属性观察(方法)器：监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外。
// 可以为除了延迟存储属性之外的其他存储属性添加属性观察器，也可以通过重写属性的方式为继承的属性（包括存储属性和计算属性）添加属性观察器。不必为非重写的计算属性添加属性观察器，因为可以通过它的 setter 直接监控和响应值的变化。

class StepCounter {
    var totolSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if (totolSteps > oldValue) {
                print("Added \(totolSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totolSteps = 200
stepCounter.totolSteps = 100

// > 注意：如果将属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值

//### 全局变量和局部变量：前面提到的全局或局部变量都属于存储型变量，跟存储属性类似，它为特定类型的值提供存储空间，并允许读取和写入。
// 1. 全局变量或常量是在函数、方法、闭包或任何类型之外定义的变量或常量；都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。
// 2. 局部变量或常量是在函数、方法或闭包内部定义的变量或常量；默认不延迟计算，除非带有lazy修饰符。
// 在全局或局部范围都可以定义计算型变量和为存储型变量定义观察器。计算型变量跟计算属性一样，返回一个计算结果而不是存储值，声明格式也完全一样。

//### 类属性
// 区别于实例属性的每一个对象都有一份实例属性，类属性属于类本事，无论创建多少实例这个属性都只有唯一一份。
// 1. 必须给存储型类属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值。
// 2. 存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符

//#### 类型属性语法
struct AudioChannel {
    static let thresholdLevel = 10 //音量的最大上限阈值
    static var maxInputLevelForAllChannels = 0 //所有AudioChannel实例的最大音量
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                // 将当前音量限制在阀值之内
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // 存储当前音量作为新的最大输入音量
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()
leftChannel.currentLevel = 7
rightChannel.currentLevel = 11
print("left channel is \(leftChannel.currentLevel), right channel is \(rightChannel)")
print("max level is \(AudioChannel.maxInputLevelForAllChannels)")



//### 实例方法Instance Methods：属于某个特定类、结构体或者枚举类型实例的方法。实例方法提供访问和修改实例属性的方法或者提供与实例目的相关的功能，并以此来支撑实例的功能。

class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
}

//#### self属性
extension Counter {
    func reset() {
        self.count = 0
    }
}

//#### 在实例方法中修改值类型
// 结构体和枚举是值类型，默认情况下，值类型的属性不能在他的实例方法中被修改。
// 若需要在某个特定的方法中修改结构体或者枚举的属性，需在这个方法前加mutating修饰符；这份方法做的任何改变都会在方法执行结束时写会到原始结构中。方法还可以给它隐含的self属性赋予一个全新的实例，这个实例在方法结束时会替换现存实例。
extension Point {
    mutating func moveBy(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

//#### 在可变方法中给self赋值
extension Point {
    mutating func moveTo(newX: Double, newY: Double) {
        self = Point(x: newX, y: newY)
    }
}

//#### 类方法
struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    @discardableResult
    mutating func advance(to level: Int) -> Bool {//去往第6关
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complate(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Alin")
player.complate(level: 1)
player = Player(name: "Shirley")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}

//### 下标
//#### 下标语法：下标允许通过在实例名称后面的方括号中传入一个或多个索引值来对实例进行存取。
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
for x in 1...9 {
    print("\(x) times three is \(threeTimesTable[x])")
}

//#### 下标用法
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["bird"] = 2

//#### 下标选项
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
var matrix = Matrix(rows: 3, columns: 3)
matrix[1, 2] = 12.0

//## 继承
//### 定义一个基类
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() -> Void {
        // 车辆不一定会有噪音
    }
}

//### 子类生成
class Bicycle: Vehicle {
    var hasBasket = false
}
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")

//### 重写Override：子类可以为继承来的实例方法、类方法、实例属性或下标提供自己定制的实现。
//#### 访问超类的方法，属性及下标
// 在合适的地方可以通过使用super前缀来访问超类版本的方法、属性或下标：
// 1. 在方法someMethod()的重写实现中，可以通过super.someMethod()来调用超类版本的someMethod()方法。
// 2. 在属性someProperty的getter或setter的重写实现中，可以通过super.someProperty来访问超类版本的someProperty属性。
// 3. 在下标的重写实现中，可以通过super[someIndex]来访问超类版本中的相同下标。
//#### 重写方法
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
//#### 重写属性：可以重写继承来的实例属性、类属性，提供自己定制的getter、setter或添加属性观察器使重写的属性可以观察属性值什么时候发生改变。
//##### 重写属性的Getters、Setters
// 可以提供定制的getter或setter来重写任意继承来的属性，无论继承来的是存储属性还是计算属性。子类并不知道继承来的属性是存储型还是计算型，它只知道继承来的属性会有一个名字和类型。在重写一个属性时，必须将它的名字和类型都写出来。这样才能使编译器去检查重写的属性是与超类中同名同类型的属性相匹配的。
// > 注意：如果你在重写属性中提供了 setter，那么你也一定要提供 getter。如果你不想在重写版本中的 getter 里修改继承来的属性值，你可以直接通过super.someProperty来返回继承来的值，其中someProperty是你要重写的属性的名字。
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in grear \(gear)"
    }
}
//##### 重写属性观察器
// > 注意：你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。这些属性的值是不可以被设置的，所以，为它们提供willSet或didSet实现是不恰当。此外还要注意，你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了。
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomicCar: \(automatic.description)")

//#### 防止重写
// 1. 你可以通过把方法，属性或下标标记为final来防止它们被重写，只需要在声明关键字前加上final修饰符即可（例如：final var，final func，final class func，以及final subscript）。
// 2. 如果你重写了带有final标记的方法，属性或下标，在编译时会报错。在类扩展中的方法，属性或下标也可以在扩展的定义里标记为 final 的。
// 3. 你可以通过在关键字class前添加final修饰符（final class）来将整个类标记为 final 的。这样的类是不可被继承的，试图继承这样的类会导致编译报错。

//## 构造过程
//### 存储属性的初始赋值：类和结构体在创建实例时，必须为所有的存储属性设置合适的初始值。存储属性不能处于一个未知的状态
// > 注意：当你为存储型属性设置默认值或者在构造器中为其赋值时，它们的值是被直接设置的，不会触发任何属性观察者
//#### 构造器赋值
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
//#### 默认属性值
struct Celsius {
    var temperatureInCelsius: Double = 0.0
}

//### 自定义构造过程
//#### 构造参数
extension Celsius {
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}

//#### 参数的内部名称和外部名称：构造器并不像函数和方法那样在括号前有一个可辨别的名字。因此在调用构造器时，主要通过构造器中的参数名和类型来确定应该被调用的构造器。
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

//##### 不带外部名的构造器参数
extension Celsius {
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius(37.0)

//##### 可选属性类型
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese"

//##### 构造过程中常量属性的修改
// 你可以在构造过程中的任意时间点给常量属性指定一个值，只要在构造过程结束时是一个确定的值。一旦常量属性被赋值，它将永远不可更改。若一个常量在声明的时候已经赋初始值那么即使在构造函数中也不能重新给它赋值。另外常量属性只能在定义它的类的构造过程中修改；不能在子类中修改。


//### 默认构造器
// 如果结构体或类的所有属性都有默认值，同时没有自定义的构造器，那么 Swift 会给这些结构体或类提供一个默认构造器（default initializers）。这个默认构造器将简单地创建一个所有属性值都设置为默认值的实例。
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()

//#### 结构体的逐一成员构造器
extension Size {
    var area: Double { return width * height }
}
let sizeA = Size(width: 3, height: 4)
print("\(sizeA.area)")

//#### 值类型的构造器代理：构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为构造器代理，它能减少多个构造器间的代码重复。
extension Rect {
    init(originX: Double, originY: Double, size: Size) {
        self.origin.x = originX
        self.origin.y = originY
        self.size = size
    }
    init(center: Point, size: Size) {
        let X = center.x - size.width * 0.5
        let Y = center.y - size.height * 0.5
        self.init(originX: X, originY: Y, size: size)
    }
}

//### 类的继承和构造过程
// 类里面的所有存储属性——包括所有继承自父类的属性——都必需在构造过程中设置初始值。
// 1. 指定构造器是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性，并根据父类链往上调用父类的构造器来实现父类的初始化。
// 2. 遍历构造器是类中比较次要的、辅助型的构造器。通过定义遍历构造器来调用一个类中指定构造器，并为其参数提供默认值。通过定义遍历构造器来创建一个特殊用途或特定输入值的实例。

//#### 类的构造器代理规则
// 1. 指定构造器必须调用其直接父类的指定构造器。指定构造器必须总是向上代理
// 2. 遍历构造器必须调用同类中定义的其它构造器。遍历构造器必须总是横向代理
// 3. 遍历构造器必须最终导致一个指定构造器被调用

//#### 两段式构造过程
// 1. 每个存储属性被 引入它们的类 指定一个初始值。当每个存储属性的初始值被确定后
// 2. 给每个类一次机会，在新实例准备使用之前进一步定制它们的存储属性
// 编译器将执行4种有效的安全检查，以确保两段式构造过程不出错的完成：
// 1. 指定构造器必须保证它所在类引入的所有属性都先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器
// 2. 指定构造器必须先向上代理调用父类构造器，然后再为继承的属性设置新值。如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖。
// 3. 便利构造器必须先代理调用同一类中的其它构造器，然后再为任意属性赋新值。如果没这么做，便利构造器赋予的新值将被同一类中其它指定构造器所覆盖
// 4. 构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用self作为一个值。

//#### 两段式的具体流程
// 阶段一
// 1. 某个指定构造器或便利构造器被调用。
// 2. 完成新实例内存的分配，但此时内存还没有被初始化。
// 3. 指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化。
// 4. 指定构造器将调用父类的构造器，完成父类属性的初始化。
// 5. 这个调用父类构造器的过程沿着构造器链一直往上执行，直到到达构造器链的最顶部。
// 6. 当到达了构造器链最顶部，且已确保所有实例包含的存储型属性都已经赋值，这个实例的内存被认为已经完全初始化。此时阶段 1 完成。
// 阶段二
// 1. 从顶部构造器链一直往下，每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self、修改它的属性并调用实例方法等等。
// 2. 最终，任意构造器链中的便利构造器可以有机会定制实例和使用self。

//#### 构造器的继承与重写：swift默认不会继承父类的构造器，仅在安全合适的情况下继承。这种机制可以防止一个父类的简单构造器被一个更精细的子类继承，并被错误地用来创建子类的实例。
class Animal {
    var numberOfLegs = 0
    var description: String {
        return "\(numberOfLegs) legs"
    }
}
class Cat: Animal {
    override init() { //这个指定构造器和父类的指定构造器相匹配，所以需要上override修饰符。
        super.init()
        numberOfLegs = 4
    }
}

//#### 构造器自动继承的规则
// 1. 如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器。
// 2. 如果子类提供了所有父类指定构造器的实现——无论是通过规则1继承过来的，还是提供了自定义实现——它将自动继承所有父类的便利构造器。

class Food {
    var name: String
    init(name: String) { // Designated
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {// Designated
        self.quantity = quantity //先初始化本类定义的属性
        super.init(name: name)   //再调用父类的构造器完成父类定义的属性的初始化。自此阶段1完成
    }
    override convenience init(name: String) {// convenience
        self.init(name: name, quantity: 1)
    }
}
let oneMySteryItem = RecipeIngredient()
oneMySteryItem.quantity
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
// 1. 尽管RecipeIngredient将父类的指定构造器重写为了便利构造器，它依然提供了父类的所有指定构造器的实现。因此，RecipeIngredient会自动继承父类的所有便利构造器。
// 2. 在这个例子中，RecipeIngredient的父类是Food，它有一个便利构造器init()。这个便利构造器会被RecipeIngredient继承。这个继承版本的init()在功能上跟Food提供的版本是一样的，只是它会代理到RecipeIngredient版本的init(name: String)而不是Food提供的版本。

/*
 --------------------------------------------------------------
 |  Convenience         Designated                            |
 |    init()  ------>   init(name)                            |
 --------------------------------------------------------------
                           ↑
                           ↑--------------------↑
 -----------------------------------------------↑---------------
 |  Inherited          Convenience            Designated       |
 |   init()  ----->    init(name)  ----> init(name, quantity)  |
 ---------------------------------------------------------------
 */
class ShoppingItem: RecipeIngredient {
    var purchased = false //已经购买
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}
var breakfastList = [
    ShoppingItem(),
    ShoppingItem(name: "Bacon"),
    ShoppingItem(name: "Eggs", quantity: 6)
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

//### 可失败构造器
// 如果一个类、结构体或枚举类型的对象，在构造过程中有可能失败，则为其定义一个可失败构造器。这里所指的“失败”是指，如给构造器传入无效的参数值，或缺少某种所需的外部资源，又或是不满足某种必要的条件等。

class Species {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
if let giraffe = Species(name: "Giraffe") {
    print("A species was initialized with name of \(giraffe.name)")
}

//#### 枚举类型的可失败构造器
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("\(fahrenheitUnit!)")
}

//#### 带原始值的枚举类型的可失败构造器
enum Day: Int {
    case Sun = 1, Mon, Tue, Wed, Thu, Fri, Sat
}
let day = Day(rawValue: 1)
if day != nil {
    print("\(day!) is #\(day!.rawValue) day in week!")
}

//#### 构造失败的传递
// 1. 类，结构体，枚举的可失败构造器可以横向代理到类型中的其他可失败构造器。类似的，子类的可失败构造器也能向上代理到父类的可失败构造器。
// 2. 无论是向上代理还是横向代理，如果你代理到的其他可失败构造器触发构造失败，整个构造过程将立即终止，接下来的任何构造代码不会再被执行。
// 3. 可失败构造器也可以代理到其它的非可失败构造器。通过这种方式，你可以增加一个可能的失败状态到现有的构造过程中。

class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil } // 倘若quantity值无效，则立即终止整个构造过程
        self.quantity = quantity
        super.init(name: name) //也会检查name是否合法
    }
}

if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}
if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quatity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}
if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initialize one unnamed product")
}

//#### 重写一个可失败构造器
// 1. 如同其它的构造器，你可以在子类中重写父类的可失败构造器。或者你也可以用子类的非可失败构造器重写一个父类的可失败构造器。这使你可以定义一个不会构造失败的子类，即使父类的构造器允许构造失败
// 2. 当你用子类的非可失败构造器重写父类的可失败构造器时，向上代理到父类的可失败构造器的唯一方式是对父类的可失败构造器的返回值进行强制解包。
// 3. 你可以用非可失败构造器重写可失败构造器，但反过来却不行。
class Document {
    var name: String?
    init() {}
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]" //阶段2
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}
class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}

//### 必要构造器：在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器
//### 通过闭包或函数设置属性的默认值

struct Checkerboard {
    let boardColors: [Bool] = {
        var temporary = [Bool]()
        var isBloak = false
        for i in 1...8 {
            for j in 1...8 {
                temporary.append(isBloak)
                isBloak = !isBloak
            }
            isBloak = !isBloak
        }
        return temporary
    }()
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[row * 8 + column]
    }
    subscript(row: Int, column: Int) -> Bool {
        return boardColors[row * 8 + column]
    }
}

//## 析构过程
//### 实例
class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsReqested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsReqested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

class Gamer {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}
var gamerOne: Gamer? = Gamer(coins: 100)
print("A new player has joined the game with \(gamerOne!.coinsInPurse) coins")
print("There are now \(Bank.coinsInBank) coins left in the bank")
gamerOne?.win(coins: 2_000)
print("PlayerOne won 2000 coins & now has \(gamerOne!.coinsInPurse) coins")
print("The bank now only has \(Bank.coinsInBank) coins left")
gamerOne = nil
print("There are now \(Bank.coinsInBank) coins left in the bank")

//## 自动引用计数
//### 自动引用计数的工作机制
// 1. 当你创建一个类的新的实例的时候，ARC会分配一块内存来存储该实例信息。内存中会包含实例的类型信息，以及这个实例所有相关的存储型属性的值。
// 2. 此外，当实例不再被使用时，ARC释放实例所占用的内存，并让释放的内存能挪做他用。这确保了不再被使用的实例，不会一直占用内存空间。
// 3. 当ARC收回和释放正在被使用中的实例，该实例的属性和方法都将不能再被访问和调用。实际上，如果你试图访问这个实例，你的应用程序很可能会崩溃。
// 4. 为了确保使用中的实例不会被销毁，ARC会跟踪和计算每一个实例正在被多少属性，常量和变量所引用。哪怕实例的引用数为1，ARC都不会销毁这个实例。
//自动引用计数实践

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?
reference1 = Person(name: "John Appleseed") //reference1到Person类的新实例之间建立了一个强引用
reference2 = reference1
reference3 = reference1//现在实例已经有三个强引用了
reference1 = nil
reference2 = nil
reference3 = nil //第三个强引用断开，ARC销毁它

//### 类实例之间的循环强引用
class Tenant: Person {
    var apartment: Apartment?
    
    override init(name: String) {
        self.apartment = nil
        super.init(name: name)
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    var tenant: Person?
    
    init(unit: String) { self.unit = unit }
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}
var john: Tenant?
var unit4A: Apartment?
john = Tenant(name: "John")
unit4A = Apartment(unit: "4A")
john!.apartment = unit4A
unit4A!.tenant = john
john = nil
unit4A = nil

//#### 解决实例之间的循环强引用
//##### 弱引用
// 1. 弱引用不会对其引用实例保持强引用，因而不会阻止ARC销毁被引用的实例。
// 2. 即使弱引用存在，实例也可能被销毁。因此ARC会在引用的实例被销毁后自动将其赋值为nil。
// 3. 并且因为弱引用可以允许它们的值在运行时被赋值为nil，所以它们会被定义为可选类型变量，而不是常量。
// 4. 当ARC设置若引用为nil时，属性观察器不会被触发

// weak var tenant: Person?

//##### 无主引用
// 相同点：不会牢牢保持住引用的实例。
// 不同点：
// 1. 在其他实例有相同或者更长的生命周期时使用。
// 2. 无主引用通常都被期望拥有值。不过ARC无法在实例被销毁后将无主引用设为nil，因为非可选类型的变量不允许被赋值为nil。
// 3. 使用无主引用，你必须确保引用始终指向一个未被销毁的实例。如果试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。
class Customer {   // 一个客户可能有或者没有信用卡
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}
class CreditCard {  //一张信用卡总是关联着一个客户
    let number: UInt64
    unowned let customer: Customer //所以customer不能为空，所以就不能使用weak
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit {
        print("Card #\(number) is being deinitilized")
    }
}

var Jurry: Customer? = Customer(name: "Jurry")
Jurry!.card = CreditCard(number: 1234_5678_9012_3456, customer: Jurry!)
Jurry = nil

//##### 无主引用以及隐式解析可选类型
// 1. Tenant和Apartment的例子展示了两个属性值允许为nil，并且潜在的产生循环强引用。这种场景最适合用弱引用来解决
// 2. Customer和CreditCard的例子展示了一个属性的值允许为nil，而另外一个属性值不允许为nil，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决。
// 3. 然而，存在第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为nil。在这中场景中，需要一个类无法使用无主属性，而另外一个类使用隐式解析可选属性。
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
    deinit {
        print("Country named \(name) is being deinitilized")
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    deinit {
        print("City named \(name) is being deinitilized")
    }
}

var country: Country? = Country(name: "Canada", capitalName: "Ottawa")
country = nil

//#### 闭包引起的循环强引用
// 循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例时。这个闭包体中可能访问了实例的某个属性，例如self.someProperty，或者闭包中调用了实例的某个方法，例如self.someMethod()。这两种情况都导致了闭包“捕获”self，从而产生了循环强引用。
// 强引用的产生，是因为闭包和类相似，都是引用类型。当你把一个闭包赋值给某个属性时，你是将这个闭包的引用赋值给了属性。实质上，这跟之前的问题是一样的——两个强引用让彼此一直有效。但是，和两个类实例不同，这次一个是类实例，另一个是闭包。



class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitilized")
    }
}

let defaultText = "some default text"
let heading = HTMLElement(name: "h1", text: defaultText)
print(heading.asHTML())

//#### 解决闭包引起的循环强引用
// 在定义闭包时同时定义捕获列表作为闭包的一部分，通过这种方式可以解决闭包和类实例之间的循环强引用。

//##### 定义捕获列表
// 闭包列表中的每一项由一对元素组成，一个元素是weak或unowned关键字，另一个元素是类实例的引用或初始化过的变量

/*
 lazy var someClosure: (Int, String) -> String = {
     [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
     // 这里是闭包的函数体
 }
 lazy var someClosure: Void -> String = {
     [unowned self, weak delegate = self.delegate!] in
     // 这里是闭包的函数体
 }
 */

//##### 弱引用和无主引用的选择
// 1. 在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包的捕获定义为无主引用
// 2. 相反的，在被捕获的引用可能会变为nil时，将闭包内捕获定义为弱引用。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为nil。这使我们可以在闭包体内检查它们是否存在。
// 3. 如果被捕获的引用绝对不会变为nil，应该用无主引用，而不是弱引用。

class Element {
    let name: String
    let text: String?
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
paragraph = nil
















