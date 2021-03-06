//
//  CartProductStepper.swift
//  TestShop
//
//  Created by Egor on 23.11.2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

/**
 Кастомный UIStepper
 */

class CartProductStepper: UIView {
    
    private let decreaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("-", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.4949728251, green: 0.3844715953, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /**
     Minimum value of stepper
     */
    
    var minimumValue: Int = 0 {
        didSet {
            if value < minimumValue {
                stepperValue = minimumValue
            }
        }
    }
    
    /**
     Maximum value of stepper
     */
    
    var maximumValue: Int = -1 {
        didSet {
            if value > maximumValue {
                stepperValue = maximumValue
            }
        }
    }
    
    private var handler: () -> Void = {  }
    
    private var stepperValue: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
            handler()
            
            if stepperValue == maximumValue {
                increaseButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            } else {
                increaseButton.backgroundColor = .white
            }
            
            if stepperValue == minimumValue {
                decreaseButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            } else {
                decreaseButton.backgroundColor = .white
            }
        }
    }
    /**
     return stepper value
     */
    var value: Int {
        get {
            return stepperValue
        }
        set {
            stepperValue = newValue
        }
    }
    
    @objc private func decreaseValue() {
        guard value > minimumValue else { return }
        stepperValue -= 1
    }
    
    @objc private func increaseValue() {
        guard value < maximumValue || maximumValue == -1 else { return }
        stepperValue += 1
    }
    
    func addHandler(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        decreaseButton.addTarget(self, action: #selector(decreaseValue), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseValue), for: .touchUpInside)
        
        
        backgroundColor = .clear
        addSubview(decreaseButton)
        addSubview(increaseButton)
        addSubview(valueLabel)
        
        decreaseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        decreaseButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        decreaseButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        decreaseButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        decreaseButton.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -10).isActive = true
        decreaseButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        valueLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        valueLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 10).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -10).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        increaseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        increaseButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        increaseButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        increaseButton.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 10).isActive = true
        increaseButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        increaseButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
