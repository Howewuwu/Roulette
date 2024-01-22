//
//  WheelImageView.swift
//  Roulette
//
//  Created by Howe on 2024/1/20.
//

import UIKit

class WheelImageView: UIImageView {
    
    var currentValue: Double = 0
    
    func rotateGradually(handler:@escaping (String) -> ()) {
        
        var result = ""
        
        let randomDouble = Double.random(in: 0..<2 * Double.pi) // 產生0~2pi隨機的Double數字,也就是0~360度。
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        CATransaction.begin()
        
        rotateAnimation.fromValue = currentValue
        
        currentValue = currentValue + 10 * Double.pi + randomDouble //開始到結束之,總共了5圈加上randomDouble度。
        
        let value = currentValue.truncatingRemainder(dividingBy: Double.pi * 2) //取得currentale/Doublepi*2餘數
        let degree = value * 180 / Double.pi //將弧度轉成角度
        
        switch degree{ //依照不同角度判斷轉到區塊
        case 0..<9.72:
            result="26"
        case 9.72..<19.44:
            result="3"
        case 19.44..<29.16:
            result="35"
        case 29.16..<38.88:
            result="12"
        case 38.88..<48.6:
            result="28"
        case 48.6..<58.32:
            result="7"
        case 58.32..<68.04:
            result="29"
        case 68.04..<77.76:
            result="18"
        case 77.76..<87.48:
            result="22"
        case 87.48..<97.2:
            result="9"
        case 97.2..<106.92:
            result="31"
        case 106.92..<116.64:
            result="14"
        case 116.64..<126.36:
            result="20"
        case 126.36..<136.08:
            result="1"
        case 136.08..<145.8:
            result="33"
        case 145.8..<155.52:
            result="16"
        case 155.52..<165.24:
            result="24"
        case 165.24..<174.96:
            result="5"
        case 174.96..<184.68:
            result="10"
        case 184.68..<194.4:
            result="23"
        case 194.4..<204.12:
            result="8"
        case 204.12..<213.84:
            result="30"
        case 213.84..<223.56:
            result="11"
        case 223.56..<233.28:
            result="36"
        case 233.28..<243:
            result="13"
        case 243..<252.72:
            result="27"
        case 252.72..<262.44:
            result="6"
        case 262.44..<272.16:
            result="34"
        case 272.16..<281.88:
            result="17"
        case 281.88..<291.6:
            result="25"
        case 291.6..<301.32:
            result="2"
        case 301.32..<311.04:
            result="21"
        case 311.04..<320.76:
            result="4"
        case 320.76..<330.48:
            result="19"
        case 330.48..<340.2:
            result="15"
        case 340.2..<349.92:
            result="32"
        case 349.92..<359.64:
            result="0"
            
        default:
            result="...未知的區域"
        }
        
        rotateAnimation.toValue = currentValue
        rotateAnimation.isRemovedOnCompletion = false //動畫結束後仍保在結束狀態,讓轉盤不會在動畫結束時回到最初狀態。便繼再次轉動。
        rotateAnimation.fillMode = .forwards
        rotateAnimation.duration = 4 //動畫持續時間
        rotateAnimation.repeatCount = 1 // 重複幾次
        
        CATransaction.setCompletionBlock { //跑完動後要做的事
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){//動畫結束後暫停0.3秒
                handler(result)
            }
        }
        
        rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0.9, 0.4, 1.00)//用cubic Bezier curve決定動畫速率曲線
        //也可以用內建的easeOut,但我想要最後轉一點
        
        self.layer.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    
    
    
    
    
}
