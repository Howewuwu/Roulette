//
//  BetLogic.swift
//  Roulette
//
//  Created by Howe on 2024/1/11.
//

import UIKit



// MARK: -  定義所有可能的下注類型
enum BetType: Equatable {
    case number(Int)         // 單個數字
    case firstTwelve         // 第一個12個數字
    case secondTwelve        // 第二個12個數字
    case thirdTwelve         // 第三個12個數字
    case red                 // 紅色
    case black               // 黑色
    case odd                 // 奇數
    case even                // 偶數
    case firstHalf           // 1 - 18
    case secondHalf          // 19 - 36
    case firstColumn         // 第一個 2 to 1
    case secondColumn        // 第二個 2 to 1
    case thirdColumn         // 第三個 2 to 1
    case split([Int])        // 分割下注（兩個數字）
    case street(Int)         // 三個數字（街道下注）
    case corner([Int])       // 四個數字（轉角下注）
    
    
    
    // BetType 枚舉中的 payoutRatio 計算屬性
    var payoutRatio: Double {
        switch self {
        case .number(_):
            // 單個數字下注的賠率是 35 倍
            return 35.0
        case .firstTwelve, .secondTwelve, .thirdTwelve, .firstColumn, .secondColumn, .thirdColumn:
            // 第一、第二、第三個 12 個數字，以及第一、第二、第三列的賠率是 2 倍
            return 2.0
        case .red, .black, .odd, .even, .firstHalf, .secondHalf:
            // 紅色、黑色、奇數、偶數、前半部（1-18）、後半部（19-36）的賠率是 1 倍
            return 1.0
        case .split(_):
            // 分割下注（兩個數字）的賠率是 17 倍
            return 17.0
        case .street(_):
            // 街道下注（三個連續數字）的賠率是 11 倍
            return 11.0
        case .corner(_):
            // 轉角下注（四個數字）的賠率是 8 倍
            return 8.0
        }
    }
}
// 在 Swift 的 switch 語句中使用 ( _ ) 是一種特殊的語法，它用於忽略該 case 中的值。
/*
 在 switch 語句中使用 .number(_)，這裡的下劃線 (_) 是一個通配符，它表示“不管這個值是什麼”。在這個情境下，您表示不關心 number 實際上是哪個數字，
 只關心它是 number 這個類型。這對於您的 payoutRatio 計算是有意義的，因為所有 .number 類型的賠率都是一樣的，不依賴於具體的數字。
 同理，.split(_) 也是這樣，這裡您不關心具體是哪兩個數字，只關心這是一個分割下注，賠率是固定的。
 */


// MARK: -  籌碼類別
class Chip {
    
    // value 屬性存儲籌碼的面值
    var value: Int
    
    // chipImage 是一個可選的 UIImage，用於表示籌碼的圖像
    var chipImage: UIImage?
    
    // 初始化方法，設置籌碼的面值和相應的圖像
    init(value: Int) {
        self.value = value  // 將傳入的值賦給 value 屬性
        
        // 根據籌碼的面值，選擇對應的圖片
        switch value {
        case 5:
            chipImage = UIImage(named: "Chip5")  // 5 值籌碼的圖片
        case 10:
            chipImage = UIImage(named: "Chip10") // 10 值籌碼的圖片
        case 15:
            chipImage = UIImage(named: "Chip15") // 15 值籌碼的圖片
        case 20:
            chipImage = UIImage(named: "Chip20") // 20 值籌碼的圖片
        case 25:
            chipImage = UIImage(named: "Chip25") // 25 值籌碼的圖片
        case 50:
            chipImage = UIImage(named: "Chip50") // 50 值籌碼的圖片
        default:
            chipImage = UIImage(named: "Allin")  // 默認的籌碼圖片
        }
    }
}



// MARK: -  下注類別
class Bet {
    
    // type 屬性表示這次下注的類型，使用前面定義的 BetType 枚舉
    var type: BetType
    
    
    // chips 是一個籌碼的陣列，表示這次下注使用的所有籌碼
    var chips: [Chip]
    // 其實不用陣列也沒關係，就算是同一種下注類型也是會以 [Bet, Bet, ...] 的方式存在 Player 裡
    // 如果不用陣列即 chips.value 代表此筆 Bet 的總額
    
    
    // 初始化方法，設置下注的類型和使用的籌碼
    init(type: BetType, chips: [Chip]) {
        self.type = type  // 設置下注類型
        self.chips = chips  // 設置使用的籌碼
    }
    
    
    // 計算屬性，用來計算這次下注的總金額
    var totalAmount: Int {
        // 使用 reduce 方法來將所有籌碼的值相加，得到總金額
        return chips.reduce(0) { $0 + $1.value }
    }
    
    
    // 方法，用於計算這次下注可能贏得的金額
    func potentialWinning() -> Double {
        // 將下注總金額轉換為 Double，並乘以下注類型的賠率
        return Double(totalAmount) * type.payoutRatio
    }
    
}



// MARK: -  玩家類別
class Player {
    
    var totalChips: Int // totalChips 屬性存儲玩家擁有的籌碼總數
    
    var bets: [Bet] // bets 是一個 Bet 類型的陣列，存儲玩家所做的所有下注
    
    
    // 初始化方法，設置玩家初始的籌碼數量
    init(totalChips: Int) {
        self.totalChips = totalChips
        self.bets = []
    }
    
    
    
    // 下注方法
    func placeBet(_ bet: Bet) {
        
        let betAmount = bet.totalAmount // 計算下注需要的籌碼總量
        if totalChips >= betAmount { // 檢查玩家的籌碼是否足夠進行這次下注
            totalChips -= betAmount // 如果足夠，從玩家的籌碼中扣除相應的數量，並將下注添加到 bets 陣列中
            bets.append(bet)
        } else {
            print("不夠籌碼下注")
        }
        print(bet.type)
    }
    
    
    
    // 檢查是否贏得下注的方法
    func checkWinning(number: Int) -> Double {
        var winnings = 0.0 // 贏得的籌碼總量
        
        // 定義輪盤上不同類型的數字 “集合”
        // 使用 Set 而不是 Array 的原因是 Set 具有唯一值的特性，且查找效率更高
        let redNumbers = Set([1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36])
        let blackNumbers = Set([2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35])
        let thirdColumn = Set([3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36])
        let secondColumn = Set([2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35])
        let firstColumn = Set([1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34])
        
        // 檢查玩家的每一次下注
        for bet in bets {
            switch bet.type {
            case .number(let betNumber) where betNumber == number:
                // 如果下注的數字與輪盤的數字匹配，則計算贏得的籌碼
                winnings += bet.potentialWinning()
                
                // 檢查其他下注類型
            case .firstTwelve where number >= 1 && number <= 12,
                 .secondTwelve where number >= 13 && number <= 24,
                 .thirdTwelve where number >= 25 && number <= 36:
                // 如果輪盤數字落在相應的範圍內，計算贏得的籌碼
                winnings += bet.potentialWinning()

            case .red where redNumbers.contains(number),
                 .black where blackNumbers.contains(number):
                // 如果輪盤數字是紅色或黑色，且與玩家下注類型匹配，計算贏得的籌碼
                winnings += bet.potentialWinning()

            case .odd where number % 2 != 0,
                 .even where number % 2 == 0 && number != 0:
                // 如果輪盤數字是奇數或偶數，且與玩家下注類型匹配，計算贏得的籌碼
                winnings += bet.potentialWinning()

            case .firstHalf where number >= 1 && number <= 18,
                 .secondHalf where number >= 19 && number <= 36:
                // 如果輪盤數字在 1-18 或 19-36 的範圍內，且與玩家下注類型匹配，計算贏得的籌碼
                winnings += bet.potentialWinning()

            case .firstColumn where firstColumn.contains(number),
                 .secondColumn where secondColumn.contains(number),
                 .thirdColumn where thirdColumn.contains(number):
                // 如果輪盤數字在特定的列中，且與玩家下注類型匹配，計算贏得的籌碼
                winnings += bet.potentialWinning()
                
            // 如果輪盤數字與分割、街道或轉角下注中的數字匹配，計算贏得的籌碼
            case .split(let numbers) where numbers.contains(number):
                winnings += bet.potentialWinning()
                
            case.street(let startNumber) where startNumber...startNumber+2 ~= number:
                winnings += bet.potentialWinning()
                
            case.corner(let numbers) where numbers.contains(number):
                
                winnings += bet.potentialWinning()

            default:
                break  // 如果沒有匹配的下注，則不進行任何操作
            }
        }
        return winnings
    }
    
    
    
    // 清除所有下注
    func clearBets() {
        let totalBetsAmount = bets.reduce(0) { $0 + $1.totalAmount }
        totalChips += totalBetsAmount
        bets.removeAll()
    }
    
    
    
    // 重覆上次的投注
    func rebet() {
        let lastBets = bets
        clearBets()
        lastBets.forEach { placeBet($0) }
    }
    
    
    
}
