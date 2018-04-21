import UIKit

//## 内存安全
//#### 内存访问冲突
//内存的访问，回发生在给变量赋值，或者传递参数给函数时。访问的冲突会发生在你的代码尝试同时访问同一个存储地址的时候。同一个存储地址的多个访问同时发生会造成不可预计或不一致的行为。
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Art/memory_shopping_2x.png
//#### 内存访问的典型状况
//内存访问冲突的三种典型的状况：访问是读还是写，访问的时长，以及被访问的存储地址。特别是当两个访问符合下列的情况时很有可能发生冲突：

//1. 至少有一个是写访问
//2. 它们访问的是同一个存储地址
//3. 它们的访问在时间线上部分重叠

//读和写访问的区别很明显：一个写访问会改变存储地址，而读操作不会。如果一个访问不可能在其访问期间被其他代码访问，那么就是一个瞬时访问。基于这个特性，两个瞬时访问是不可能同时发生的。

//然而，有几种被称为长期访问的内存访问方式，会在别的代码执行时持续进行。瞬时访问和长期访问的区别在于别的代码有没有可能在访问期间同时访问，也就是在时间线上的重叠。一个长期访问可以被别的长期访问或瞬时访问重叠。

//#### In-Out参数的访问冲突
// 一个函数会对它所有的in-out参数进行长期写访问。in-out参数的写访问会在所有非in-out参数处理完之后开始，直到函数执行完毕为止。如果有多个in-out参数，则写访问开始的顺序与参数的顺序一致。

//长期访问会造成一个结果，不能在原变量以in-out形式传入后访问原变量，即使作用域原则和访问权限允许。

var stepSize = 1
func increment(_ number: inout Int) {
    number += stepSize
}
increment(&stepSize) //错误
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Art/memory_increment_2x.png
var copyStepSize = stepSize
increment(&copyStepSize)
stepSize = copyStepSize

func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore) // 发起了两个写操作，但写入的是不同的地址
//balance(&playerOneScore, &playerOneScore) //发起了两个写操作，访问的是同一个内存地址

//#### 方法里self的访问冲突

struct Player {      // 玩家
    var name: String
    var health: Int  // 血量，受攻击时下降
    var energy: Int  // 使用技能时会下降
    
    static let maxHealth = 10
    // 对于 self 的写访问会从方法开始直到方法 return。在这种情况下，restoreHealth() 里的其它代码不可以对 Player 实例的属性发起重叠的访问。
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    //接受另一个 Player 的实例作为 in-out 参数，产生了访问重叠的可能性。
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}
var oscar = Player(name: "Oscar", health: 100, energy: 10)
var meria = Player(name: "Meria", health:20 , energy: 10)
oscar.shareHealth(with: &meria)
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Art/memory_share_health_maria_2x.png
//oscar.shareHealth(with: &oscar)
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Art/memory_share_health_oscar_2x.png


//#### 属性的访问冲突
// 若结构体、元组、枚举都是由多个独立的值组成，它们都是值类型，修改值的任何一部分都是对整个值的修改，意味着其中一个属性的读或写访问都需要访问整一个值。

var  playerInformation = (health: 10, energy: 20)
//balance(&playerInformation.health, &playerInformation.energy)
var holly = Player(name: "Holly", health: 10, energy: 10)
//balance(&holly.health, &holly.energy)


//#### 结构体属性访问所遵循的原则

// 1. 访问的是实例的存储属性，而不是计算属性或类的属性
// 2. 结构体是本地变量的值，而非全局变量
// 3. 结构体要么没有被闭包捕获，要么只被非逃逸闭包捕获了

//如果编译器无法保证访问的安全性，它就不会允许访问。

func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&oscar.health, &oscar.energy)  // 正常
}
