//
//  RouletteViewController.swift
//  Roulette
//
//  Created by Howe on 2024/1/8.
//

import UIKit
import AVFoundation

class RouletteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let mainContainerView = UIView()
    let mainStackView = UIStackView()
    let rightSideStackView = UIStackView()
    var rightSideViews = [UIView]()
    let leftSideStackView = UIStackView()
    var leftSideViews = [UIView]()
    let zeroView = UIView()
    let numbers3ColumnStackView = UIStackView()
    let numbers2ColumnStackView = UIStackView()
    let numbers1ColumnStackView = UIStackView()
    var numberViews = [UIView]()
    let twoToOneStackView = UIStackView()
    var twoToOneViews = [UIView]()
    
    let pickerContainerView = UIView()
    let chipPicker = UIPickerView()
    let chipValues = ["Chip5", "Chip10", "Chip15", "Chip20", "Chip25", "Chip50", "Allin"]
    var chipImage = UIImage()
    var selectChipValue = 5
    var totalBetAmount = 0
    var singleBetChip = 0
    var singleBetAmountLabel = UILabel()
    
    let SfxPlayer = AVPlayer()
    let chipSfxUrl = Bundle.main.url(forResource: "chipscasinobet", withExtension: "wav")
    let spinSfxUrl = Bundle.main.url(forResource: "Digital Casino Short Roulette Spin", withExtension: "wav")
    
    var totalBetMoneyLabel = UILabel()
    var totalMoneyLabel = UILabel()
    
    let numbers3ColumnArray = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36]
    let numbers2ColumnArray = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35]
    let numbers1ColumnArray = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]
    let redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
    let blackNumbers = [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]
    
    var player = Player(totalChips: 1000)
    
    let removeBetButton = UIButton()
    let reBetButton = UIButton()
    let spinButton = UIButton()
    
    var betButtonZeros = [UIButton]()
    var betButtonRightSides = [UIButton]()
    var betButtonLeftSides = [UIButton]()
    var betButton2To1Sides = [UIButton]()
    var betButtonINTs = [UIButton]()
    var betButtonUpSplits = [UIButton]()
    var betButtonSpiltOrStreets = [UIButton]()
    var betButtonCorners = [UIButton]()
    
    let wheelContainerView = UIView()
    let wheelImageView = WheelImageView()
    let resultLabel = UILabel()
    var resultNumber = 0
    var checkFinal = 0
    var checkFinalLabel = UILabel()
    
    var theLastBets = [Bet]()
    
//    var chipArray = [Chip]()
//    var chipValue: Chip?
    
    
    // MARK: - viewDidLoad Section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialUI()
        setupChipPicker()
        
        NotificationCenter.default.addObserver(self, selector: #selector(totalChipsDidChange), name: .totalChipsDidChange, object: nil)
        
    }
    
    // MARK: - UIsetting Function Section
    func setupInitialUI() {
        
        view.backgroundColor = .systemGreen
        
        
        mainContainerView.layer.borderColor = UIColor.white.cgColor
        mainContainerView.layer.borderWidth = 2
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 0
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.layer.borderColor = UIColor.white.cgColor
        
        zeroView.backgroundColor = .clear
        zeroView.layer.borderColor = UIColor.white.cgColor
        zeroView.layer.borderWidth = 2
        zeroView.translatesAutoresizingMaskIntoConstraints = false
        
        let zeroLabel = UILabel()
        zeroLabel.text = "0"
        zeroLabel.font = UIFont.boldSystemFont(ofSize: 18)
        zeroLabel.textColor = .white
        zeroLabel.translatesAutoresizingMaskIntoConstraints = false
        let betButtonZero = UIButton()
        betButtonZero.translatesAutoresizingMaskIntoConstraints = false
        betButtonZero.backgroundColor = .clear
        betButtonZero.tag = 0
        betButtonZero.addTarget(self, action: #selector(betButtonZeroTouched), for: .touchDown)
        betButtonZero.addTarget(self, action: #selector(betButtonZeroReleased), for: .touchUpInside)
        betButtonZeros.append(betButtonZero)
        
        rightSideStackView.axis = .vertical
        rightSideStackView.spacing = 0
        rightSideStackView.alignment = .fill
        rightSideStackView.distribution = .fillEqually
        rightSideStackView.translatesAutoresizingMaskIntoConstraints = false
        createRightSide()
        
        leftSideStackView.axis = .vertical
        leftSideStackView.spacing = 0
        leftSideStackView.alignment = .fill
        leftSideStackView.distribution = .fillEqually
        leftSideStackView.translatesAutoresizingMaskIntoConstraints = false
        creatLeftSide()
        
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
        numbers2ColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        createNumberColumn(numbers: numbers2ColumnArray, numbersStackView: numbers2ColumnStackView)
        
        numbers1ColumnStackView.axis = .vertical
        numbers1ColumnStackView.spacing = 0
        numbers1ColumnStackView.alignment = .fill
        numbers1ColumnStackView.distribution = .fillEqually
        numbers1ColumnStackView.translatesAutoresizingMaskIntoConstraints = false
        createNumberColumn(numbers: numbers1ColumnArray, numbersStackView: numbers1ColumnStackView)
        
        twoToOneStackView.axis = .horizontal
        twoToOneStackView.spacing = -2
        twoToOneStackView.alignment = .fill
        twoToOneStackView.distribution = .fillEqually
        twoToOneStackView.translatesAutoresizingMaskIntoConstraints = false
        create2To1View()
        
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
        
        checkFinalLabel.text = ""
        checkFinalLabel.font = UIFont.boldSystemFont(ofSize: 40)
        checkFinalLabel.textColor = .white
        checkFinalLabel.adjustsFontSizeToFitWidth = true
        checkFinalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(mainContainerView)
        mainContainerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(leftSideStackView)
        mainStackView.addArrangedSubview(numbers1ColumnStackView)
        mainStackView.addArrangedSubview(numbers2ColumnStackView)
        mainStackView.addArrangedSubview(numbers3ColumnStackView)
        mainStackView.addArrangedSubview(rightSideStackView)
        view.addSubview(zeroView)
        view.addSubview(twoToOneStackView)
        zeroView.addSubview(zeroLabel)
        view.addSubview(totalMoneyLabel)
        view.addSubview(totalBetMoneyLabel)
        zeroView.addSubview(betButtonZero)
        view.addSubview(removeBetButton)
        view.addSubview(reBetButton)
        view.addSubview(spinButton)
        view.addSubview(checkFinalLabel)
        
        
        
        NSLayoutConstraint.activate([
            
            mainContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            mainContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110),
            
            
            mainStackView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            
            
            zeroView.leadingAnchor.constraint(equalTo: numbers1ColumnStackView.leadingAnchor, constant: -1),
            zeroView.trailingAnchor.constraint(equalTo: numbers3ColumnStackView.trailingAnchor, constant: 1),
            zeroView.heightAnchor.constraint(equalTo: numbers1ColumnStackView.widthAnchor),
            zeroView.bottomAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 2),
            
            zeroLabel.centerXAnchor.constraint(equalTo: zeroView.centerXAnchor),
            zeroLabel.centerYAnchor.constraint(equalTo: zeroView.centerYAnchor),
            
            
            twoToOneStackView.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -2),
            twoToOneStackView.leadingAnchor.constraint(equalTo: numbers1ColumnStackView.leadingAnchor, constant: -1),
            twoToOneStackView.trailingAnchor.constraint(equalTo: numbers3ColumnStackView.trailingAnchor, constant: 1),
            twoToOneStackView.heightAnchor.constraint(equalTo: numbers1ColumnStackView.widthAnchor),
            
            
            totalMoneyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalMoneyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            totalBetMoneyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            totalBetMoneyLabel.bottomAnchor.constraint(equalTo: totalMoneyLabel.topAnchor, constant: -5),
            
            
            betButtonZero.centerXAnchor.constraint(equalTo: zeroView.centerXAnchor),
            betButtonZero.centerYAnchor.constraint(equalTo: zeroView.centerYAnchor),
            betButtonZero.widthAnchor.constraint(equalTo: zeroView.widthAnchor, multiplier: 0.19),
            betButtonZero.heightAnchor.constraint(equalTo: zeroView.heightAnchor, multiplier: 0.56),
            
            removeBetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            removeBetButton.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            removeBetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            reBetButton.bottomAnchor.constraint(equalTo: removeBetButton.topAnchor, constant: -10),
            reBetButton.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            reBetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            spinButton.topAnchor.constraint(equalTo: removeBetButton.bottomAnchor, constant: 10),
            spinButton.leadingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: 10),
            spinButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            //checkFinalLabel.leadingAnchor.constraint(equalTo: totalMoneyLabel.trailingAnchor, constant: 85),
            checkFinalLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            checkFinalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
        
        
    }
    
    
    func createRightSide() {
        
        for i in 1...3 {
            let sectionView = UIView()
            sectionView.backgroundColor = .clear
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 1
            rightSideViews.append(sectionView)
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel()
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let betButtonRightSide = UIButton()
            betButtonRightSide.translatesAutoresizingMaskIntoConstraints = false
            betButtonRightSide.backgroundColor = .clear
            betButtonRightSide.addTarget(self, action: #selector(betButtonRightSideTouched(_:)), for: .touchDown)
            betButtonRightSide.addTarget(self, action: #selector(betButtonRightSideReleased(_:)), for: .touchUpInside)
            betButtonRightSides.append(betButtonRightSide)
            
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
            
            rightSideStackView.addArrangedSubview(sectionView)
            sectionView.addSubview(sectionLabel)
            sectionView.addSubview(betButtonRightSide)
            
            NSLayoutConstraint.activate([
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                
                betButtonRightSide.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonRightSide.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonRightSide.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.6),
                betButtonRightSide.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.14)
            ])
            sectionLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
        
    }
    
    
    func creatLeftSide(){
        
        for i in 1...6 {
            let sectionView = UIView()
            sectionView.backgroundColor = .clear
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 1
            leftSideViews.append(sectionView)
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel()
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let betButtonLeftSide = UIButton()
            betButtonLeftSide.translatesAutoresizingMaskIntoConstraints = false
            betButtonLeftSide.backgroundColor = .clear
            betButtonLeftSide.addTarget(self, action: #selector(betButtonLeftSideTouched(_:)), for: .touchDown)
            betButtonLeftSide.addTarget(self, action: #selector(betButtonLeftSideReleased(_:)), for: .touchUpInside)
            betButtonLeftSides.append(betButtonLeftSide)
            
            switch i {
            case 1 :
                sectionLabel.text = "1 - 18"
                betButtonLeftSide.tag = 1
            case 2 :
                sectionLabel.text = "EVEN"
                betButtonLeftSide.tag = 2
            case 3 :
                sectionLabel.text = ""
                betButtonLeftSide.tag = 3
                let diamondView = UIView()
                diamondView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
                diamondView.layer.borderColor = UIColor.white.cgColor
                diamondView.layer.borderWidth = 2
                diamondView.translatesAutoresizingMaskIntoConstraints = false
                diamondView.backgroundColor = .systemRed
                sectionView.backgroundColor = .clear
                
                sectionView.addSubview(diamondView)
                
                NSLayoutConstraint.activate([
                    diamondView.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                    diamondView.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                    diamondView.widthAnchor.constraint(equalToConstant: 30),
                    diamondView.heightAnchor.constraint(equalToConstant: 30)
                ])
            case 4 :
                sectionLabel.text = ""
                betButtonLeftSide.tag = 4
                let diamondView = UIView()
                diamondView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
                diamondView.layer.borderColor = UIColor.white.cgColor
                diamondView.layer.borderWidth = 2
                diamondView.translatesAutoresizingMaskIntoConstraints = false
                diamondView.backgroundColor = .black
                sectionView.backgroundColor = .clear
                
                sectionView.addSubview(diamondView)
                
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
            
            leftSideStackView.addArrangedSubview(sectionView)
            sectionView.addSubview(sectionLabel)
            sectionView.addSubview(betButtonLeftSide)
            
            NSLayoutConstraint.activate([
                
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                
                betButtonLeftSide.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonLeftSide.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonLeftSide.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.6),
                betButtonLeftSide.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.27)
                
            ])
            sectionLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
        
    }
    
    
    func createNumberColumn(numbers: [Int], numbersStackView: UIStackView) {
        
        
        for number in numbers {
            
            let sectionView = UIView()
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 1
            sectionView.clipsToBounds = false
            sectionView.tag = number
            numberViews.append(sectionView)
            numberViews.sort { $0.tag < $1.tag }
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel()
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.clipsToBounds = false
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            
            switch number {
            case 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36 :
                sectionLabel.text = "\(number)"
                sectionView.backgroundColor = .systemRed
            case 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35 :
                sectionLabel.text = "\(number)"
                sectionView.backgroundColor = .black
            default :
                break
            }
            
            
            let betButtonINT = UIButton()
            betButtonINT.tag = number
            betButtonINT.translatesAutoresizingMaskIntoConstraints = false
            betButtonINT.backgroundColor = .clear
            betButtonINT.addTarget(self, action: #selector(betButtonINTTouched(_:)), for: .touchDown)
            betButtonINT.addTarget(self, action: #selector(betButtonINTReleased(_:)), for: .touchUpInside)
            betButtonINTs.append(betButtonINT)
            
            
            let betButtonUpSplit = UIButton()
            betButtonUpSplit.tag = number
            betButtonUpSplit.translatesAutoresizingMaskIntoConstraints = false
            betButtonUpSplit.backgroundColor = .clear
            betButtonUpSplit.addTarget(self, action: #selector(betButtonUpSplitTouched), for: .touchDown)
            betButtonUpSplit.addTarget(self, action: #selector(betButtonUpSplitReleased), for: .touchUpInside)
            betButtonUpSplits.append(betButtonUpSplit)
            
            
            let betButtonLeftSpiltOrStreet = UIButton()
            betButtonLeftSpiltOrStreet.tag = number
            betButtonLeftSpiltOrStreet.translatesAutoresizingMaskIntoConstraints = false
            betButtonLeftSpiltOrStreet.backgroundColor = .clear
            betButtonSpiltOrStreets.append(betButtonLeftSpiltOrStreet)
            
            if numbersStackView == numbers1ColumnStackView {
                
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonStreetTouched), for: .touchDown)
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonStreetReleased), for: .touchUpInside)
                
            } else {
                
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonLeftSplitTouched), for: .touchDown)
                betButtonLeftSpiltOrStreet.addTarget(self, action: #selector(betButtonLeftSplitReleased), for: .touchUpInside)
                
            }
            
            let betButtonCorner = UIButton()
            betButtonCorner.tag = number
            betButtonCorner.translatesAutoresizingMaskIntoConstraints = false
            betButtonCorner.backgroundColor = .clear
            betButtonCorner.clipsToBounds = false
            betButtonCorners.append(betButtonCorner)
            
            if numbersStackView == numbers1ColumnStackView {
                
            } else {
                
                betButtonCorner.addTarget(self, action: #selector(betButtonCornerTouched), for: .touchDown)
                betButtonCorner.addTarget(self, action: #selector(betButtonCornerReleased), for: .touchUpInside)
                
            }
            
            
            numbersStackView.addArrangedSubview(sectionView)
            sectionView.addSubview(sectionLabel)
            sectionView.addSubview(betButtonINT)
            sectionView.addSubview(betButtonUpSplit)
            sectionView.addSubview(betButtonLeftSpiltOrStreet)
            sectionView.addSubview(betButtonCorner)
            
            
            
            
            NSLayoutConstraint.activate([
                sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                sectionLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                
                betButtonINT.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonINT.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor),
                betButtonINT.widthAnchor.constraint(equalTo: sectionView.widthAnchor, multiplier: 0.58),
                betButtonINT.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 0.56),
                
                betButtonUpSplit.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                betButtonUpSplit.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: -13.3),
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
    
    
    func create2To1View() {
        
        for i in 1...3 {
            
            let sectionView = UIView()
            sectionView.backgroundColor = .clear
            sectionView.layer.borderColor = UIColor.white.cgColor
            sectionView.layer.borderWidth = 2
            twoToOneViews.append(sectionView)
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let sectionLabel = UILabel()
            sectionLabel.textColor = .white
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.translatesAutoresizingMaskIntoConstraints = false
            sectionLabel.text = "2 : 1"
            
            let betButton2To1Side = UIButton()
            betButton2To1Side.translatesAutoresizingMaskIntoConstraints = false
            betButton2To1Side.backgroundColor = .clear
            betButton2To1Side.addTarget(self, action: #selector(betButton2To1Touched(_:)), for: .touchDown)
            betButton2To1Side.addTarget(self, action: #selector(betButton2To1Released(_:)), for: .touchUpInside)
            betButton2To1Sides.append(betButton2To1Side)
            
            switch i {
            case 1 :
                betButton2To1Side.tag = 1
            case 2 :
                betButton2To1Side.tag = 2
            case 3 :
                betButton2To1Side.tag = 3
            default :
                break
            }
            
            twoToOneStackView.addArrangedSubview(sectionView)
            
            sectionView.addSubview(sectionLabel)
            sectionView.addSubview(betButton2To1Side)
            
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
    
    
    
    // MARK: - UIPicker Function Section
    func setupChipPicker() {
        
        chipPicker.dataSource = self
        chipPicker.delegate = self
        chipPicker.translatesAutoresizingMaskIntoConstraints = false
        
        pickerContainerView.backgroundColor = .gray
        pickerContainerView.layer.borderWidth = 1
        pickerContainerView.layer.borderColor = UIColor.white.cgColor
        pickerContainerView.layer.cornerRadius = 10
        pickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pickerContainerView)
        pickerContainerView.addSubview(chipPicker)
        
        NSLayoutConstraint.activate([
            
            pickerContainerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor),
            pickerContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            pickerContainerView.widthAnchor.constraint(equalToConstant: 50),
            pickerContainerView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.4),
            
            chipPicker.centerXAnchor.constraint(equalTo: pickerContainerView.centerXAnchor),
            chipPicker.centerYAnchor.constraint(equalTo: pickerContainerView.centerYAnchor),
            chipPicker.widthAnchor.constraint(equalTo: pickerContainerView.widthAnchor),
            chipPicker.heightAnchor.constraint(equalTo: pickerContainerView.heightAnchor)
        ])
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chipValues.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let image = UIImage(named: chipValues[row])
        chipImage = image!
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0 :
            selectChipValue = 5
        case 1 :
            selectChipValue = 10
        case 2 :
            selectChipValue = 15
        case 3 :
            selectChipValue = 20
        case 4 :
            selectChipValue = 25
        case 5:
            selectChipValue = 50
        case 6:
            selectChipValue = player.totalChips
        default :
            selectChipValue = 5
        }
        
        chipImage = UIImage(named: chipValues[row])!
        print("selectChipValue : \(selectChipValue)")
        
    }
    
    
    
    //MARK: - SFX Function Section
    func createSFX(sfxUrl: URL) {
        
        let playerItem = AVPlayerItem(url: sfxUrl)
        SfxPlayer.replaceCurrentItem(with: playerItem)
        SfxPlayer.play()
        
    }
    
    
    
    //MARK: - PlaceBetButton Function Section
    func placeBetButtonSetting(betType: BetType, sender: UIButton) {
        
        if player.totalChips > 0 && player.totalChips >= selectChipValue {
            
//            chipValue = Chip(value: selectChipValue)
//            chipArray.append(chipValue!)
            
            let bet = Bet(type: betType, chips: [Chip(value: selectChipValue)])
//            let bet = Bet(type: betType, chips: chipArray)
            player.placeBet(bet)
//            print("chips count \(bet.chips.count) ")
            let currentBet = player.bets.filter { $0 .type == betType}
            singleBetChip = currentBet.reduce(0) { $0 + $1.totalAmount }
            
            singleBetAmountLabel.text = "\(singleBetChip)"
            
            sender.setImage(chipImage, for: .normal)
            
            totalBetAmount = player.bets.reduce(0) { $0 + $1.totalAmount}
            totalBetMoneyLabel.text = "  BET TOTAL MONEY: $ \(totalBetAmount)  "
            
            totalMoneyLabel.text = "  TOTAL MONEY: $ \(player.totalChips)  "
            
            createSFX(sfxUrl: chipSfxUrl!)
            
        } else {
            singleBetAmountLabel.text = "籌碼不足"
        }
        
        singleBetAmountLabel.textColor = .white
        singleBetAmountLabel.textAlignment = .center
        singleBetAmountLabel.backgroundColor = .gray
        singleBetAmountLabel.adjustsFontSizeToFitWidth = true
        singleBetAmountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        singleBetAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(singleBetAmountLabel)
        
        NSLayoutConstraint.activate([
            singleBetAmountLabel.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            singleBetAmountLabel.bottomAnchor.constraint(equalTo: sender.topAnchor, constant: -5),
            singleBetAmountLabel.widthAnchor.constraint(equalTo: sender.widthAnchor, multiplier: 1),
            singleBetAmountLabel.heightAnchor.constraint(equalTo: sender.heightAnchor, multiplier: 1)
        ])
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { Timer in
            self.singleBetAmountLabel.removeFromSuperview()
        }
        
    }
    
    
    
    func removeBet() {
        
        player.clearBets()
        
        totalBetAmount = player.bets.reduce(0) { $0 + $1.totalAmount}
        totalBetMoneyLabel.text = "  BET TOTAL MONEY: $ \(totalBetAmount)  "
        totalMoneyLabel.text = "  TOTAL MONEY: $ \(player.totalChips)  "
        
        for i in betButtonZeros {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButtonRightSides {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButtonLeftSides {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButton2To1Sides {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButtonINTs {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButtonUpSplits {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButtonSpiltOrStreets {
            i.setImage(nil, for: .normal)
        }
        
        
        for i in betButtonCorners {
            i.setImage(nil, for: .normal)
        }
        
        NotificationCenter.default.post(name: .totalChipsDidChange, object: nil)

    }
    
    
    
    func addColorBlinkingEffect(to view: UIView, duration: TimeInterval, times: Int) {
        guard times > 0 else {
            return
        }

        // 創建動畫
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)

        // 動畫內容：改變背景顏色
        animator.addAnimations {
            
            if view.backgroundColor == .clear { view.backgroundColor = .systemYellow }
            else if view.backgroundColor == .systemYellow { view.backgroundColor = .clear }
            
            if view.backgroundColor == .black { view.backgroundColor = .systemCyan }
            else if view.backgroundColor == .systemCyan { view.backgroundColor = .black }
            
            if view.backgroundColor == .systemRed { view.backgroundColor = .systemMint }
            else if view.backgroundColor == .systemMint { view.backgroundColor = .systemRed }
            
        }

        // 當動畫結束時，檢查是否需要重新啟動動畫
        animator.addCompletion { position in
            if position == .end {
                self.addColorBlinkingEffect(to: view, duration: duration, times: times - 1)
            }
        }

        // 開始動畫
        animator.startAnimation()
    }
    
    
    
    func checkSection(result: Int) {
        
        if result > 0 && result <= 18 {
            addColorBlinkingEffect(to: self.leftSideViews[0], duration: 1, times: 4)
        } else if result >= 19 {
            addColorBlinkingEffect(to: self.leftSideViews[5], duration: 1, times: 4)
        } else {
            addColorBlinkingEffect(to: self.zeroView, duration: 1, times: 4)
        }
        
        
        if result % 2 == 0 && result != 0 {
            addColorBlinkingEffect(to: self.leftSideViews[1], duration: 1, times: 4)
        } else if result % 2 != 0 && result != 0 {
            addColorBlinkingEffect(to: self.leftSideViews[4], duration: 1, times: 4)
        }
        
        
        if redNumbers.contains(result) {
            addColorBlinkingEffect(to: self.leftSideViews[2], duration: 1, times: 4)
        } else if blackNumbers.contains(result) {
            addColorBlinkingEffect(to: self.leftSideViews[3], duration: 1, times: 4)
        }
        
        
        if result <= 12 && result != 0 {
            addColorBlinkingEffect(to: self.rightSideViews[0], duration: 1, times: 4)
        } else if result <= 24 && result != 0 {
            addColorBlinkingEffect(to: self.rightSideViews[1], duration: 1, times: 4)
        } else if result <= 36 && result != 0 {
            addColorBlinkingEffect(to: self.rightSideViews[2], duration: 1, times: 4)
        }
        
        if numbers1ColumnArray.contains(result) {
            addColorBlinkingEffect(to: self.twoToOneViews[0], duration: 1, times: 4)
        } else if numbers2ColumnArray.contains(result) {
            addColorBlinkingEffect(to: self.twoToOneViews[1], duration: 1, times: 4)
        } else if numbers3ColumnArray.contains(result) {
            addColorBlinkingEffect(to: self.twoToOneViews[2], duration: 1, times: 4)
        }
        
        
        if result > 0 {
            addColorBlinkingEffect(to: self.numberViews[result - 1], duration: 1, times: 4)
        }
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Objc Function Section
    @objc func betButtonZeroTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonZeroReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        let betType = BetType.number(0)
        placeBetButtonSetting(betType: betType, sender: sender)
        
    }
    
    
    
    @objc func betButtonRightSideTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonRightSideReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        
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
    
    
    
    @objc func betButtonLeftSideTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonLeftSideReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        
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
    
    
    
    @objc func betButton2To1Touched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButton2To1Released(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        
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
    
    
    
    @objc func betButtonINTTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonINTReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        let betType = BetType.number(sender.tag)
        placeBetButtonSetting(betType: betType, sender: sender)
        
    }
    
    
    
    @objc func betButtonUpSplitTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonUpSplitReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        if sender.tag <= 3 {
            
            let betType = BetType.split([sender.tag, 0])
            placeBetButtonSetting(betType: betType, sender: sender)
            
        } else {
            
            let betType = BetType.split([sender.tag, sender.tag - 3])
            placeBetButtonSetting(betType: betType, sender: sender)
            
        }
        
        
    }
    
    
    
    @objc func betButtonLeftSplitTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonLeftSplitReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        let betType = BetType.split([sender.tag, sender.tag - 1])
        placeBetButtonSetting(betType: betType, sender: sender)
        
        
    }
    
    
    
    @objc func betButtonStreetTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonStreetReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        let betType = BetType.street(sender.tag)
        placeBetButtonSetting(betType: betType, sender: sender)
        
    }
    
    
    
    @objc func betButtonCornerTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.singleBetAmountLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func betButtonCornerReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.singleBetAmountLabel.transform = CGAffineTransform.identity
        }
        
        if sender.tag <= 3 {
            return
        } else {
            
            let betType = BetType.corner([sender.tag, sender.tag - 4, sender.tag - 3, sender.tag - 1])
            placeBetButtonSetting(betType: betType, sender: sender)
            
        }
    }
    
    
    
    @objc func removeBetButtonTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func removeBetButtonReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
        }
        
        removeBet()
        
    }
    
    
    
    @objc func reBetButtonTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func reBetButtonReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
        }
        
        theLastBets.forEach { Bet in
            
            
            switch Bet.type {
            case .number(let betNumber):
                let betButtonINT = betButtonINTs.first { $0.tag == betNumber }
                placeBetButtonSetting(betType: .number(betNumber), sender: betButtonINT!)
     
            case .firstTwelve:
                let betButtonRightSide1 = betButtonRightSides.first { $0.tag == 1 }
                placeBetButtonSetting(betType: .firstTwelve, sender: betButtonRightSide1!)
                
            case .secondTwelve:
                let betButtonRightSide2 = betButtonRightSides.first { $0.tag == 2 }
                placeBetButtonSetting(betType: .secondTwelve, sender: betButtonRightSide2!)
                
            case .thirdTwelve:
                let betButtonRightSide3 = betButtonRightSides.first { $0.tag == 3 }
                placeBetButtonSetting(betType: .thirdTwelve, sender: betButtonRightSide3!)
                
            case .red:
                let betButtonLeftSide3 = betButtonLeftSides.first { $0.tag == 3 }
                placeBetButtonSetting(betType: .red, sender: betButtonLeftSide3!)
                
            case .black:
                let betButtonLeftSide4 = betButtonLeftSides.first { $0.tag == 4 }
                placeBetButtonSetting(betType: .black, sender: betButtonLeftSide4!)
                
            case .odd:
                let betButtonLeftSide5 = betButtonLeftSides.first { $0.tag == 5 }
                placeBetButtonSetting(betType: .odd, sender: betButtonLeftSide5!)
                
            case .even:
                let betButtonLeftSide2 = betButtonLeftSides.first { $0.tag == 2 }
                placeBetButtonSetting(betType: .even, sender: betButtonLeftSide2!)
                
            case .firstHalf:
                let betButtonLeftSide1 = betButtonLeftSides.first { $0.tag == 1 }
                placeBetButtonSetting(betType: .firstHalf, sender: betButtonLeftSide1!)
                
            case .secondHalf:
                let betButtonLeftSide6 = betButtonLeftSides.first { $0.tag == 6 }
                placeBetButtonSetting(betType: .secondHalf, sender: betButtonLeftSide6!)
                
            case .firstColumn:
                let betButton2To1ST = betButton2To1Sides.first { $0.tag == 1 }
                placeBetButtonSetting(betType: .firstColumn, sender: betButton2To1ST!)
                
            case .secondColumn:
                let betButton2To1ND = betButton2To1Sides.first { $0.tag == 2 }
                placeBetButtonSetting(betType: .secondColumn, sender: betButton2To1ND!)
                
            case .thirdColumn:
                let betButton2To1RD = betButton2To1Sides.first { $0.tag == 2 }
                placeBetButtonSetting(betType: .thirdColumn, sender: betButton2To1RD!)
                
            case .split(let numbers):
                if numbers[1] == 0 || numbers[1] - numbers[0] == 3 {
                    let betButtonUpSpilt = betButtonUpSplits.first { $0.tag == numbers[0] }
                    placeBetButtonSetting(betType: .split([numbers[0], numbers[1]]), sender: betButtonUpSpilt!)
                } else if numbers[0] - numbers[1] == 1 {
                    let betButtonLeftSpilt = betButtonSpiltOrStreets.first { $0.tag == numbers[0] }
                    placeBetButtonSetting(betType: .split([numbers[0], numbers[1]]), sender: betButtonLeftSpilt!)
                }
                
            case .street(let number):
                let betButtonStreet = betButtonSpiltOrStreets.first { $0.tag == number }
                placeBetButtonSetting(betType: .street(number), sender: betButtonStreet!)
               
            case .corner(let numbers):
                let betButtonCorner = betButtonCorners.first { $0.tag == numbers[0] }
                placeBetButtonSetting(betType: .corner([numbers[0], numbers[1], numbers[2], numbers[3]]), sender: betButtonCorner!)
                
            }
            
        }
        
    }
    
    
    
    @objc func spinButtonTouched(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.wheelContainerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    
    @objc func spinButtonReleased(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform.identity
            self.wheelContainerView.transform = CGAffineTransform.identity
        }
        
        
        createSFX(sfxUrl: spinSfxUrl!)
        
        
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        arrowImageView.tintColor = .systemYellow
        arrowImageView.backgroundColor = .clear
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        resultLabel.textColor = .white
        resultLabel.font = UIFont.boldSystemFont(ofSize: 80)
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        wheelContainerView.backgroundColor = .systemGreen
        wheelContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        wheelImageView.image = UIImage(named: "Wheel")
        wheelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        wheelContainerView.addSubview(wheelImageView)
        wheelContainerView.addSubview(arrowImageView)
        wheelContainerView.addSubview(resultLabel)
        view.addSubview(wheelContainerView)
        
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
        
        
        wheelImageView.rotateGradually { [self] result in
            
            print(result)
            resultNumber = Int(result)!
            
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { Timer in
                self.resultLabel.text = result
            }
            
            
            Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { Timer in
                self.resultLabel.text = ""
                self.wheelContainerView.removeFromSuperview()
            }
            
            
            Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { [self] Timer in
                
                checkSection(result: resultNumber)
                
            }
            
            
            Timer.scheduledTimer(withTimeInterval: 9.5, repeats: false) { [self] Timer in
                
                theLastBets.removeAll()
                player.bets.forEach { theLastBets.append($0)}
                
                
                
                self.checkFinal = Int(self.player.checkWinning(number: self.resultNumber))
                print("checkFinal : \(self.checkFinal)")
                
                if self.checkFinal > 0 {
                    self.player.totalChips += Int(self.checkFinal)
                    self.checkFinalLabel.text = "+$\(checkFinal)"
                    
                } else {
                    
                }
                
                
                
                self.totalMoneyLabel.text = "  TOTAL MONEY: $ \(self.player.totalChips)  "
                self.player.bets.removeAll()
                // removeBet() 中的 player.clearBets() 函數中有一段 totalChips += totalBetsAmount 會先把已當作賭注的金額加回本金，
                // 這本來是在下好離手前清除賭注時將原本的賭注金額收回，但在輪盤開始轉之後這些當作賭注的金額不論輸贏都應該減去，
                // 不想再多寫一個函數所以在輪盤開始轉之後 removeBet() 函數之前先把 bets 裡的賭注去除。
                
                self.removeBet()
                
            }
            
            Timer.scheduledTimer(withTimeInterval: 11, repeats: false) { Timer in
                self.checkFinalLabel.text = ""
            }
            
            
        }
        
        
    }
    
    
    
    @objc func totalChipsDidChange(_ notification: Notification) {
        let selectedRow = self.chipPicker.selectedRow(inComponent: 0)
        if selectedRow == 6 {
            selectChipValue = player.totalChips
            // 這裡可以加上其他更新 UI 的代碼
        }
    }

    
    
    
    
}



extension Notification.Name {
    static let totalChipsDidChange = Notification.Name("totalChipsDidChange")
}
