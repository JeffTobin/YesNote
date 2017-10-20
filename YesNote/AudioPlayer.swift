//
//  AudioPlayer.swift
//  YesNote
//
//  Created by Jeff Tobin on 10/20/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import Foundation

//
//  ViewController.swift
//  AE
//
//  Created by Zack Ulam on 10/16/17.
//  Copyright © 2017 Zack Ulam. All rights reserved.
//

import UIKit
import AudioKit
import Darwin

class AudioPlayer {
    
    var oscillators = [Int: AKOscillator]()
    var playing = false
    var _numNotes = 0
    var frequencies = [0: 523.25, 1: 554.37, 2: 587.33, 3: 622.25, 4: 659.26, 5: 698.46, 6: 739.99, 7: 783.99, 8: 830.61, 9: 880, 10: 932.33, 11: 987.77]

    
    init(numNotes: Int) {
        _numNotes = numNotes
        for i in 0..._numNotes - 1 {
            oscillators[i] = AKOscillator()
        }
        //oscillators = Array(repeating: AKOscillator(), count: numNotes)
        AudioKit.output = AKMixer(oscillators[0],oscillators[1],oscillators[2],oscillators[3])
        AudioKit.start()
    }
    
    func changeVolume(note: Int, volume: Float) {
        oscillators[note]?.amplitude = Double(volume)
    }
    
    func togglePlay(chord: [Int]) {

        if playing == true {
            for osc in oscillators {
                osc.value.stop()
            }
            playing = false
        }
        else {
            for osc in oscillators {
                osc.value.amplitude = Double(0.5)
            }
            for (index, osc) in oscillators.enumerated() {
                osc.value.frequency = frequencies[chord[index]]!
            }
            for osc in oscillators {
                osc.value.start()
            }
            playing = true
        }
    }
}

