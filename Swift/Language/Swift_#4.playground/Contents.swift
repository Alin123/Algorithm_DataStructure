import UIKit

//## 可选链式调用
//可选链式调用是一种可以在当前值可能为nil的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是nil，那么调用将返回nil。多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为nil，整个调用链都会失败，即返回nil。

//### 使用可选链式调用替代强制展开
// 通过在想调用的属性、方法或下标的可选值后面放一个问号(?)，可以定义一个可选链。这一点很像在可选值后放一个叹号(!)来强制展开它的值。它们的主要区别在于当可选值为空时可选链式调用只会调用失败，然而强制展开将会触发运行时错误。

class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms: Int = 1
}

let john = Person()
//let roomCount = john.residence!.numberOfRooms //这会引发运行时错误
let roomCount = john.residence?.numberOfRooms   //可选链式调用的返回值必定是可选类型：Type?
if let _ = roomCount {
    print("John's residence has \(roomCount!) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
john.residence = Residence()
if let roomAmount = john.residence?.numberOfRooms {
    print("John's residence has \(roomAmount) room(s).")
}

//### 为可选链式调用定义模型类
// 通过使用可选链式调用可以调用多层属性、方法和下标。这样可以在复杂的模型中向下访问各种子属性，并且判断能否访问子属性的属性、方法或下标。
class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
}
class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}
class Apartment: Residence {
    var rooms = [Room]()
    override var numberOfRooms: Int { //重写父类的存储属性为计算属性，但不能重写父类的存储属性为存储属性
        get {
            return rooms.count
        }
        set {}
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Tenant {
    var apartment: Apartment?
}

class_getInstanceSize(Apartment.self)//40 = 24 + 8(rooms) + 8(address)
class_getInstanceSize(Residence.self)//24
var apart = Apartment()
apart.numberOfRooms = 3; print("\(apart.numberOfRooms)")

//### 通过可选链式调用访问属性
let Jerry = Tenant()
func createAddress() -> Address {
    print("Function was called.")
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    return someAddress
}
Jerry.apartment?.address = createAddress()

//### 通过可选链式调用调用方法
if Jerry.apartment?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}
// 通过可选链式调用给属性赋值会返回Void?，通过判断返回值是否为nil就可以知道赋值是否成功：
if (Jerry.apartment?.address = createAddress()) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}

//### 通过可选链式调用访问下标
if let firstRoomName = Jerry.apartment?[0].name {
    print("The first room name is \(firstRoomName)")
} else {
    print("Unable to retrieve the first room name.")
}

let JerryApart = Apartment()
JerryApart.rooms.append(Room(name: "Living Room"))
Jerry.apartment = JerryApart
if let firstRoomName = Jerry.apartment?[0].name {
    print("The first room name is \(firstRoomName)")
} else {
    print("Unable to retrieve the first room name.")
}
//#### 访问可选类型的下标
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72

//### 连接多层可选链式调用
if let JerryStreet = Jerry.apartment?.address?.street {
    print("John's street name is \(JerryStreet).")
} else {
    print("Unable to retrieve the address.")
}

//### 在方法的可选返回值上进行可选链式调用
if let beingsWithThe = Jerry.apartment?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beingsWithThe {
        print("John's building identifier begins with \"The\".")
    } else {
        print("John's building identifier does not begin with \"The\".")
    }
}

//## 错误处理
// 错误处理(Error handling)是响应错误以及从错误中恢复的过程。swift提供了在运行时对可恢复错误的抛出、捕获、传递和操作的一等公民支持。
//### 表示并抛出错误
enum VendingMachineError: Error {
    case invalidSelection                    //选择无效
    case insufficientFunds(coinsNeeded: Int) //金额不足
    case outOfStock                          //缺货
}
//### 处理错误
// 当一个函数抛出一个错误时，程序流程会发生改变，所以重要的是能迅速识别代码中会抛出错误的地方。为了标识出这些地方，在调用一个能抛出错误的函数、方法或者构造器之前，加上try关键字，或者try?或try!这种变体。

//#### 用throwing函数传递错误
struct Item {
    var price: Int
    var count: Int
}
class VendingMachine {//贩卖机
    var inventory = [ //存货清单
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pertzel": Item(price: 7, count: 11)
    ]
    var consDeposited = 0 //存放的硬币
    func dispenSanck(snack: String) {//分发零食
        print("Dispensing \(snack)")
    }
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= consDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - consDeposited)
        }
        consDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        dispenSanck(snack: name)
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels"
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchaseSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}
//#### Do-Catch处理错误
var vendingMachine = VendingMachine()
vendingMachine.consDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(coinsNeeded: let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) conis.")
}

//#### 将错误转换成可选值
// 可以使用try?通过将错误转换成一个可选值来处理错误。如果在评估try?表达式时一个错误被抛出，那么表达式的值为nil。
enum IndexError: Error {
    case TooSmall
    case TooBig
}
func validIndex(_ idx: Int) throws -> Bool {
    if idx < 0 {
        throw IndexError.TooSmall
    }
    return true
}

let valid = try? validIndex(-1)
if valid != nil && valid! == true {
    print("The index is valid.")
} else {
    print("The index isn't valid.")
}

//#### 禁用错误传递
let aIdx = 2
let result = try! validIndex(aIdx)
if result {
    print("\(aIdx) is valid index.")
} else {
    print("\(aIdx) isn't valid index.")
}

//### 指定清理操作
/*
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // 处理文件。
        }
        // close(file) 会在这里被调用，即作用域的最后。
    }
}
 */

//## 类型转换
//### 定义一个类层次作为例子
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}
class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let libraray = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

//### 检查类型：类型检查操作符(is)来检查一个实例是否属于特定子类型。

var movieCount = 0
var songCount = 0
for item in libraray {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
print("Medis library contains \(movieCount) movies and \(songCount) songs")

//### 向下转型
// 某类型的一个常量或变量可能在幕后实际上属于一个子类。当确定是这种情况时，你可以尝试向下转到它的子类型。
// 1. 当不确定向下转型可以成功时，用类型转换的条件形式(as?)。条件形式的类型转换总是返回一个可选值，并且若下转是不可能的，可选值将是nil
// 2. 可以确定向下转型一定会成功时，才使用强制形式（as!）。当你试图向下转型为一个不正确的类型时，强制形式的类型转换会触发一个运行时错误

for item in libraray {
    if let movie = item as? Movie {
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: '\(song.name)', by \(song.artist)")
    }
}

//### Any和AnyObject的类型转换
// 1. Any可以表示任何类型，包括函数类型
// 2. AnyObject可以表示任何类类型的实例
var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({(name: String) -> String in "Hello, \(name)"})

for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called '\(movie.name)', dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}

//## 嵌套类型
// 枚举常被用于为特定类或结构体实现某些功能。类似地，枚举可以方便的定义工具类或结构体，从而为某个复杂的类型所使用。
//### 嵌套类型实践
struct BlackjackCard {
    // 嵌套的Suit枚举
    enum Suit: Character {
        case spades = "♠️", hearts = "♥️", diamonds = "♦️", clubs = "♣️"
    }
    // 嵌套的Rank枚举
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values {
            let first: Int
            let second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    // BlackjackCard的属性和方法
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue)"
        output += " values is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("\(theAceOfSpades.description)")

//### 嵌套类型的使用
// 在外部引用嵌套类型时，在嵌套类型的类型名前加上其外部类型的类型名作为前缀
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
let card = (rank: BlackjackCard.Rank.two, suit: BlackjackCard.Suit.clubs)
let cardRank = card.rank.rawValue
let cardSuit = card.suit.rawValue

//## 扩展：为一个已有的类、结构体、枚举类型或者协议类型添加新功能。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即逆向建模）。
// 1. 添加计算性属性和计算型类属性
// 2. 定义实例方法和类型方法
// 3. 提供新的构造器
// 4. 定义下标
// 5. 定义和使用新的嵌套类型
// 6. 使一个已有类型符合某个协议
//### 扩展计算型属性
extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self * 1.0     }
    var cm: Double { return self / 100.0   }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
let aMarathon = 42.km + 195.m
//### 扩展遍历构造器
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

//### 扩展方法
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions(task: {
    () in
    print("Hello")
})

//#### 扩展可变实例方法
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()

//### 扩展下标
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
let digit = 456789[3]

//### 扩展嵌套类型
extension Int {
    enum Kind {
        case Negative, Zero, Positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}
func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .Negative:
            print("- ", terminator: "")
        case .Zero:
            print("0 ", terminator: "")
        case .Positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])

//## 协议：定义了个蓝图，规定了用来实现某个特定任务或者功能的方法、属性，以及其他需要的东西。类、结构体或枚举都可以遵循协议，并为协议定义的这些要求提供具体实现。某个类型能够满足某个协议的要求，就可以说该类型遵循这个协议。
//### 协议语法
protocol SomeProtocol {
    // 这里是协议的定义部分
}

//### 属性要求
// 1. 协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性。
// 2. 协议不指定属性是存储属性还是计算型属性，它只指定属性的名称和类型。此外，协议还指定属性是可读的还是可读可写的。
// 3. 如果协议要求属性是可读可写的，那么该属性不能是常量属性或只读的计算型属性。
// 4. 如果协议只要求属性是可读的，那么该属性不仅可以是可读的，还可以是可写的。
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
protocol FullyNamed {
    var fullName: String { get }
}
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")

//#### 方法要求
protocol RandomNumberGenerator {
    func random() -> Double
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}
var generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")

//#### Mutating方法要求
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        default:
            self = .off
        }
    }
}
class Swith: Togglable {
    var isOn: Bool = false
    func toggle() {
        isOn = !isOn
    }
}
//#### 构造器要求：协议可以要求遵循协议的类型实现指定的构造器
//##### 构造器要求在类中实现
// 1. 在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为遍历构造器，都必须为构造器实现标上required修饰符。
// 2. 如果类已经被标记为final，那么不需要在协议构造器的实现中使用required修饰符，因为final类不能有子类。
// 3. 如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议要求，那么该构造器的实现需要同时标注required和override修饰符：
//##### 可失败构造器要求
// 协议还可以为遵循协议的类型定义可失败构造器要求，遵循协议的类型可以通过可失败构造器(init?)或非可失败构造器(init)来满足协议中定义的可失败构造器要求。协议中定义的非可失败构造器可以通过非可失败构造器(init)或隐式解包可失败构造器(init!)来满足。
//#### 协议作为类型
// 协议可以像其他普通类型一样使用：
// 1. 作为函数、方法或构造器中的参数类型或返回值类型
// 2. 作为常量、变量或属性的类型
// 3. 作为数组、字典或其他容器中的元素类型
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
//#### 委托（代理）模式
// 委托是一种设计模式，它允许类或结构体将一些它们负责的功能委托给其他类型的实例。
protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate { // 追踪DiceGame的游戏过程
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    static let finalSquare = 25
    static var board: [Int] = {
        var temp = [Int](repeating:0, count: SnakesAndLadders.finalSquare + 1)
        
        return temp
    }()
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        while square != SnakesAndLadders.finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            if square + diceRoll > SnakesAndLadders.finalSquare {
                continue;
            }
            square += diceRoll
            square += SnakesAndLadders.board[square]
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
//#### 通过扩渣添加协议一致性
// 即便无法修改源代码，依然可以通过扩展令已有类型遵循并符合协议。扩展可以为已有类型添加属性、方法、下标以及构造器，因此可以符合协议中的相应要求。
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Int: TextRepresentable {
    var textualDescription: String {
        return "Int with value \(self)"
    }
}
extension Double: TextRepresentable {
    var textualDescription: String {
        return "Double with value \(self)"
    }
}

//#### 通过扩展遵循协议
struct Cat {
    var name: String
    var textualDescription: String {
        return "A cat names \(name)"
    }
}
extension Cat: TextRepresentable {}

//#### 协议类型的集合
let tribleThings: [TextRepresentable] = [2, 3.0, Cat(name: "Jerry")]
for thing in tribleThings {
    print(thing.textualDescription)
}
//#### 协议继承：可以在继承的协议的基础上增加新的要求。
protocol PrettyTextRepresentable: TextRepresentable {//漂亮的文字描述
    var prettyTextualDescription: String { get }
}

extension Bool: PrettyTextRepresentable {
    var textualDescription: String {
        return self ?  "is right" : "is wrong"
    }
    var prettyTextualDescription: String {
        return self ? "✅" : "❎"
    }
}
[true, false, true, false, true, false].map { (item) -> String in
    item.prettyTextualDescription
}

//#### 类类型专属协议
protocol SomeClassOnlyProtocol: class {
    
}
//#### 协议合成
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Student: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayStu = Student(name: "Shirley", age: 24)
wishHappyBirthday(to: birthdayStu)
class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}
let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)

//#### 检查协议一致性
// 检查和转换到某个协议类型在语法上和类型的检查和转换完全相同：
// 1. is用来检查实例是否符合某个协议，若符合则返回true，否则返回false.
// 2. as?返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回nil。
// 3. as!将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
protocol HasArea {
    var area: Double { get }
}
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double {
        return pi * radius * radius
    }
    init(radius: Double) {
        self.radius = radius
    }
}
class Country: HasArea {
    var area: Double
    init(area: Double) {
        self.area = area
    }
}
let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    seattle
]
for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
//#### 协议扩展
// 协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数。
//##### 提供默认实现
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And here's a random Boolean: \(generator.randomBool())")
//##### 为协议扩展添加限制条件
extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map {$0.textualDescription}
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let murrayCat = Cat(name: "Murray")
let morganCat = Cat(name: "Morgan")
let mauriceCat = Cat(name: "Maurice")
let cats = [murrayCat, morganCat, mauriceCat]
print(cats.textualDescription)
//#### 可选的协议要求
@objc protocol Aves {
    var wings: Int { get }
    @objc optional func fly()
}

class Penguin: Aves {
    var wings: Int = 2
}
class Swift: Aves {
    var wings: Int = 2
    func fly() {
        print("Swift fly with \(wings) wings!")
    }
}
var abird: Aves = Penguin()
abird.fly?()
abird = Swift()
abird.fly?()








