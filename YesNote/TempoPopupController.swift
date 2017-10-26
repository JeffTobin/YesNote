//
//  TempoPopupController.swift
//  YesNote
//
//  Created by Jeff Tobin on 10/25/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import UIKit

class TempoPopupController: UIViewController {

    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var tempoSliderRefernce: UISlider!
    let mainVC = UIApplication.shared.keyWindow?.rootViewController as! MainViewController?
    
    
    //formats tempo for display
    func formatTempo(tempo: Float) -> NSAttributedString {
        
        //add "bpm" to string
        var bpmString = String(round(tempo))
        let endIndex = bpmString.index(bpmString.endIndex, offsetBy: -2)
        bpmString = bpmString.substring(to: endIndex)
        bpmString.append(" bpm")
        
        //add underline to string
        let textAttributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let attributedString = NSAttributedString(string: bpmString, attributes: textAttributes)
        
        return attributedString
    }
    
    //assign tempo to display
    @IBAction func handleTempoSliderChage(_ sender: UISlider) {
        bpmLabel.attributedText = formatTempo(tempo: tempoSliderRefernce.value)
    }
    
    
    @IBAction func handleDoneButtonPress(_ sender: UIButton) {
        
        //store tempo
        mainVC?.tempo = round(tempoSliderRefernce.value)
        
        //dismiss popover
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //restore tempo data
        let tempo = (mainVC?.tempo)!
        bpmLabel.attributedText = formatTempo(tempo: tempo)
        tempoSliderRefernce.value = tempo
    }
}
