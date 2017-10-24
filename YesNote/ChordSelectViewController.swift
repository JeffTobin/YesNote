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
    
    //placeholders----------------------------------------------------------------------------------------------
    func testFunc(row1: Int, row2: Int, row3: Int) -> [String]{
        if row3 % 2 == 0{
            return ["1","2","3","4","5"]
        }
        else{
            return ["One","Two","Three"]
        }
    }
    //----------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selectionLabel: UILabel!
    let mainVC = UIApplication.shared.keyWindow?.rootViewController as! MainViewController?
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        mainVC?.row1 = picker.selectedRow(inComponent: 0)
        mainVC?.row2 = picker.selectedRow(inComponent: 1)
        mainVC?.row3 = picker.selectedRow(inComponent: 2)
        mainVC?.row4 = picker.selectedRow(inComponent: 3)
        
        let r1 = roots [(mainVC?.row1)!]
        let r2 = scales[(mainVC?.row2)!]
        let r3 = roots [(mainVC?.row3)!]
        let r4 = String((mainVC?.row4)!)
        
        let chordText = r3 + " " + r4 + " ▾"
        let scaleText = r1 + " " + r2
        mainVC?.chordButton.setTitle(chordText as String, for: .normal)
        mainVC?.scaleLabel.text = scaleText as String
        
        mainVC?.numNotesInChord = 1 + picker.selectedRow(inComponent: 3)
        mainVC?.DroneTableView.reloadData()
        mainVC?.audioPlayer.togglePlay(chord: [])
        mainVC?.audioPlayer = AudioPlayer(numNotes:(mainVC?.numNotesInChord)!)
        
        DispatchQueue.main.async {
            self.mainVC?.viewWillLayoutSubviews()
        }
        self.dismiss(animated: true, completion: nil)
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
            let chordstext = testFunc(row1: picker.selectedRow(inComponent: 0),row2: picker.selectedRow(inComponent: 1),row3: picker.selectedRow(inComponent: 2))
            return chordstext.count
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
            let chordstext = testFunc(row1: picker.selectedRow(inComponent: 0),row2: picker.selectedRow(inComponent: 1),row3: picker.selectedRow(inComponent: 2))
            if chordstext.indices.contains(row) {
                pickerLabel?.text = chordstext[row]
            }
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
        pickerView.reloadAllComponents()
        
        let r1 = roots [picker.selectedRow(inComponent: 0)]
        let r2 = scales[picker.selectedRow(inComponent: 1)]
        let r3 = roots [picker.selectedRow(inComponent: 2)]
        let r4 = String(picker.selectedRow(inComponent: 3))

        let numberString = "\(r1) \(r2) / \(r3) \(r4)"
        
        let textAttributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let attributedString = NSAttributedString(string: numberString, attributes: textAttributes)
        selectionLabel.attributedText = attributedString
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        let r1 = (mainVC?.row1)!
        let r2 = (mainVC?.row2)!
        let r3 = (mainVC?.row3)!
        let r4 = (mainVC?.row4)!
        
        let p1 = roots [r1]
        let p2 = scales[r2]
        let p3 = roots [r3]
        let p4 = String(r4)
        
        picker.selectRow(r1, inComponent:0, animated:true)
        picker.selectRow(r2, inComponent:1, animated:true)
        picker.selectRow(r3, inComponent:2, animated:true)
        picker.selectRow(r4, inComponent:3, animated:true)
        
        let numberString = "\(p1) \(p2) / \(p3) \(p4)"
        
        let textAttributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let attributedString = NSAttributedString(string: numberString, attributes: textAttributes)
        selectionLabel.attributedText = attributedString
    }
}


