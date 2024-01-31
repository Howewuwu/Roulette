//
//  RouletteViewController.swift
//  Roulette
//
//  Created by Howe on 2024/1/8.
//

import UIKit
import AVFoundation


// 同時實現UIPickerView的DataSource和Delegate接口，用於管理chipPicker的數據和行為。
class RouletteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // 定義UI元件和變量。
    // mainContainerView為主要容器視圖，用於包含其他子視圖。
    let mainContainerView = UIView()
    let mainStackView = UIStackView() // 主StackView，用於水平排列子視圖。
    let rightSideStackView = UIStackView() // 右側StackView，用於垂直排列右側的視圖。
    var rightSideViews = [UIView]() // 存儲右側的視圖。
    let leftSideStackView = UIStackView() // 左側StackView，用於垂直排列左側的視圖。
    var leftSideViews = [UIView]() // 存儲左側的視圖。
    let zeroView = UIView() // 顯示0的視圖。
    let numbers3ColumnStackView = UIStackView() // 用於第三列數字的StackView。
    let numbers2ColumnStackView = UIStackView() // 用於第二列數字的StackView。
    let numbers1ColumnStackView = UIStackView() // 用於第一列數字的StackView。
    var numberViews = [UIView]() // 存儲數字視圖。
    let twoToOneStackView = UIStackView() // “2 to 1”的StackView。
    var twoToOneViews = [UIView]() // 存儲“2 to 1”選項的視圖。
    
    let pickerContainerView = UIView() // 存儲籌碼選擇器的容器視圖。
    let chipPicker = UIPickerView() // 籌碼選擇器。
    let chipValues = ["Chip5", "Chip10", "Chip15", "Chip20", "Chip25", "Chip50", "Allin"] // 籌碼的值。
    var chipImage = UIImage() // 選中的籌碼圖像。
    var selectChipValue = 5 // 選中的籌碼值，默認為5。
    var totalBetAmount = 0 // 總下注金額。
    var singleBetChip = 0 // 單次下注籌碼數。
    var singleBetAmountLabel = UILabel() // 顯示單次下注金額的標籤。
    
    // 音效播放相關。
    let SfxPlayer = AVPlayer() // 音效播放器。
    // 音效文件的URL。
    let chipSfxUrl = Bundle.main.url(forResource: "chipscasinobet", withExtension: "wav")
    let spinSfxUrl = Bundle.main.url(forResource: "Digital Casino Short Roulette Spin", withExtension: "wav")
    
    // 顯示總下注金額和總金額的標籤。
    var totalBetMoneyLabel = UILabel()
    var totalMoneyLabel = UILabel()
    
    // 數字和顏色的數據。
    let numbers3ColumnArray = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36]
    let numbers2ColumnArray = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35]
    let numbers1ColumnArray = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]
    let redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
    let blackNumbers = [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]
    
    // 玩家類別的實例，初始籌碼為1000。
    var player = Player(totalChips: 1000)
    
    // 控制按鈕：移除下注、重新下注、轉動輪盤。
    let removeBetButton = UIButton()
    let reBetButton = UIButton()
    let spinButton = UIButton()
    
    // 保存不同類型下注按鈕的數組。
    // var betButtonZeros = [UIButton]()
    var betButtonRightSides = [UIButton]()
    var betButtonLeftSides = [UIButton]()
    var betButton2To1Sides = [UIButton]()
    var betButtonINTs = [UIButton]()
    var betButtonUpSplits = [UIButton]()
    var betButtonSpiltOrStreets = [UIButton]()
    var betButtonCorners = [UIButton]()
    
    // 輪盤視圖和結果顯示相關。
    let wheelContainerView = UIView()
    let wheelImageView = WheelImageView() // 輪盤圖像視圖。
    let resultLabel = UILabel() // 顯示結果的標籤。
    var resultNumber = 0 // 輪盤結果數字。
    var checkFinal = 0 // 最終結果。
    var checkFinalLabel = UILabel() // 顯示最終結果的標籤。
    
    // 存儲最後一次下注。
    var theLastBets = [Bet]()
    
    // 存儲輪盤結果數字的數組。
    var resultNumbers = [Int]()
    
    // 顯示結果的容器視圖和標籤。
    let displayContainerView = UIView()
    var displayLabel = UILabel()
    
    
    
    // MARK: - viewDidLoad Section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定初始UI界面。
        setupInitialUI()
        
        // 設定籌碼選擇器。
        setupChipPicker()
        
        // 設定顯示結果。
        setupDisplayResult()
        
        // 為NotificationCenter添加觀察者，以便在籌碼總額變化時接收通知。
        NotificationCenter.default.addObserver(self, selector: #selector(totalChipsDidChange), name: .totalChipsDidChange, object: nil)
        
    }
    
    // MARK: - UIsetting Function Section
    func setupInitialUI() { // setupInitialUI方法用於設定初始的用戶界面。
        
        // 設定視圖控制器的背景顏色。
        view.backgroundColor = .systemGreen
        
        // 主容器視圖的邊框和自動布局設定。
        mainContainerView.layer.borderColor = UIColor.white.cgColor
        mainContainerView.layer.borderWidth = 0
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定主StackView的軸線、間距、對齊方式和分佈方式。
        mainStackView.axis = .horizontal
        mainStackView.spacing = 0
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.layer.borderColor = UIColor.white.cgColor
        
        // 0號視圖的設定。
        zeroView.backgroundColor = .clear
        zeroView.layer.borderColor = UIColor.white.cgColor
        zeroView.layer.borderWidth = 2
        zeroView.translatesAutoresizingMaskIntoConstraints = false
        
        // 創建並設定0號標籤。
        let zeroLabel = UILabel()
        zeroLabel.text = "0"
        zeroLabel.font = UIFont.boldSystemFont(ofSize: 18)
        zeroLabel.textColor = .white
        zeroLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 創建並設定0號下注按鈕。
        let betButtonZero = UIButton()
        betButtonZero.translatesAutoresizingMaskIntoConstraints = false
        betButtonZero.backgroundColor = .clear
        betButtonZero.tag = 0
        // 為按鈕添加觸摸事件。
        betButtonZero.addTarget(self, action: #selector(betButtonZeroTouched), for: .touchDown)
        betButtonZero.addTarget(self, action: #selector(betButtonZeroReleased), for: .touchUpInside)
        betButtonINTs.append(betButtonZero)
        
        // 右側StackView的設定。
        rightSideStackView.axis = .vertical
        rightSideStackView.spacing = 0
        rightSideStackView.alignment = .fill
        rightSideStackView.distribution = .fillEqually
        rightSideStackView.layer.borderWidth = 1.5
        rightSideStackView.layer.borderColor = UIColor.white.cgColor
        rightSideStackView.translatesAutoresizingMaskIntoConstraints = false
        createRightSide()
        
        // 左側StackView的設定。
        leftSideStackView.axis = .vertical
        leftSideStackView.spacing = 0
        leftSideStackView.alignment = .fill
        leftSideStackView.distribution = .fillEqually
        leftSideStackView.layer.borderWidth = 1.5
        leftSideStackView.layer.borderColor = UIColor.white.cgColor
        leftSideStackView.translatesAutoresizingMaskIntoConstraints = false
        createLeftSide()
        
        // 設定三個列數字的StackView。
        numbers3ColumnStackView.axis = .vertical
        numbers3ColumnStackView.spacing = 0
        numbers3ColumnStackView.alignment = .fill
        numbers3ColumnStackView.distribution = .fillEqually
        numbers3ColumnStackView.clipsToBounds = false
        numbers3ColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        createNumberColumn(numbers: numbers3ColumnArray, numbersStackView: numbers3ColumnStackView)
        
        numbers2ColumnStackView.axis = .vertical
        numbers2ColumnStackView.spacing = 0
        numbers2ColumnStackView.alignment = .fill
        numbers2ColumnStackView.distribution = .fillEqually
        numbers2ColumnStackView.clipsToBounds = false
        numbers2ColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        createNumberColumn(numbers: numbers2ColumnArray, numbersStackView: numbers2ColumnStackView)
        
        numbers1ColumnStackView.axis = .vertical
        numbers1ColumnStackView.spacing = 0
        numbers1ColumnStackView.alignment = .fill
        numbers1ColumnStackView.distribution = .fillEqually
        numbers1ColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        createNumberColumn(numbers: numbers1ColumnArray, numbersStackView: numbers1ColumnStackView)
        
        // 2 to 1視圖的設定。
        twoToOneStackView.axis = .horizontal
        twoToOneStackView.spacing = -2
        twoToOneStackView.alignment = .fill
        twoToOneStackView.distribution = .fillEqually
        twoToOneStackView.translatesAutoresizingMaskIntoConstraints = false
        create2To1View()
        
        // 總金額和總下注金額標籤的設定。
        totalMoneyLabel.text = "  TOTAL MONEY: $ \(player.totalChips)  "
        totalMoneyLabel.textColor = .white
        totalMoneyLabel.font = UIFont.boldSystemFont(ofSize: 13)
        totalMoneyLabel.backgroundColor = .black
        totalMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        totalBetMoneyLabel.text = "  BET TOTAL MONEY: $ \(totalBetAmount)  "
        totalBetMoneyLabel.textColor = .systemRed
        totalBetMoneyLabel.font = UIFont.boldSystemFont(ofSize: 13)
        totalBetMoneyLabel.backgroundColor = .black
        totalBetMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 移除下注、重新下注和旋轉按鈕的設定。
        removeBetButton.configuration = .filled()
        removeBetButton.setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        removeBetButton.tintColor = .systemRed
        removeBetButton.addTarget(self, action: #selector(removeBetButtonTouched), for: .touchDown)
        removeBetButton.addTarget(self, action: #selector(removeBetButtonReleased), for: .touchUpInside)
        removeBetButton.translatesAutoresizingMaskIntoConstraints = false
        
        reBetButton.configuration = .filled()
        reBetButton.setImage(UIImage(systemName: "arrowshape.turn.up.left.circle.fill"), for: .normal)
        reBetButton.tintColor = .black
        reBetButton.addTarget(self, action: #selector(reBetButtonTouched), for: .touchDown)
        reBetButton.addTarget(self, action: #selector(reBetButtonReleased), for: .touchUpInside)
        reBetButton.translatesAutoresizingMaskIntoConstraints = false
        
        spinButton.configuration = .filled()
        spinButton.setImage(UIImage(systemName: "play.square.fill"), for: .normal)
        spinButton.tintColor = .systemYellow
        spinButton.addTarget(self, action: #selector(spinButtonTouched), for: .touchDown)
        spinButton.addTarget(self, action: #selector(spinButtonReleased), for: .touchUpInside)
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 最終結果標籤的設定。
        checkFinalLabel.text = ""
        checkFinalLabel.font = UIFont.boldSystemFont(ofSize: 40)
        checkFinalLabel.textColor = .white
        checkFinalLabel.adjustsFontSizeToFitWidth = true
        checkFinalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        // 將定義的UI元件添加到視圖上。
        view.addSubview(zeroView) // 將zeroView添加到主視圖上。
        zeroView.addSubview(zeroLabel) // 將zeroLabel添加到zeroView上。
        view.addSubview(mainContainerView) // 將mainContainerView添加到主視圖上。
        mainContainerView.addSubview(mainStackView) // 將mainStackView添加到mainContainerView上。
        
        // 將左側、數字列和右側StackView添加到主StackView上。
        mainStackView.addArrangedSubview(leftSideStackView)
        mainStackView.addArrangedSubview(numbers1ColumnStackView)
        mainStackView.addArrangedSubview(numbers2ColumnStackView)
        mainStackView.addArrangedSubview(numbers3ColumnStackView)
        mainStackView.addArrangedSubview(rightSideStackView)
        
        // 將其他UI元件添加到主視圖上。
        view.addSubview(twoToOneStackView)
        view.addSubview(totalMoneyLabel)
        view.addSubview(totalBetMoneyLabel)
        zeroView.addSubview(betButtonZero) // 將下注按鈕添加到zeroView上。
        view.addSubview(removeBetButton)
        view.addSubview(reBetButton)
        view.addSubview(spinButton)
        view.addSubview(checkFinalLabel)
        
        // 使用Auto Layout設定UI元件的位置和尺寸。
        NSLayoutConstraint.activate([
            // 設定mainContainerView的位置和尺寸。
            mainContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            mainContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110),
            
            // 設定mainStackView以填滿mainContainerView。
            mainStackView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            
            // 設定zeroView的位置和尺寸。
            zeroView.leadingAnchor.constraint(equalTo: numbers1ColumnStackView.leadingAnchor, constant: -1),
            zeroView.trailingAnchor.constraint(equalTo: numbers3ColumnStackView.trailingAnchor, constant: 1),
            zeroView.heightAnchor.constraint(equalTo: numbers1ColumnStackView.widthAnchor),
            zeroView.bottomAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 1),
            
            // 設定zeroLabel居中於zeroView。
            zeroLabel.centerXAnchor.constraint(equalTo: zeroView.centerXAnchor),
            zeroLabel.centerYAnchor.constraint(equalTo: zeroView.centerYAnchor),
            
            // 設定twoToOneStackView的位置和尺寸。
            twoToOneStackView.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -2),
            twoToOneStackView.leadingAnchor.constraint(equalTo: numbers1ColumnStackView.leadingAnchor, constant: -1),
            twoToOneStackView.trailingAnchor.constraint(equalTo: numbers3ColumnStackView.trailingAnchor, constant: 1),
            twoToOneStackView.heightAnchor.constraint(equalTo: numbers1ColumnStackView.widthAnchor),
            
            // 設定總金額和總下注金額標籤的位置。
            totalMoneyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalMoneyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            totalBetMoneyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalBetMoneyLabel.bottomAnchor.constraint(equalTo: totalMoneyLabel.topAnchor, constant: -5),
            
            // 設定下注按鈕的位置和尺寸。
            betButtonZero.centerXAnchor.constraint(equalTo: zeroView.centerXAnchor),
            betButtonZero.centerYAnchor.constraint(equalTo: zeroView.centerYAnchor),
            betButtonZero.widthAnchor.constraint(equalTo: zeroView.widthAnchor, multiplier: 0.19),
            betButtonZero.heightAnchor.constraint(equalTo: zeroView.heightAnchor, multiplier: 0.56),
            
            // 設定移除下注、重新下注和旋轉按鈕的位置。
            removeBetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            removeBetButton.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            removeBetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            reBetButton.bottomAnchor.constraint(equalTo: removeBetButton.topAnchor, constant: -10),
            reBetButton.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            reBetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            spinButton.topAnchor.constraint(equalTo: removeBetButton.bottomAnchor, constant: 10),
            spinButton.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            spinButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            // 設定最終結果標籤的位置。
            checkFinalLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            checkFinalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    
    // createRightSide 函數：設定右側的 UIStackView、視圖和按鈕。
    func createRightSide() {
        
        // 循環創建3個部分（1ST 12, 2ND 12, 3RD 12）。
        for i in 1...3 {
            let sectionView = UIView() // 創建一個新視圖作為部分。
            sectionView.backgroundColor = .clear
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 1
            rightSideViews.append(sectionView) // 將視圖添加到rightSideViews數組中。
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel() // 創建標籤顯示文本。
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let betButtonRightSide = UIButton() // 創建按鈕用於下注。
            betButtonRightSide.translatesAutoresizingMaskIntoConstraints = false
            betButtonRightSide.backgroundColor = .clear
            // 為按鈕添加觸摸事件。
            betButtonRightSide.addTarget(self, action: #selector(betButtonRightSideTouched(_:)), for: .touchDown)
            betButtonRightSide.addTarget(self, action: #selector(betButtonRightSideReleased(_:)), for: .touchUpInside)
            betButtonRightSides.append(betButtonRightSide) // 將按鈕添加到數組中。
            
            // 根據i的值設定標籤文本和按鈕標籤。
            switch i {
            case 1 :
                sectionLabel.text = "1ST 12"
                betButtonRightSide.tag = 1
            case 2 :
                sectionLabel.text = "2ND 12"
                betButtonRightSide.tag = 2
            case 3 :
                sectionLabel.text = "3RD 12"
                betButtonRightSide.tag = 3
            default :
                break
            }
            
            rightSideStackView.addArrangedSubview(sectionView) // 將視圖添加到StackView中。
            sectionView.addSubview(sectionLabel) // 將標籤添加到視圖中。
            sectionView.addSubview(betButtonRightSide) // 將按鈕添加到視圖中。
            
            // 設定Auto Layout約束。
            NSLayoutConstraint.activate([
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonRightSide.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonRightSide.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonRightSide.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.6),
                betButtonRightSide.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.14)
            ])
            sectionLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // 將標籤旋轉90度。
        }
    }
    
    
    // createLeftSide 函數：設定左側的 UIStackView、視圖和按鈕。
    func createLeftSide() {
        
        // 循環創建6個部分（1 - 18, EVEN, RED, BLACK, ODD, 19 - 36）。
        for i in 1...6 {
            let sectionView = UIView()
            sectionView.backgroundColor = .clear
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 1
            leftSideViews.append(sectionView) // 將視圖添加到leftSideViews數組中。
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel() // 創建標籤。
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let betButtonLeftSide = UIButton() // 創建按鈕。
            betButtonLeftSide.translatesAutoresizingMaskIntoConstraints = false
            betButtonLeftSide.backgroundColor = .clear
            // 為按鈕添加觸摸事件。
            betButtonLeftSide.addTarget(self, action: #selector(betButtonLeftSideTouched(_:)), for: .touchDown)
            betButtonLeftSide.addTarget(self, action: #selector(betButtonLeftSideReleased(_:)), for: .touchUpInside)
            betButtonLeftSides.append(betButtonLeftSide) // 將按鈕添加到數組中。
            
            // 根據i的值設定標籤文本和按鈕標籤。
            switch i {
            case 1 :
                sectionLabel.text = "1 - 18"
                betButtonLeftSide.tag = 1
            case 2 :
                sectionLabel.text = "EVEN"
                betButtonLeftSide.tag = 2
            case 3 :
                // 特殊情況：紅色菱形視圖。
                sectionLabel.text = ""
                betButtonLeftSide.tag = 3
                let diamondView = UIView() // 創建菱形視圖。
                diamondView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4) // 旋轉菱形視圖。
                diamondView.layer.borderColor = UIColor.white.cgColor
                diamondView.layer.borderWidth = 2
                diamondView.translatesAutoresizingMaskIntoConstraints = false
                diamondView.backgroundColor = .systemRed
                sectionView.backgroundColor = .clear
                sectionView.addSubview(diamondView) // 將菱形視圖添加到sectionView中。
                
                // 設定菱形視圖的Auto Layout約束。
                NSLayoutConstraint.activate([
                    diamondView.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                    diamondView.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                    diamondView.widthAnchor.constraint(equalToConstant: 30),
                    diamondView.heightAnchor.constraint(equalToConstant: 30)
                ])
            case 4 :
                // 特殊情況：黑色菱形視圖。
                sectionLabel.text = ""
                betButtonLeftSide.tag = 4
                let diamondView = UIView() // 創建菱形視圖。
                diamondView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4) // 旋轉菱形視圖。
                diamondView.layer.borderColor = UIColor.white.cgColor
                diamondView.layer.borderWidth = 2
                diamondView.translatesAutoresizingMaskIntoConstraints = false
                diamondView.backgroundColor = .black
                sectionView.backgroundColor = .clear
                sectionView.addSubview(diamondView) // 將菱形視圖添加到sectionView中。
                
                // 設定菱形視圖的Auto Layout約束。
                NSLayoutConstraint.activate([
                    diamondView.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                    diamondView.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                    diamondView.widthAnchor.constraint(equalToConstant: 30),
                    diamondView.heightAnchor.constraint(equalToConstant: 30)
                ])
            case 5 :
                sectionLabel.text = "ODD"
                betButtonLeftSide.tag = 5
            case 6 :
                sectionLabel.text = "19 -36"
                betButtonLeftSide.tag = 6
            default :
                break
            }
            
            leftSideStackView.addArrangedSubview(sectionView) // 將視圖添加到StackView中。
            sectionView.addSubview(sectionLabel) // 將標籤添加到視圖中。
            sectionView.addSubview(betButtonLeftSide) // 將按鈕添加到視圖中。
            
            // 設定Auto Layout約束。
            NSLayoutConstraint.activate([
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonLeftSide.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonLeftSide.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonLeftSide.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.6),
                betButtonLeftSide.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.27)
            ])
            sectionLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // 將標籤旋轉90度。
        }
    }
    
    
    // 數字區域的 UIStackView, View, Button Setting
    func createNumberColumn(numbers: [Int], numbersStackView: UIStackView) {
        
        // 遍歷傳入的數字陣列。
        for number in numbers {
            let sectionView = UIView() // 創建一個代表單個數字的視圖。
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 1
            sectionView.clipsToBounds = false
            sectionView.tag = number // 使用數字作為標籤，用於識別。
            numberViews.append(sectionView) // 將視圖添加到numberViews數組。
            numberViews.sort { $0.tag < $1.tag } // 根據標籤排序視圖。
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel() // 創建顯示數字的標籤。
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.clipsToBounds = false
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // 根據數字設定視圖的背景顏色和標籤文本。
            switch number {
            case 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36:
                sectionLabel.text = "\(number)"
                sectionView.backgroundColor = .systemRed
            case 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35:
                sectionLabel.text = "\(number)"
                sectionView.backgroundColor = .black
            default:
                break
            }
            
            // 創建並配置下注按鈕。
            let betButtonINT = UIButton()
            betButtonINT.clipsToBounds = true
            betButtonINT.tag = number
            betButtonINT.translatesAutoresizingMaskIntoConstraints = false
            betButtonINT.backgroundColor = .clear
            betButtonINT.addTarget(self, action: #selector(betButtonINTTouched(_:)), for: .touchDown)
            betButtonINT.addTarget(self, action: #selector(betButtonINTReleased(_:)), for: .touchUpInside)
            betButtonINTs.append(betButtonINT)
            
            // 創建並配置分割線下注按鈕。
            let betButtonUpSplit = UIButton()
            betButtonUpSplit.clipsToBounds = false
            betButtonUpSplit.tag = number
            betButtonUpSplit.translatesAutoresizingMaskIntoConstraints = false
            betButtonUpSplit.backgroundColor = .clear
            betButtonUpSplit.addTarget(self, action: #selector(betButtonUpSplitTouched), for: .touchDown)
            betButtonUpSplit.addTarget(self, action: #selector(betButtonUpSplitReleased), for: .touchUpInside)
            betButtonUpSplits.append(betButtonUpSplit)
            
            // 創建並配置左側分割或街道下注按鈕。
            let betButtonLeftSpiltOrStreet = UIButton()
            betButtonLeftSpiltOrStreet.tag = number
            betButtonLeftSpiltOrStreet.translatesAutoresizingMaskIntoConstraints = false
            betButtonLeftSpiltOrStreet.backgroundColor = .clear
            betButtonSpiltOrStreets.append(betButtonLeftSpiltOrStreet)
            
            // 根據所處的列為按鈕添加對應的觸摸事件。
            if numbersStackView == numbers1ColumnStackView {
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonStreetTouched), for: .touchDown)
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonStreetReleased), for: .touchUpInside)
            } else {
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonLeftSplitTouched), for: .touchDown)
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonLeftSplitReleased), for: .touchUpInside)
            }
            
            // 創建並配置角落下注按鈕。
            let betButtonCorner = UIButton()
            betButtonCorner.tag = number
            betButtonCorner.translatesAutoresizingMaskIntoConstraints = false
            betButtonCorner.backgroundColor = .clear
            betButtonCorner.clipsToBounds = false
            betButtonCorners.append(betButtonCorner)
            
            if numbersStackView != numbers1ColumnStackView {
                betButtonCorner.addTarget(self, action: #selector(betButtonCornerTouched), for: .touchDown)
                betButtonCorner.addTarget(self, action: #selector(betButtonCornerReleased), for: .touchUpInside)
            }
            
            // 將視圖和按鈕添加到StackView中。
            numbersStackView.addArrangedSubview(sectionView)
            sectionView.addSubview(sectionLabel)
            sectionView.addSubview(betButtonINT)
            numbersStackView.addSubview(betButtonUpSplit)
            numbersStackView.addSubview(betButtonLeftSpiltOrStreet)
            numbersStackView.addSubview(betButtonCorner)
            
            
            // 設定Auto Layout約束。
            NSLayoutConstraint.activate([
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                
                betButtonINT.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonINT.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonINT.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.58),
                betButtonINT.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.56),
                
                betButtonUpSplit.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                //                betButtonUpSplit.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: -13.3),
                //                betButtonUpSplit.bottomAnchor.constraint(equalTo: sectionView.topAnchor, constant: 13),
                betButtonUpSplit.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor, constant: -25),
                //                betButtonUpSplit.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: 13),
                //                betButtonUpSplit.topAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -13),
                
                betButtonUpSplit.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.58),
                betButtonUpSplit.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.56),
                
                betButtonLeftSpiltOrStreet.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonLeftSpiltOrStreet.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: -13.3),
                betButtonLeftSpiltOrStreet.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.58),
                betButtonLeftSpiltOrStreet.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.56),
                
                betButtonCorner.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: -13.3),
                betButtonCorner.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: -13.3),
                betButtonCorner.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.58),
                betButtonCorner.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.56),
                
            ])
        }
    }
    
    
    // 2: 1 區域的 UIStackView, View, Button Setting
    func create2To1View() {
        // 遍歷三次來創建三個 "2 : 1" 下注選項。
        for i in 1...3 {
            let sectionView = UIView() // 創建代表單個 "2 : 1" 選項的視圖。
            sectionView.backgroundColor = .clear
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 2
            twoToOneViews.append(sectionView) // 將視圖添加到twoToOneViews數組。
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel() // 創建標籤顯示 "2 : 1" 文字。
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.text = "2 : 1"
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let betButton2To1Side = UIButton() // 創建用於下注的按鈕。
            betButton2To1Side.translatesAutoresizingMaskIntoConstraints = false
            betButton2To1Side.backgroundColor = .clear
            betButton2To1Side.tag = i
            // 為按鈕添加觸摸事件。
            betButton2To1Side.addTarget(self, action: #selector(betButton2To1Touched(_:)), for: .touchDown)
            betButton2To1Side.addTarget(self, action: #selector(betButton2To1Released(_:)), for: .touchUpInside)
            betButton2To1Sides.append(betButton2To1Side) // 將按鈕添加到數組中。
            
            // 將視圖和標籤、按鈕添加到 "2 : 1" StackView。
            twoToOneStackView.addArrangedSubview(sectionView)
            sectionView.addSubview(sectionLabel)
            sectionView.addSubview(betButton2To1Side)
            
            // 設定Auto Layout約束。
            NSLayoutConstraint.activate([
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButton2To1Side.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButton2To1Side.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButton2To1Side.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.58),
                betButton2To1Side.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.56)
            ])
        }
    }
    
    
    
    // MARK: - Display ResultNumber Function Section
    func setupDisplayResult() {
        
        // 設定displayContainerView的Auto Layout約束，以便它可以正確地放置和調整大小。
        displayContainerView.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 設定displayContainerView的外觀和樣式。
        displayContainerView.backgroundColor = .gray // 背景顏色設為灰色。
        displayContainerView.layer.cornerRadius = 20 // 圓角半徑設為20。
        displayContainerView.layer.borderWidth = 1 // 邊框寬度設為1。
        displayContainerView.layer.borderColor = UIColor.white.cgColor // 邊框顏色設為白色。
        
        // 設定displayLabel的初始文本和樣式。
        displayLabel.text = "" // 初始文本為空。
        displayLabel.font = UIFont.boldSystemFont(ofSize: 20) // 字體大小和樣式。
        displayLabel.textAlignment = .center // 文本對齊方式為居中。
        displayLabel.numberOfLines = 0 // 允許多行顯示。
        displayLabel.textColor = .white // 文本顏色為白色。
        displayLabel.adjustsFontSizeToFitWidth = true // 調整字體大小以適應寬度。
        
        // 將displayContainerView和displayLabel添加到視圖中。
        view.addSubview(displayContainerView)
        displayContainerView.addSubview(displayLabel)
        
        // 使用Auto Layout約束確定displayContainerView和displayLabel的位置和大小。
        NSLayoutConstraint.activate([
            // 定位displayContainerView。
            displayContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayContainerView.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            displayContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            displayContainerView.bottomAnchor.constraint(equalTo: reBetButton.topAnchor, constant: -20),
            
            // 定位displayLabel在displayContainerView中居中。
            displayLabel.centerXAnchor.constraint(equalTo: displayContainerView.centerXAnchor),
            displayLabel.topAnchor.constraint(equalTo: displayContainerView.topAnchor, constant: 8)
        ])
    }
    
    
    // displayResultNumber 函數：顯示輪盤的結果數字。
    func displayResultNumber(resultNumber: Int) {
        
        // 將新的結果數字添加到resultNumbers數組中。
        resultNumbers.append(resultNumber)
        
        // 如果結果數組的數量超過11，則移除最舊的數字，以保持顯示的數字量不超過11個。
        if resultNumbers.count > 11 {
            resultNumbers.removeFirst()
        }
        
        // 創建一個NSMutableAttributedString，用於富文本格式的顯示。
        let attributedString = NSMutableAttributedString()
        
        // 反向遍歷resultNumbers數組，以便最新的數字顯示在最上方。
        for number in resultNumbers.reversed() {
            // 定義一個顏色變數，根據數字決定顏色。
            let color: UIColor
            
            // 如果數字為0，顏色設為綠色；否則，根據數字是紅色還是黑色來設定顏色。
            if number == 0 {
                color = .systemGreen
            } else {
                color = redNumbers.contains(number) ? .systemRed : .black
            }
            
            // 創建NSAttributedString，並為數字設定顏色。
            let numberString = NSAttributedString(string: "\(number)\n", attributes: [NSAttributedString.Key.foregroundColor: color])
            attributedString.append(numberString) // 將這個帶有顏色的數字添加到富文本字符串中。
        }
        
        // 將整理好的富文本字符串設定給displayLabel的attributedText，以在界面上顯示。
        displayLabel.attributedText = attributedString
    }
    
    
    
    // MARK: - UIPicker Function Section
    func setupChipPicker() {
        
        // 設定chipPicker的數據源和代理為當前的視圖控制器。
        chipPicker.dataSource = self
        chipPicker.delegate = self
        chipPicker.translatesAutoresizingMaskIntoConstraints = false // 使用Auto Layout，禁用舊的自動尺寸調整轉換。
        
        // 設定pickerContainerView的樣式和布局。
        pickerContainerView.backgroundColor = .gray // 設定背景顏色為灰色。
        pickerContainerView.layer.borderWidth = 1 // 設定邊框寬度。
        pickerContainerView.layer.borderColor = UIColor.white.cgColor // 設定邊框顏色為白色。
        pickerContainerView.layer.cornerRadius = 10 // 設定圓角半徑。
        pickerContainerView.translatesAutoresizingMaskIntoConstraints = false // 使用Auto Layout。
        
        // 將pickerContainerView和chipPicker添加到主視圖。
        view.addSubview(pickerContainerView)
        pickerContainerView.addSubview(chipPicker)
        
        // 使用Auto Layout約束確定pickerContainerView和chipPicker的位置和大小。
        NSLayoutConstraint.activate([
            // 定位pickerContainerView。
            pickerContainerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor),
            pickerContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            pickerContainerView.widthAnchor.constraint(equalToConstant: 50),
            pickerContainerView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.4),
            
            // 定位chipPicker在pickerContainerView中居中。
            chipPicker.centerXAnchor.constraint(equalTo: pickerContainerView.centerXAnchor),
            chipPicker.centerYAnchor.constraint(equalTo: pickerContainerView.centerYAnchor),
            chipPicker.widthAnchor.constraint(equalTo: pickerContainerView.widthAnchor),
            chipPicker.heightAnchor.constraint(equalTo: pickerContainerView.heightAnchor)
        ])
    }
    
    
    // numberOfComponents(in:) 方法：返回UIPickerView的組件數量。
    // 在這個案例中，我們只有一個組件來顯示不同的籌碼選項。
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // pickerView(_:numberOfRowsInComponent:) 方法：返回給定組件中的行數。
    // 這決定了pickerView中顯示的籌碼選項數量。
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chipValues.count // chipValues數組中的元素數量決定了行數。
    }
    
    
    // pickerView(_:viewForRow:forComponent:reusing:) 方法：為pickerView的每一行提供一個視圖。
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 根據當前行的索引從chipValues數組中獲取對應的籌碼圖像名稱。
        let image = UIImage(named: chipValues[row])
        chipImage = image! // 更新當前選擇的籌碼圖像（這裡可以當作剛開始還未選擇 pickerView 時的預設顯示籌碼 5 元）
        
        let imageView = UIImageView() // 創建一個新的UIImageView來顯示籌碼圖像。
        imageView.image = image // 設定圖像。
        imageView.contentMode = .scaleAspectFit // 設定內容模式以適應比例。
        
        return imageView // 返回配置好的圖像視圖。
    }
    
    
    // pickerView(_:rowHeightForComponent:) 方法：設定pickerView每一行的高度。
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40 // 每一行的高度設為40。
    }
    
    
    // pickerView(_:didSelectRow:inComponent:) 方法：當選擇pickerView的某一行時觸發。
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 根據選擇的行索引來更新selectChipValue。
        switch row {
        case 0:
            selectChipValue = 5
        case 1:
            selectChipValue = 10
        case 2:
            selectChipValue = 15
        case 3:
            selectChipValue = 20
        case 4:
            selectChipValue = 25
        case 5:
            selectChipValue = 50
        case 6:
            selectChipValue = player.totalChips // 如果選擇"All in"，則使用玩家的總籌碼數。
        default:
            selectChipValue = 5
        }
        
        // 更新chipImage為當前選擇的籌碼圖像。
        chipImage = UIImage(named: chipValues[row])!
        print("selectChipValue : \(selectChipValue)") // 打印當前選擇的籌碼值。
    }
    
    
    
    //MARK: - SFX Function Section
    func createSFX(sfxUrl: URL) {
        
        // 根據傳入的URL創建一個新的AVPlayerItem。
        let playerItem = AVPlayerItem(url: sfxUrl)
        
        // 使用新的playerItem替換SfxPlayer的當前播放項目。
        SfxPlayer.replaceCurrentItem(with: playerItem)
        
        // 播放音效。
        SfxPlayer.play()
        
    }
    
    
    
    //MARK: - PlaceBetButton Function Section
    
    // placeBetButtonSetting 函數：設定下注按鈕的功能和行為。
    func placeBetButtonSetting(betType: BetType, sender: UIButton) {
        
        // 檢查玩家是否有足夠的籌碼進行下注。
        if player.totalChips > 0 && player.totalChips >= selectChipValue {
            
            // 創建一個新的Bet實例，並將其加入到玩家的下注列表中。
            let bet = Bet(type: betType, chips: [Chip(value: selectChipValue)])
            /*
             這裡的 [Chip(value: selectedChipValue)] 是在 Swift 中創建一個包含單一元素的陣列的方式。這個陣列只包含一個 Chip 物件，其值由 selectedChipValue 變數決定。
             代碼中，當玩家選擇了一個籌碼並放置下注時，會創建一個新的 Bet 物件。每個 Bet 物件都需要一組籌碼 ([Chip]) 來表示玩家的下注。由於在這個場景中，我們假設玩家每次下注只用一個籌碼，所以我們創建了一個只包含一個 Chip 物件的陣列。
             */
            player.placeBet(bet) // 玩家進行下注。
            
            print(player.bets.count) // 打印當前下注數量，用於調試。
            
            // 計算並顯示與當前下注類型相關的總下注籌碼。
            let currentBet = player.bets.filter { $0.type == betType }
            singleBetChip = currentBet.reduce(0) { $0 + $1.totalAmount }
            singleBetAmountLabel.text = "\(singleBetChip)"
            
            // 在按鈕上設置相應的籌碼圖像。
            sender.setImage(chipImage, for: .normal)
            
            // 更新並顯示玩家的總下注金額和剩餘籌碼。
            totalBetAmount = player.bets.reduce(0) { $0 + $1.totalAmount }
            totalBetMoneyLabel.text = "  BET TOTAL MONEY: $ \(totalBetAmount)  "
            totalMoneyLabel.text = "  TOTAL MONEY: $ \(player.totalChips)  "
            
            // 播放下注音效。
            createSFX(sfxUrl: chipSfxUrl!)
        } else {
            // 如果籌碼不足，顯示提示信息。
            singleBetAmountLabel.text = "籌碼不足"
        }
        
        // 設定單次下注金額標籤的樣式。
        singleBetAmountLabel.textColor = .white
        singleBetAmountLabel.textAlignment = .center
        singleBetAmountLabel.backgroundColor = .gray
        singleBetAmountLabel.adjustsFontSizeToFitWidth = true
        singleBetAmountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        singleBetAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 將單次下注金額標籤添加到視圖中。
        view.addSubview(singleBetAmountLabel)
        
        // 使用Auto Layout約束定位單次下注金額標籤。
        NSLayoutConstraint.activate([
            singleBetAmountLabel.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            singleBetAmountLabel.bottomAnchor.constraint(equalTo: sender.topAnchor, constant: -5),
            singleBetAmountLabel.widthAnchor.constraint(equalTo: sender.widthAnchor),
            singleBetAmountLabel.heightAnchor.constraint(equalTo: sender.heightAnchor)
        ])
        
        // 設置計時器，0.3秒後移除單次下注金額標籤。
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { Timer in
            self.singleBetAmountLabel.removeFromSuperview()
        }
    }
    
    
    
    //MARK: - RemoveBetButton Function Section
    func removeBet() {
        
        // 調用 player 對象的 clearBets 方法來清除所有下注。
        player.clearBets()
        
        // 更新 totalBetAmount 為目前所有下注的總額。
        totalBetAmount = player.bets.reduce(0) { $0 + $1.totalAmount }
        
        // 更新界面上顯示的總下注金額。
        totalBetMoneyLabel.text = "  BET TOTAL MONEY: $ \(totalBetAmount)  "
        
        // 更新界面上顯示的玩家總籌碼數量。
        totalMoneyLabel.text = "  TOTAL MONEY: $ \(player.totalChips)  "
        
        
        // 遍歷所有下注按鈕，移除其上的圖像，表示下注已被清除。
        for button in betButtonRightSides {
            button.setImage(nil, for: .normal)
        }
        for button in betButtonLeftSides {
            button.setImage(nil, for: .normal)
        }
        for button in betButton2To1Sides {
            button.setImage(nil, for: .normal)
        }
        for button in betButtonINTs {
            button.setImage(nil, for: .normal)
        }
        for button in betButtonUpSplits {
            button.setImage(nil, for: .normal)
        }
        for button in betButtonSpiltOrStreets {
            button.setImage(nil, for: .normal)
        }
        for button in betButtonCorners {
            button.setImage(nil, for: .normal)
        }
        
        // 發送一個通知，指示籌碼數量可能已變更。
        NotificationCenter.default.post(name: .totalChipsDidChange, object: nil) // 主要是讓 pickerView 中的 Allin 籌碼能夠一直擁有正確的總額
        
    }
    
    
    
    //MARK: - CheckSection Function Section
    // addColorBlinkingEffect 函數：給指定的視圖添加閃爍顏色效果。
    func addColorBlinkingEffect(to view: UIView, duration: TimeInterval, times: Int) {
        
        // 檢查閃爍次數是否大於0，否則直接返回。
        guard times > 0 else {
            return
        }
        
        // 創建UIViewPropertyAnimator來實現動畫效果。
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        
        // 添加動畫內容：改變視圖的背景顏色。
        animator.addAnimations {
            // 根據當前背景顏色來切換顏色。
            switch view.backgroundColor {
                
            case UIColor.clear:
                view.backgroundColor = .systemYellow
            case UIColor.systemYellow:
                view.backgroundColor = .clear
            case UIColor.black:
                view.backgroundColor = .systemCyan
            case UIColor.systemCyan:
                view.backgroundColor = .black
            case UIColor.systemRed:
                view.backgroundColor = .systemMint
            case UIColor.systemMint:
                view.backgroundColor = .systemRed
            default:
                break
            }
        }
        
        // 當一次動畫結束後，檢查是否需要重複動畫。
        animator.addCompletion { position in
            if position == .end {
                self.addColorBlinkingEffect(to: view, duration: duration, times: times - 1)
            }
        }
        
        // 啟動動畫。
        animator.startAnimation()
    }
    
    
    // checkSection 函數：根據輪盤的結果，決定哪些部分需要閃爍效果。
    func checkSection(result: Int) {
        
        // 根據輪盤的結果，給 1-18, 19-36, 0 等等視圖添加閃爍效果。
        if result > 0 && result <= 18 {
            addColorBlinkingEffect(to: self.leftSideViews[0], duration: 1, times: 4)
        } else if result >= 19 {
            addColorBlinkingEffect(to: self.leftSideViews[5], duration: 1, times: 4)
        } else {
            addColorBlinkingEffect(to: self.zeroView, duration: 1, times: 4)
        }
        
        // 根據輪盤結果是否為偶數或奇數來添加閃爍效果。
        if result % 2 == 0 && result != 0 {
            addColorBlinkingEffect(to: self.leftSideViews[1], duration: 1, times: 4)
        } else if result % 2 != 0 && result != 0 {
            addColorBlinkingEffect(to: self.leftSideViews[4], duration: 1, times: 4)
        }
        
        // 根據輪盤結果的顏色（紅或黑）來添加閃爍效果。
        if redNumbers.contains(result) {
            addColorBlinkingEffect(to: self.leftSideViews[2], duration: 1, times: 4)
        } else if blackNumbers.contains(result) {
            addColorBlinkingEffect(to: self.leftSideViews[3], duration: 1, times: 4)
        }
        
        // 根據輪盤結果所在的列來添加閃爍效果。
        if result <= 12 && result != 0 {
            addColorBlinkingEffect(to: self.rightSideViews[0], duration: 1, times: 4)
        } else if result <= 24 && result != 0 {
            addColorBlinkingEffect(to: self.rightSideViews[1], duration: 1, times: 4)
        } else if result <= 36 && result != 0 {
            addColorBlinkingEffect(to: self.rightSideViews[2], duration: 1, times: 4)
        }
        
        // 繼續添加閃爍效果到不同的 2:1 。
        if numbers1ColumnArray.contains(result) {
            addColorBlinkingEffect(to: self.twoToOneViews[0], duration: 1, times: 4)
        } else if numbers2ColumnArray.contains(result) {
            addColorBlinkingEffect(to: self.twoToOneViews[1], duration: 1, times: 4)
        } else if numbers3ColumnArray.contains(result) {
            addColorBlinkingEffect(to: self.twoToOneViews[2], duration: 1, times: 4)
        }
        
        // 對相應的數字視圖添加閃爍效果。
        if result > 0 {
            addColorBlinkingEffect(to: self.numberViews[result - 1], duration: 1, times: 4)
        }
    }
    
    
    
    //MARK: - ReBetButton Function Section
    // reBetPlaceBetButtonSetting 函數：設定再次下注的按鈕功能和行為。
    func reBetPlaceBetButtonSetting(bet: Bet, betType: BetType, sender: UIButton) {
        
        // 檢查下注的籌碼值是否超過50，如果面額超過 50 就代表是 Allin，再來就是檢查是否現在總金額有高過上次這筆 Allin。
        if bet.chips[0].value > 50 && player.totalChips >= bet.chips[0].value {
            // 如果超過，則將籌碼值設定為玩家的總籌碼數量。
            bet.chips[0].value = player.totalChips
        }
        
        // 面額沒超過 50 就進到這行，檢查玩家是否有足夠的籌碼進行下注。
        if player.totalChips > 0 && player.totalChips >= bet.totalAmount {
            // 如果有，則玩家進行下注。
            player.placeBet(bet)
            
            // 設置按鈕上的籌碼圖像，為了不讓籌碼圖片受到目前的 pickView 影響，這裡的籌碼圖片是吃 player.bets.chips 裡面的。
            sender.setImage(bet.chips[0].chipImage, for: .normal)
            
            // 更新並顯示玩家的總下注金額和剩餘籌碼。
            totalBetAmount = player.bets.reduce(0) { $0 + $1.totalAmount }
            totalBetMoneyLabel.text = "  BET TOTAL MONEY: $ \(totalBetAmount)  "
            totalMoneyLabel.text = "  TOTAL MONEY: $ \(player.totalChips)  "
            
            // 播放下注音效。
            createSFX(sfxUrl: chipSfxUrl!)
        } else {
            
        }
    }
    // 將所有顯示單筆籌碼和籌碼不夠的 label 都撤掉了，因為全部一起顯示會有一秒左右的時間讓畫面怪怪的
    
    
    
    // MARK: - Objc Function Section
    // 當用戶按下 "0" 號下注按鈕時觸發的方法。
    @objc func betButtonZeroTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放 "0" 號下注按鈕時觸發的方法。
    @objc func betButtonZeroReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 設置下注類型為 "0" 號。
        let betType = BetType.number(0)
        placeBetButtonSetting(betType: betType, sender: sender)
    }
    
    
    
    // 當用戶按下右側區域的下注按鈕時觸發的方法。
    @objc func betButtonRightSideTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放右側區域的下注按鈕時觸發的方法。
    @objc func betButtonRightSideReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型。
        switch sender.tag {
        case 1:
            let betType = BetType.firstTwelve
            placeBetButtonSetting(betType: betType, sender: sender)
        case 2:
            let betType = BetType.secondTwelve
            placeBetButtonSetting(betType: betType, sender: sender)
        case 3:
            let betType = BetType.thirdTwelve
            placeBetButtonSetting(betType: betType, sender: sender)
        default:
            break
        }
    }
    
    
    
    // 當用戶按下左側區域的下注按鈕時觸發的方法。
    @objc func betButtonLeftSideTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放左側區域的下注按鈕時觸發的方法。
    @objc func betButtonLeftSideReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型。
        switch sender.tag {
        case 1:
            let betType = BetType.firstHalf
            placeBetButtonSetting(betType: betType, sender: sender)
        case 2:
            let betType = BetType.even
            placeBetButtonSetting(betType: betType, sender: sender)
        case 3:
            let betType = BetType.red
            placeBetButtonSetting(betType: betType, sender: sender)
        case 4:
            let betType = BetType.black
            placeBetButtonSetting(betType: betType, sender: sender)
        case 5:
            let betType = BetType.odd
            placeBetButtonSetting(betType: betType, sender: sender)
        case 6:
            let betType = BetType.secondHalf
            placeBetButtonSetting(betType: betType, sender: sender)
        default:
            break
        }
    }
    
    
    
    // 當用戶觸摸 "2 to 1" 下注按鈕時觸發的方法。
    @objc func betButton2To1Touched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放 "2 to 1" 下注按鈕時觸發的方法。
    @objc func betButton2To1Released(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型。
        switch sender.tag {
        case 1:
            let betType = BetType.firstColumn
            placeBetButtonSetting(betType: betType, sender: sender)
        case 2:
            let betType = BetType.secondColumn
            placeBetButtonSetting(betType: betType, sender: sender)
        case 3:
            let betType = BetType.thirdColumn
            placeBetButtonSetting(betType: betType, sender: sender)
        default:
            break
        }
    }
    
    
    
    // 當用戶觸摸單個數字下注按鈕時觸發的方法。
    @objc func betButtonINTTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放單個數字下注按鈕時觸發的方法。
    @objc func betButtonINTReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型為單個數字。
        let betType = BetType.number(sender.tag)
        placeBetButtonSetting(betType: betType, sender: sender)
    }
    
    
    
    // 當用戶觸摸分割線下注按鈕時觸發的方法。
    @objc func betButtonUpSplitTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放分割線下注按鈕時觸發的方法。
    @objc func betButtonUpSplitReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型為分割線下注。
        let betType: BetType
        if sender.tag <= 3 {
            betType = BetType.split([sender.tag, 0])
        } else {
            betType = BetType.split([sender.tag, sender.tag - 3])
        }
        placeBetButtonSetting(betType: betType, sender: sender)
    }
    
    
    
    // 當用戶觸摸左側分割線下注按鈕時觸發的方法。
    @objc func betButtonLeftSplitTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放左側分割線下注按鈕時觸發的方法。
    @objc func betButtonLeftSplitReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型為左側分割線下注。
        let betType = BetType.split([sender.tag, sender.tag - 1])
        placeBetButtonSetting(betType: betType, sender: sender)
    }
    
    
    
    // 當用戶觸摸街道下注按鈕時觸發的方法。
    @objc func betButtonStreetTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放街道下注按鈕時觸發的方法。
    @objc func betButtonStreetReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 根據按鈕的標籤，決定下注類型為街道下注。
        let betType = BetType.street(sender.tag)
        placeBetButtonSetting(betType: betType, sender: sender)
    }
    
    
    
    // 當用戶觸摸角落下注按鈕時觸發的方法。
    @objc func betButtonCornerTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放角落下注按鈕時觸發的方法。
    @objc func betButtonCornerReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        // 如果按鈕標籤小於或等於 3，則不進行任何操作。
        if sender.tag <= 3 {
            return
        } else {
            // 否則，根據按鈕的標籤，決定下注類型為角落下注。
            let betType = BetType.corner([sender.tag, sender.tag - 4, sender.tag - 3, sender.tag - 1])
            placeBetButtonSetting(betType: betType, sender: sender)
        }
    }
    
    
    
    // 當用戶觸摸移除下注按鈕時觸發的方法。
    @objc func removeBetButtonTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放移除下注按鈕時觸發的方法。
    @objc func removeBetButtonReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
        }
        
        // 調用 removeBet 函數來移除所有當前的下注。
        removeBet()
    }
    
    
    
    // 當用戶觸摸重新下注按鈕時觸發的方法。
    @objc func reBetButtonTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕縮小至原大小的 70%，增加按下的視覺效果。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放重新下注按鈕時觸發的方法。
    @objc func reBetButtonReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕恢復至原始大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
        }
        
        // 首先移除所有當前的下注。
        removeBet()
        
        // 遍歷上一次的下注記錄，並重新進行每一筆下注。
        theLastBets.forEach { Bet in
            
            // 使用 switch 語句處理不同類型的下注。
            switch Bet.type {
                
            case .number(let betNumber):
                // 如果下注類型為單個數字，找到對應的按鈕並調用重新下注設置函數。
                let betButtonINT = betButtonINTs.first { $0.tag == betNumber }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .number(betNumber), sender: betButtonINT!)
                
            case .firstTwelve:
                // 如果下注類型為第一十二（1-12），找到對應的按鈕並調用重新下注設置函數。
                let betButtonRightSide1 = betButtonRightSides.first { $0.tag == 1 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .firstTwelve, sender: betButtonRightSide1!)
                
            case .secondTwelve:
                // 如果下注類型為第二十二（13-24），找到對應的按鈕並調用重新下注設置函數。
                let betButtonRightSide2 = betButtonRightSides.first { $0.tag == 2 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .secondTwelve, sender: betButtonRightSide2!)
                
            case .thirdTwelve:
                // 如果下注類型為第三十二（25-36），找到對應的按鈕並調用重新下注設置函數。
                let betButtonRightSide3 = betButtonRightSides.first { $0.tag == 3 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .thirdTwelve, sender: betButtonRightSide3!)
                
            case .red:
                // 如果下注類型為紅色，找到對應的按鈕並調用重新下注設置函數。
                let betButtonLeftSide3 = betButtonLeftSides.first { $0.tag == 3 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .red, sender: betButtonLeftSide3!)
                
            case .black:
                // 如果下注類型為黑色，找到對應的按鈕並調用重新下注設置函數。
                let betButtonLeftSide4 = betButtonLeftSides.first { $0.tag == 4 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .black, sender: betButtonLeftSide4!)
                
            case .odd:
                // 如果下注類型為單數，找到對應的按鈕並調用重新下注設置函數。
                let betButtonLeftSide5 = betButtonLeftSides.first { $0.tag == 5 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .odd, sender: betButtonLeftSide5!)
                
            case .even:
                // 如果下注類型為雙數，找到對應的按鈕並調用重新下注設置函數。
                let betButtonLeftSide2 = betButtonLeftSides.first { $0.tag == 2 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .even, sender: betButtonLeftSide2!)
                
            case .firstHalf:
                // 如果下注類型為前半部（1-18），找到對應的按鈕並調用重新下注設置函數。
                let betButtonLeftSide1 = betButtonLeftSides.first { $0.tag == 1 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .firstHalf, sender: betButtonLeftSide1!)
                
            case .secondHalf:
                // 如果下注類型為後半部（19-36），找到對應的按鈕並調用重新下注設置函數。
                let betButtonLeftSide6 = betButtonLeftSides.first { $0.tag == 6 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .secondHalf, sender: betButtonLeftSide6!)
                
            case .firstColumn:
                // 如果下注類型為第一列，找到對應的按鈕並調用重新下注設置函數。
                let betButton2To1ST = betButton2To1Sides.first { $0.tag == 1 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .firstColumn, sender: betButton2To1ST!)
                
            case .secondColumn:
                // 如果下注類型為第二列，找到對應的按鈕並調用重新下注設置函數。
                let betButton2To1ND = betButton2To1Sides.first { $0.tag == 2 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .secondColumn, sender: betButton2To1ND!)
                
            case .thirdColumn:
                // 如果下注類型為第三列，找到對應的按鈕並調用重新下注設置函數。
                let betButton2To1RD = betButton2To1Sides.first { $0.tag == 3 }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .thirdColumn, sender: betButton2To1RD!)
                
            case .split(let numbers):
                // 如果下注類型為分割，找到對應的按鈕並調用重新下注設置函數。
                if numbers[1] == 0 || numbers[1] - numbers[0] == 3 {
                    
                    let betButtonUpSpilt = betButtonUpSplits.first { $0.tag == numbers[0] }
                    reBetPlaceBetButtonSetting(bet: Bet, betType: .split([numbers[0], numbers[1]]), sender: betButtonUpSpilt!)
                    
                } else if numbers[0] - numbers[1] == 1 {
                    
                    let betButtonLeftSpilt = betButtonSpiltOrStreets.first { $0.tag == numbers[0] }
                    reBetPlaceBetButtonSetting(bet: Bet, betType: .split([numbers[0], numbers[1]]), sender: betButtonLeftSpilt!)
                    
                }
                
            case .street(let number):
                // 如果下注類型為街道，找到對應的按鈕並調用重新下注設置函數。
                let betButtonStreet = betButtonSpiltOrStreets.first { $0.tag == number }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .street(number), sender: betButtonStreet!)
                
            case .corner(let numbers):
                // 如果下注類型為角落，找到對應的按鈕並調用重新下注設置函數。
                let betButtonCorner = betButtonCorners.first { $0.tag == numbers[0] }
                reBetPlaceBetButtonSetting(bet: Bet, betType: .corner([numbers[0], numbers[1], numbers[2], numbers[3]]), sender: betButtonCorner!)
            }
        }
    }
    
    
    
    // 當用戶觸摸輪盤旋轉按鈕時觸發的方法。
    @objc func spinButtonTouched(_ sender: UIButton) {
        // 執行動畫，將按鈕和輪盤視圖縮小至原大小的 70%，增加按下的視覺效果。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.wheelContainerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    // 當用戶釋放輪盤旋轉按鈕時觸發的方法。
    @objc func spinButtonReleased(_ sender: UIButton) {
        // 執行動畫，將按鈕和輪盤視圖恢復至原始大小。
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.wheelContainerView.transform = CGAffineTransform.identity
        }
        
        // 播放輪盤旋轉的音效。
        createSFX(sfxUrl: spinSfxUrl!)
        
        // 創建並設置顯示輪盤上方箭頭的圖像視圖。
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        arrowImageView.tintColor = .systemYellow
        arrowImageView.backgroundColor = .clear
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 設置顯示輪盤結果的標籤。
        resultLabel.textColor = .white
        resultLabel.font = UIFont.boldSystemFont(ofSize: 80)
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 設置輪盤視圖的背景顏色和佈局。
        wheelContainerView.backgroundColor = .systemGreen
        wheelContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 為輪盤視圖設置輪盤圖像。
        wheelImageView.image = UIImage(named: "Wheel")
        wheelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 將輪盤圖像、箭頭圖像和結果標籤添加到輪盤視圖中。
        wheelContainerView.addSubview(wheelImageView)
        wheelContainerView.addSubview(arrowImageView)
        wheelContainerView.addSubview(resultLabel)
        view.addSubview(wheelContainerView)
        
        // 使用自動佈局約束來設置輪盤視圖及其子視圖的位置和大小。
        NSLayoutConstraint.activate([
            wheelContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wheelContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wheelContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            wheelContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.95),
            
            wheelImageView.topAnchor.constraint(equalTo: wheelContainerView.topAnchor, constant: 15),
            wheelImageView.leadingAnchor.constraint(equalTo: wheelContainerView.leadingAnchor),
            wheelImageView.trailingAnchor.constraint(equalTo: wheelContainerView.trailingAnchor),
            wheelImageView.heightAnchor.constraint(equalTo: wheelImageView.widthAnchor, multiplier: 1),
            
            arrowImageView.centerXAnchor.constraint(equalTo: wheelContainerView.centerXAnchor),
            arrowImageView.topAnchor.constraint(equalTo: wheelContainerView.topAnchor, constant: 20),
            
            resultLabel.centerXAnchor.constraint(equalTo: wheelContainerView.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: wheelImageView.bottomAnchor, constant: 20),
        ])
        
        
        // 開始旋轉輪盤，並在旋轉結束後處理結果。
        wheelImageView.rotateGradually { [self] result in
            print(result)
            resultNumber = Int(result)!
            
            // 設置延時，以顯示輪盤的結果。
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { [self] Timer in
                
                // 根據輪盤結果數字的顏色，設置結果標籤的文本顏色。
                if redNumbers.contains(resultNumber) {
                    resultLabel.textColor = .systemRed
                } else if blackNumbers.contains(resultNumber) {
                    resultLabel.textColor = .black
                } else if resultNumber == 0 {
                    resultLabel.textColor = .white
                }
                self.resultLabel.text = result
            }
            
            // 設置延時，以移除輪盤視圖。
            Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { Timer in
                self.resultLabel.text = ""
                self.wheelContainerView.removeFromSuperview()
            }
            
            // 設置延時，以進行輪盤結果的處理。
            Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { [self] Timer in
                checkSection(result: resultNumber)
            }
            
            // 設置延時，以更新玩家籌碼和下注。
            Timer.scheduledTimer(withTimeInterval: 9.5, repeats: false) { [self] Timer in
                theLastBets.removeAll()
                player.bets.forEach { theLastBets.append($0) }
                
                self.checkFinal = Int(self.player.checkWinning(number: self.resultNumber))
                print("checkFinal : \(self.checkFinal)")
                
                if self.checkFinal > 0 {
                    self.player.totalChips += Int(self.checkFinal)
                    self.checkFinalLabel.text = "+$\(checkFinal)"
                } else {
                    // 處理輪盤輸掉的情況（無需額外動作）。
                }
                
                self.totalMoneyLabel.text = "  TOTAL MONEY: $ \(self.player.totalChips)  "
                
                // 清除已經計算在內的賭注。
                self.player.bets.removeAll()
                // removeBet() 中的 player.clearBets() 函數中有一段 totalChips += totalBetsAmount 會先把已當作賭注的金額加回本金，
                // 這本來是在下好離手前清除賭注時將原本的賭注金額收回，但在輪盤開始轉之後這些當作賭注的金額不論輸贏都應該減去，
                // 不想再多寫一個函數所以在輪盤開始轉之後 removeBet() 函數之前先把 bets 裡的賭注去除。
                
                self.removeBet()
                
            }
            // 設置延時，以更新顯示最近的輪盤結果數字。
            Timer.scheduledTimer(withTimeInterval: 11, repeats: false) { Timer in
                self.checkFinalLabel.text = ""
                self.displayResultNumber(resultNumber: self.resultNumber)
            }
        }
    }
    
    
    
    // 當籌碼總數發生變化時觸發的方法。
    @objc func totalChipsDidChange(_ notification: Notification) {
        // 獲取目前選擇的籌碼選擇器（chipPicker）行數。
        let selectedRow = self.chipPicker.selectedRow(inComponent: 0)
        
        // 如果選擇的是最後一行（為“全部下注”選項），則將選中的籌碼值設定為玩家的總籌碼數量。
        if selectedRow == 6 {
            selectChipValue = player.totalChips
        }
    }
    
    
    
}



//MARK: - Notification extention
// 擴展 Notification.Name 以包含一個自定義的通知名稱。
extension Notification.Name {
    // 增加一個名為 totalChipsDidChange 的靜態屬性，用於通知籌碼總數發生變化的情況。
    static let totalChipsDidChange = Notification.Name("totalChipsDidChange")
}
