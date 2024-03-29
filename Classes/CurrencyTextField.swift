//
//  CurrencyTextField.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 4/19/23.
//

import Foundation
class CurrencyTextField: UITextField {
    
    var passTextFieldText: ((String, Double?) -> Void)?
    
  
    /*var currency: Currency {
        didSet {
            guard let currency = currency else { return }
            numberFormatter.currencyCode = currency.code
            numberFormatter.locale = Locale(identifier: currency.locale)
        }
    }*/

    //Used to send clean double value back
    var amountAsDouble: Double?
    
    var startingValue: Double? {
        didSet {
            let nsNumber = NSNumber(value: startingValue ?? 0.0)
            self.text = numberFormatter.string(from: nsNumber)
        }
    }
    
   
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //locale and currencyCode set in currency property observer
        return formatter
    }()
    
  
    private var roundingPlaces: Int {
        return numberFormatter.maximumFractionDigits
    }
    
   
    private var isSymbolOnRight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //If using in SBs
        setup()
    }
    
   
    private func setup() {
        self.textAlignment = .right
        self.keyboardType = .numberPad
        self.contentScaleFactor = 0.5
        delegate = self

        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        updateTextField()
    }
    

    private func updateTextField() {
        var cleanedAmount = ""
        
        for character in self.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        //Format the number based on number of decimal digits
        if self.roundingPlaces > 0 {
            //ie. USD
            let amount = Double(cleanedAmount) ?? 0.0
            amountAsDouble = (amount / 100.0)
            let amountAsString = numberFormatter.string(from: NSNumber(value: amountAsDouble ?? 0.0)) ?? ""
            
            self.text = amountAsString
        } else {
            //ie. JPY
            let amountAsNumber = Double(cleanedAmount) ?? 0.0
            amountAsDouble = amountAsNumber
            self.text = numberFormatter.string(from: NSNumber(value: amountAsNumber)) ?? ""
        }
        
        passTextFieldText?(self.text!, amountAsDouble)
    }
    

    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}


extension CurrencyTextField: UITextFieldDelegate {
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastCharacterInTextField = (textField.text ?? "").last
        
        //Note - not the most straight forward implementation but this subclass supports both right and left currencies
        if string == "" && lastCharacterInTextField!.isNumber == false {
            //For hitting backspace and currency is on the right side
            isSymbolOnRight = true
        } else {
            isSymbolOnRight = false
        }
        
        return true
    }
}
