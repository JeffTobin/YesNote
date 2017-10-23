//
//  ChordSelectViewController.swift
//  PickerExample
//
//  Created by Dale Haverstock on 12/1/16.
//  Copyright © 2016 Elad. All rights reserved.
//

import UIKit

class ChordSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let scales = ["Ionian","Dorian","Phrygian","Lydian","Mixolydian","Aeloian","Locrian"]
    let roots = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selectionLabel: UILabel!
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        let d1 = roots[picker.selectedRow(inComponent: 0)]
        let d2 = scales[picker.selectedRow(inComponent: 1)]
        let d3 = roots[picker.selectedRow(inComponent: 2)]
        let d4 = String(picker.selectedRow(inComponent: 3))
        
        let chordText = d3 + " " + d4 + " ▾"
        let scaleText = d1 + " " + d2
        let mainVC = UIApplication.shared.keyWindow?.rootViewController as! MainViewController?
        mainVC?.chordButton.setTitle(chordText as String, for: .normal)
        mainVC?.scaleLabel.text = scaleText as String
        
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
        
        if component == 0 || component == 2 {
            return roots.count
        }
        else if component == 1 {
            return scales.count
        }
        else if component == 3 {
            return 10
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        if component == 0 || component == 2 {
            pickerLabel?.text = roots[row]
        }
        else if component == 1 {
            pickerLabel?.text = scales[row]
        }
        else if component == 3 {
            let numberString = NSString(format: "%d", row) as String
            pickerLabel?.text = numberString
        }
        else{
            pickerLabel?.text = ""
        }
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 75.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let d1 = roots[picker.selectedRow(inComponent: 0)]
        let d2 = scales[picker.selectedRow(inComponent: 1)]
        let d3 = roots[picker.selectedRow(inComponent: 2)]
        let d4 = String(picker.selectedRow(inComponent: 3))

        let numberString = d1 + " " + d2 + " / " + d3 + " " + d4
        
        let textAttributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let attributedString = NSAttributedString(string: numberString, attributes: textAttributes)
        selectionLabel.attributedText = attributedString
        
    }
    
}


