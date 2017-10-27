//
//  Rhythm.swift
//  YesNote
//
//  Created by Wintermute on 10/25/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import Foundation

class Rhythm {
    
    var currentRhythm: rhythmObj?
    
    // Rhythm data type
    struct rhythmObj {
        var name: String?
        var font: String?
        var midiFile: String?
    }
    
    // Storage for all rhythms
    var rhythmBank = [rhythmObj]()
    
    init () {
        
        // Adding rhythms to storage
        rhythmBank.append(rhythmObj(name: "Basic Swing", font: "$$ Q e e. e e. e e \\ e E e e. e s e s",midiFile: "QuarterNotes.mid"))
    }

    // Behaviour
    
    func getRhythm() -> (name: String, font: String) {
        return (currentRhythm!.name!, currentRhythm!.font!)
    }
    
    func setRhythm (rhythmChoice: Int) {
        currentRhythm = rhythmBank[rhythmChoice]
    }
    func getMIDIdata() -> String {
        return currentRhythm!.midiFile!
    }
    
}
