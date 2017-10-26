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
    var oscillators = [Int: AKOscillator]()             //instruments that play drones
    var playing = false                                 //controls mute button
    var _numNotes = 0                                   //number of notes in the selected chord
                                                        //https://pages.mtu.edu/~suits/notefreqs.html
    var frequencies = [0: 261.63, 1: 277.18, 2: 293.66, 3: 311.13, 4: 329.63, 5: 349.23, 6: 369.99, 7: 392.00, 8: 415.30, 9: 440.00, 10: 466.16, 11: 493.88]                 //12 notes of the chromatic scale (basically all notes)
    var outputArray = {(source: [Int: AKOscillator]) -> [AKOscillator] in
        var chord = [AKOscillator]()                    //takes dictionary of oscillators, transfers to array indexes (chord)
        for osc in source {
            chord.append(osc.value)
        }
        return chord
    }
    
    init(numNotes: Int) {
        _numNotes = numNotes
        for i in 0..._numNotes - 1 {
            oscillators[i] = AKOscillator()            //create an oscillator instance for each note of the chord
        }
        AudioKit.output = AKMixer(outputArray(oscillators))
        AudioKit.start()                               //initiate audio output source
    }
    
    func changeVolume(note: Int, volume: Float) {      //drone volume
        oscillators[note]?.amplitude = Double(volume)
    }
    
    func togglePlay(tempo: Float, chord: [Int]) {

        if playing == true {
            for osc in oscillators {
                osc.value.stop()
            }
            playing = false
        }
        else if chord.count != 0 {
            for osc in oscillators {
                osc.value.amplitude = Double(0.5)      //default volume
            }                                          //set frequency of each oscilator to chord tones
            for (index, osc) in oscillators.enumerated() {
                osc.value.frequency = frequencies[chord[index]]!
            }
            for osc in oscillators {                   //if stopped, play
                osc.value.start()
            } 
            playing = true
        }
        else {
                                                       //nothing to see here just a bug fix
        }
    }
}

