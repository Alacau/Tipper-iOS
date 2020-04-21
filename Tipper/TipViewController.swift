//
//  TipViewController.swift
//  Tipper
//
//  Created by Alan Cao on 4/21/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
        
    let totalTitle = UILabel()
    var totalAmount = UILabel()
    
    let billLabel = UILabel()
    let billAmount = UITextField()
    
    let splitLabel = UILabel()
    let splitMinus = UIButton()
    let splitAmount = UILabel()
    let splitPlus = UIButton()
    
    let tipLabel = UILabel()
    let tipAmount = UILabel()
    let tipSelector = UISegmentedControl(items: ["0%", "10%", "15%", "20%", "25%"])
    
    let tapGesture = UITapGestureRecognizer()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        
        setupNavigation()
        setupTotal()
        setupBill()
        setupSplit()
        setupTip()
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
        navigationItem.title = "Tipper"
    }
    
    func setupTotal() {
        view.addSubview(totalTitle)
        view.addSubview(totalAmount)
                
        totalTitle.text = "Total Per Person"
        totalTitle.textColor = .systemPink
        totalTitle.font = UIFont(name: "Avenir Next", size: 20)
        totalTitle.translatesAutoresizingMaskIntoConstraints = false
        totalTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        totalAmount.text = "$0.00"
        totalAmount.textColor = .systemPink
        totalAmount.font = UIFont(name: "Avenir Next", size: 36)
        totalAmount.translatesAutoresizingMaskIntoConstraints = false
        totalAmount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalAmount.topAnchor.constraint(equalTo: totalTitle.bottomAnchor, constant: 8).isActive = true
    }
    
    func setupBill() {
        view.addSubview(billLabel)
        view.addSubview(billAmount)
        
        billLabel.text = "Bill Amount"
        billLabel.textColor = .placeholderText
        billLabel.font = UIFont(name: "Avenir Next", size: 20)
        billLabel.translatesAutoresizingMaskIntoConstraints = false
        billLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        billLabel.trailingAnchor.constraint(equalTo: billAmount.leadingAnchor, constant: -20).isActive = true
        billLabel.topAnchor.constraint(equalTo: totalAmount.bottomAnchor, constant: 50).isActive = true
        
        billAmount.textColor = .systemPink
        billAmount.placeholder = "$0.00"
        billAmount.borderStyle = .roundedRect
        billAmount.keyboardType = .decimalPad
        billAmount.translatesAutoresizingMaskIntoConstraints = false
        billAmount.leadingAnchor.constraint(equalTo: billLabel.trailingAnchor, constant: 20).isActive = false
        billAmount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        billAmount.centerYAnchor.constraint(equalTo: billLabel.centerYAnchor).isActive = true
        billAmount.widthAnchor.constraint(equalToConstant: 150).isActive = true
        billAmount.addTarget(self, action: #selector(calculateTip), for: .editingChanged)
    }
    
    func setupSplit() {
        view.addSubview(splitLabel)
        view.addSubview(splitMinus)
        view.addSubview(splitAmount)
        view.addSubview(splitPlus)
        
        splitLabel.text = "Split"
        splitLabel.textColor = .placeholderText
        splitLabel.font = UIFont(name: "Avenir Next", size: 20)
        splitLabel.translatesAutoresizingMaskIntoConstraints = false
        splitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        splitLabel.topAnchor.constraint(equalTo: billLabel.bottomAnchor, constant: 50).isActive = true
        
        splitMinus.setTitle("-", for: .normal)
        splitMinus.setTitleColor(.systemPink, for: .normal)
        splitMinus.backgroundColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 0.25)
        splitMinus.layer.cornerRadius = 10
        splitMinus.translatesAutoresizingMaskIntoConstraints = false
        splitMinus.trailingAnchor.constraint(equalTo: splitAmount.leadingAnchor, constant: -12).isActive = true
        splitMinus.centerYAnchor.constraint(equalTo: splitLabel.centerYAnchor).isActive = true
        splitMinus.addTarget(self, action: #selector(stepDown), for: .touchUpInside)
        
        splitAmount.text = "1"
        splitAmount.textColor = .systemPink
        splitAmount.font = UIFont(name: "Avenir Next", size: 20)
        splitAmount.translatesAutoresizingMaskIntoConstraints = false
        splitAmount.trailingAnchor.constraint(equalTo: splitPlus.leadingAnchor, constant: -12).isActive = true
        splitAmount.centerYAnchor.constraint(equalTo: splitLabel.centerYAnchor).isActive = true
        
        splitPlus.setTitle("+", for: .normal)
        splitPlus.setTitleColor(.systemPink, for: .normal)
        splitPlus.backgroundColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 0.25)
        splitPlus.layer.cornerRadius = 10
        splitPlus.translatesAutoresizingMaskIntoConstraints = false
        splitPlus.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        splitPlus.centerYAnchor.constraint(equalTo: splitLabel.centerYAnchor).isActive = true
        splitPlus.addTarget(self, action: #selector(stepUp), for: .touchUpInside)
    }
    
    func setupTip() {
        view.addSubview(tipLabel)
        view.addSubview(tipAmount)
        view.addSubview(tipSelector)
        
        tipLabel.text = "Tip"
        tipLabel.textColor = .placeholderText
        tipLabel.font = UIFont(name: "Avenir Next", size: 20)
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tipLabel.topAnchor.constraint(equalTo: splitLabel.bottomAnchor, constant: 50).isActive = true
        
        tipAmount.text = "$0.00"
        tipAmount.textColor = .systemPink
        tipAmount.font = UIFont(name: "Avenir Next", size: 20)
        tipAmount.translatesAutoresizingMaskIntoConstraints = false
        tipAmount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tipAmount.centerYAnchor.constraint(equalTo: tipLabel.centerYAnchor).isActive = true
        
        tipSelector.selectedSegmentIndex = 0
        tipSelector.backgroundColor = UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 0.25)
        tipSelector.translatesAutoresizingMaskIntoConstraints = false
        tipSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        tipSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        tipSelector.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 30).isActive = true
        tipSelector.addTarget(self, action: #selector(tipSelected), for: .valueChanged)
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
        
        let tip = bill * percent
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
    
    @objc func updateLabels() {
    }
}
