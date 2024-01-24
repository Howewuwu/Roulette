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
    
    
    
    var payoutRatio: Double {
        
        switch self {
        case .number(_):
            return 35.0
        case .firstTwelve, .secondTwelve, .thirdTwelve, .firstColumn, .secondColumn, .thirdColumn:
            return 2.0
        case .red, .black, .odd, .even, .firstHalf, .secondHalf:
            return 1.0
        case .split(_):
            return 17.0
        case .street(_):
            return 11.0
        case .corner(_):
            return 8.0
            
        }
    }
}



// MARK: -  籌碼類別
class Chip {
    
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}



// MARK: -  下注類別
class Bet {
    
    var type: BetType
    
    var chips: [Chip]
    
    
    
    init(type: BetType, chips: [Chip]) {
        self.type = type
        self.chips = chips
    }
    
    
    
    // 計算這次下注的總金額
    var totalAmount: Int {
        return chips.reduce(0) { $0 + $1.value }
    }
    
    
    
    // 計算可能贏利的方法
    func potentialWinning() -> Double {
        return Double(totalAmount) * type.payoutRatio
    }
}



// MARK: -  玩家類別
class Player {
    
    var totalChips: Int
    
    var bets: [Bet]
    
    
    
    init(totalChips: Int) {
        self.totalChips = totalChips
        self.bets = []
    }
    
    
    
    // 下注方法
    func placeBet(_ bet: Bet) {
        // 需要確保玩家有足夠的籌碼進行下注
        let betAmount = bet.totalAmount
        if totalChips >= betAmount {
            totalChips -= betAmount
            bets.append(bet)
        } else {
            print("不夠籌碼下注")
        }
        
        print(bet.type)
    }
    
    
    
    // 檢查是否贏得下注
    func checkWinning(number: Int) -> Double {
        var winnings = 0.0

        let redNumbers = Set([1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36])
        let blackNumbers = Set([2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35])
        let thirdColumn = Set([3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36])
        let secondColumn = Set([2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35])
        let firstColumn = Set([1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34])

        for bet in bets {
            switch bet.type {
            case .number(let betNumber) where betNumber == number:
                winnings += bet.potentialWinning()

            case .firstTwelve where number >= 1 && number <= 12,
                 .secondTwelve where number >= 13 && number <= 24,
                 .thirdTwelve where number >= 25 && number <= 36:
                winnings += bet.potentialWinning()

            case .red where redNumbers.contains(number),
                 .black where blackNumbers.contains(number):
                winnings += bet.potentialWinning()

            case .odd where number % 2 != 0,
                 .even where number % 2 == 0 && number != 0:
                winnings += bet.potentialWinning()

            case .firstHalf where number >= 1 && number <= 18,
                 .secondHalf where number >= 19 && number <= 36:
                winnings += bet.potentialWinning()

            case .firstColumn where firstColumn.contains(number),
                 .secondColumn where secondColumn.contains(number),
                 .thirdColumn where thirdColumn.contains(number):
                winnings += bet.potentialWinning()

            case .split(let numbers) where numbers.contains(number):
                winnings += bet.potentialWinning()

            case .street(let startNumber) where startNumber...startNumber+2 ~= number:
                winnings += bet.potentialWinning()

            case .corner(let numbers) where numbers.contains(number):
                winnings += bet.potentialWinning()

            default:
                break
            }
        }

        return winnings
    }

    
    
    // 清除所有下注
    func clearBets() {
        var totalBetsAmount = bets.reduce(0) { $0 + $1.totalAmount }
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
