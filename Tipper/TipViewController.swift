//
//  TipViewController.swift
//  Tipper
//
//  Created by Alan Cao on 4/21/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
      
    // MARK: - Properties
    
    private let totalTitle: UILabel = {
        let label = UILabel()
        label.text = "Total Per Person"
        label.textColor = .systemPink
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    private let totalAmount: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.textColor = .systemPink
        label.font = UIFont(name: "Avenir Next", size: 36)
        
        return label
    }()
    
    private let billLabel: UILabel = {
        let label = UILabel()
        label.text = "Bill Amount"
        label.textColor = .placeholderText
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    private let billAmount: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "$0.00")
        textField.addTarget(self, action: #selector(calculateTip), for: .editingChanged)
        textField.setDimensions(width: 86, height: 35)
        
        return textField
    }()
        
    private let splitLabel: UILabel = {
        let label = UILabel()
        label.text = "Split"
        label.textColor = .placeholderText
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    private let splitMinus: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 0.25)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(stepDown), for: .touchUpInside)
        
        return button
    }()
    
    private let splitAmount: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .systemPink
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    private let splitPlus: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 0.25)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(stepUp), for: .touchUpInside)
        
        return button
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip"
        label.textColor = .placeholderText
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    private let tipAmount: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.textColor = .systemPink
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
        
    private let tipSelector: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["0%", "10%", "15%", "20%", "25%"])
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.backgroundColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 0.25)
        segmentedControl.addTarget(self, action: #selector(tipSelected), for: .valueChanged)

        return segmentedControl
    }()
        
    let tapGesture = UITapGestureRecognizer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        setupTip()
    }
    
    func configureUI() {
        self.title = "Tipper"
        view.backgroundColor = .white
        
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        
        setupNavigation()
        
        view.addSubview(totalTitle)
        totalTitle.centerX(inView: view)
        totalTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        
        view.addSubview(totalAmount)
        totalAmount.centerX(inView: view)
        totalAmount.anchor(top: totalTitle.bottomAnchor, paddingTop: 8)
        
        let billStack = UIStackView(arrangedSubviews: [billLabel, billAmount])
        billStack.axis = .horizontal
        view.addSubview(billStack)
        billStack.anchor(top: totalAmount.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        let stepperStack = UIStackView(arrangedSubviews: [splitMinus, splitAmount, splitPlus])
        stepperStack.axis = .horizontal
        stepperStack.spacing = 8
        let splitStack = UIStackView(arrangedSubviews: [splitLabel, stepperStack])
        splitStack.axis = .horizontal
        view.addSubview(splitStack)
        splitStack.anchor(top: billStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        let tipStack = UIStackView(arrangedSubviews: [tipLabel, tipAmount])
        tipStack.axis = .horizontal
        view.addSubview(tipStack)
        tipAmount.anchor(right: tipStack.rightAnchor)
        tipStack.anchor(top: splitStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(tipSelector)
        tipSelector.anchor(top: tipStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 40, paddingRight: 40)
    }

    func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPink

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
                
        // Navigation bar appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        //navigationItem.title = self.title
    }
    
    @objc func tipSelected() {
        switch tipSelector.selectedSegmentIndex {
        case 0:
            calculateTip(percent: 0)
        case 1:
            calculateTip(percent: 0.10)
        case 2:
            calculateTip(percent: 0.15)
        case 3:
            calculateTip(percent: 0.20)
        case 4:
            calculateTip(percent: 0.25)
        default:
            return
        }
    }
    
    @objc func calculateTip(percent: Double) {
        let bill = Double(billAmount.text!) ?? 0
        let split = Double(splitAmount.text!) ?? 0
        
        let tips = [0, 0.10, 0.15, 0.20, 0.25]
        let tip = bill * tips[tipSelector.selectedSegmentIndex]
        let total = (bill + tip) / split
        
        totalAmount.text = String(format: "$%.2f", total)
        tipAmount.text = String(format: "$%.2f", tip)
    }
    
    @objc func stepDown() {
        let bill = Double(billAmount.text!) ?? 0
        var split = Double(splitAmount.text!) ?? 0
        
        var convertedString = Int(splitAmount.text!) ?? 1
        convertedString -= 1
        split = Double(convertedString)
        if convertedString <= 1 {
            convertedString = 1
            split = Double(convertedString)
        }
        
        let tips = [0, 0.10, 0.15, 0.20, 0.25]
        let tip = bill * tips[tipSelector.selectedSegmentIndex]
        let total = (bill + tip) / split
        
        totalAmount.text = String(format: "$%.2f", total)
        tipAmount.text = String(format: "$%.2f", tip)
        splitAmount.text = String(convertedString)
    }
    
    @objc func stepUp() {
        let bill = Double(billAmount.text!) ?? 0
        var split = Double(splitAmount.text!) ?? 0
    
        var convertedString = Int(splitAmount.text!) ?? 1
        convertedString += 1
        split = Double(convertedString)
        if convertedString >= 100 {
            convertedString = 100
            split = Double(convertedString)
        }
        
        let tips = [0, 0.10, 0.15, 0.20]
        let tip = bill * tips[tipSelector.selectedSegmentIndex]
        let total = (bill + tip) / split
        
        totalAmount.text = String(format: "$%.2f", total)
        tipAmount.text = String(format: "$%.2f", tip)
        splitAmount.text = String(convertedString)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
