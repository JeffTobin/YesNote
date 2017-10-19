//
//  ChordSelectViewController.swift
//  PickerExample
//
//  Created by Dale Haverstock on 12/1/16.
//  Copyright © 2016 Elad. All rights reserved.
//

import UIKit

class ChordSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //@IBOutlet weak var pickerValue: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selectionLabel: UILabel!
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        let d1 = picker.selectedRow(inComponent: 0)
        let d2 = picker.selectedRow(inComponent: 1)
        let d3 = picker.selectedRow(inComponent: 2)
        let d4 = picker.selectedRow(inComponent: 3)
        
        var numberString = String(format: "  %d.%d%d%d", d1, d2, d3, d4)
        numberString = numberString + " ▾"
        let mainVC = UIApplication.shared.keyWindow?.rootViewController as! MainViewController?
        mainVC?.chordButton.setTitle(numberString as String, for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let numberString = NSString(format: "%d", row) as String
        return numberString
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 75.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let d1 = picker.selectedRow(inComponent: 0)
        let d2 = picker.selectedRow(inComponent: 1)
        let d3 = picker.selectedRow(inComponent: 2)
        let d4 = picker.selectedRow(inComponent: 3)

        let numberString = String(format: "%d.%d%d%d", d1, d2, d3, d4)
        
        let textAttributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let attributedString = NSAttributedString(string: numberString, attributes: textAttributes)
        selectionLabel.attributedText = attributedString
        
    }
    
}


