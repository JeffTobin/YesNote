//
//  ViewController.swift
//  PickerExample
//
//  Created by Jeff Tobin on 10/13/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource {
   
    //num drone notes - no more than 8 interface builder doesn't like it
    var numNotesInChord = 3
    //stored chord picker ata
    var row1 = 0
    var row2 = 0
    var row3 = 0
    var row4 = 0
    //stored rhythm selector data
    var selectedRow = IndexPath(row: 0, section: 0)
    //stored tempo data
    var tempo : Float = 120.0
    
    
    
    //placeholders----------------------------------------------------------------------------------------------
    func enterChord()->[Int] {
        var notes = Array(repeating: 0, count: numNotesInChord + 1)
        
        for i in 0...numNotesInChord {
            notes[i] = (Int(arc4random_uniform(11)))
        }
        return notes
    }
    //----------------------------------------------------------------------------------------------------------
    
    
    
    
//----------------------------------------------------------------------------------------------------------
// Popup Selectors controlls
//----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var chordButton: UIButton!
    @IBOutlet weak var rhythmVolume: UIBorderButton!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var tempoButtonReference: UIButton!
    
    
    //handle chord selector button press
    @IBAction func chordPopUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "chordPopUp", sender: self)
    }
    @IBAction func rhythmSelector(_ sender: UIButton) {
        self.performSegue(withIdentifier: "rhythmSelector", sender: self)
    }
    @IBAction func tempoSelector(_ sender: UIButton) {
        self.performSegue(withIdentifier: "tempoSelector", sender: self)
    }
    
    
    //force display of modal view as popup
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    //handle transition of view to popup
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chordPopUp" {
            let destinationVC = segue.destination
            destinationVC.popoverPresentationController?.sourceRect = CGRect(x: chordButton.frame.size.width/2, y: chordButton.frame.size.height, width: 0, height: 0)
            let frameSize = self.view.frame.width - 10
            destinationVC.preferredContentSize = CGSize(width: frameSize, height: frameSize)
            
            if let PopUp = destinationVC.popoverPresentationController{
                PopUp.delegate = self
            }
        }
        else if segue.identifier == "rhythmSelector" {
            let destinationVC = segue.destination
            destinationVC.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 0, width: 0, height: 0)
            let frameSize = self.view.frame.width - 10
            destinationVC.preferredContentSize = CGSize(width: frameSize, height: frameSize)
            
            if let PopUp = destinationVC.popoverPresentationController{
                PopUp.delegate = self
            }
        }
        else if segue.identifier == "tempoSelector" {
            let destinationVC = segue.destination
            destinationVC.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 0, width: 0, height: 0)
            let frameSize = self.view.frame.width - 10
            destinationVC.preferredContentSize = CGSize(width: frameSize, height: 175)
            
            if let PopUp = destinationVC.popoverPresentationController{
                PopUp.delegate = self
            }
        }
    }
    
    
    
//----------------------------------------------------------------------------------------------------------
// Drone Volume controlls & Rhythm Volume
//----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var DroneTableView: UITableView!
    var toggleButtons = [Int: (Bool, Float)]()
    var volumeFloats = [Float]()
    var RhythmvolMute = false
    var audioPlayer : AudioPlayer!
    
    
    //number of drone note rows----------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numNotesInChord
    }
    
    
    //called during droneTable setup-----------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DroneTableView.dequeueReusableCell(withIdentifier: "ChordToneReusableCell") as! CellTableViewCell
        
        //make droneTable transparent
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        //set default volume slider position & mute toggle color
        cell.droneNoteAndMuteButton.backgroundColor = UIColor(red:0.00, green:0.33, blue:0.58, alpha:1.0)
        cell.droneNoteAndMuteButton.setTitleColor(UIColor.white, for: .normal)
        cell.volumeSlider.setValue(0.5, animated: true)
        
        //add action to volume sliders
        cell.volumeSlider.tag = indexPath.row
        cell.volumeSlider.addTarget(self, action:#selector(sliderValueChange(sender:)), for: .valueChanged)
        
        //add action to mute toggle buttons
        cell.droneNoteAndMuteButton.setTitle("G", for: .normal)
        cell.droneNoteAndMuteButton.tag = indexPath.row
        cell.droneNoteAndMuteButton.reference = cell.droneNoteAndMuteButton
        cell.droneNoteAndMuteButton.addTarget(self, action:#selector(droneButtonPress(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    //handles change in volume slider----------------------------------------
    func sliderValueChange(sender: UISlider) {
        let sliderRow = sender.tag
        
        //add row to toggleButtons dictionary if it does not exsist
        if toggleButtons[sliderRow] == nil{
            toggleButtons[sliderRow] = (true, 0.0)
        }
        
        //if not muted then change volume
        if toggleButtons[sliderRow]?.0 == true {
            volumeFloats[sliderRow + 1] = sender.value
            audioPlayer.changeVolume(note: sliderRow + 1, volume: sender.value)
        }
        //if muted then store changed volume
        else{
            toggleButtons[sliderRow] = (false, sender.value)
        }
    }
    
    
    //handles toggling of drone note mute button-----------------------------
    func droneButtonPress(sender: DroneNoteAndMuteButton) {
        let buttonRow = sender.tag
        
        //add row to toggleButtons dictionary if it does not exsist
        if toggleButtons[buttonRow] == nil{
            toggleButtons[buttonRow] = (true, 0.0)
        }
        
        //mutes drone note (change to false)
        if toggleButtons[buttonRow]?.0 == true {
            sender.reference.backgroundColor = UIColor.clear
            sender.reference.setTitleColor(UIColor(red:0.00, green:0.33, blue:0.58, alpha:1.0), for: .normal)
            
            toggleButtons[buttonRow] = (false, Float(volumeFloats[buttonRow + 1]))
            audioPlayer.changeVolume(note: buttonRow + 1, volume: 0.0)
            volumeFloats[buttonRow + 1] = 0.0
        }
        //unmute drone note
        else {
            sender.reference.backgroundColor = UIColor(red:0.00, green:0.33, blue:0.58, alpha:1.0)
            sender.reference.setTitleColor(UIColor.white, for: .normal)
            
            volumeFloats[buttonRow + 1] = (toggleButtons[buttonRow]?.1)!
            audioPlayer.changeVolume(note: buttonRow + 1, volume: (toggleButtons[buttonRow]?.1)!)
            toggleButtons[buttonRow] = (true, Float(volumeFloats[buttonRow + 1]))
        }
    }
    
    
    //handles toggling of rhythm mute button---------------------------------
    @IBAction func rhythmVolumeButton(_ sender: UIButton) {
        if RhythmvolMute == false {
            //mute rhythm volume
            rhythmVolume.setImage(UIImage(named: "Untitled Diagram3"), for: .normal)
            volumeFloats[0] = 0.0
            audioPlayer.changeVolume(note: 0, volume: 0.0)
            RhythmvolMute = true
        }
        else{
            //unmute rhythm volume
            rhythmVolume.setImage(UIImage(named: "Untitled Diagram2"), for: .normal)
            volumeFloats[0] = 1.0
            audioPlayer.changeVolume(note: 0, volume: 1.0)
            RhythmvolMute = false
        }
    }
    
    
    //handles toggling of play/pause button-----------------------------------
    @IBAction func playPauseButton(_ sender: UIButton) {
        audioPlayer.togglePlay(chord: enterChord())
        for i in 0...numNotesInChord {
            audioPlayer.changeVolume(note: i, volume: Float(volumeFloats[i]))
        }
    }
    
    
    
//----------------------------------------------------------------------------------------------------------
// initilization Functions
//----------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rhythmView: UIView!
    @IBOutlet weak var playPauseRefrence: UIButton!
    
    
    //make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //reset variables for new chord size
    func resetVariables() {
        audioPlayer = AudioPlayer(numNotes: numNotesInChord + 1)
        toggleButtons.removeAll()
        volumeFloats = Array(repeating: 0.5, count: numNotesInChord + 1)
        
        if RhythmvolMute == false {
            volumeFloats[0] = 1.0
        }
        else {
            volumeFloats[0] = 0.0
        }
    }
    
    
    //initialize view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //setup droneTableView
        DroneTableView.dataSource = self
        DroneTableView.backgroundColor = UIColor.clear
        DroneTableView.alwaysBounceVertical = false
        DroneTableView.isScrollEnabled = false
        DroneTableView.allowsSelection = false
        
        //setup scrollView
        view.addSubview(scrollView)
        view.bringSubview(toFront: playPauseRefrence)
        
        resetVariables()
    }
    
    
    //initialize variables and subviews (called after viewDidLoad)
    override func viewWillLayoutSubviews(){
        
        //This code will run in the main thread:
        DispatchQueue.main.async {
            var frame = self.DroneTableView.frame
            frame.size.height = self.DroneTableView.contentSize.height
            self.DroneTableView.frame = frame
        }
        
        //adjust scrolling height
        if self.DroneTableView.contentSize.height > 138 {
            let scrollHeight = (self.view.frame.height + self.DroneTableView.contentSize.height) - 202
            scrollView.contentSize = CGSize(width:self.view.frame.width, height: scrollHeight)
        }
        else{
            scrollView.contentSize = CGSize(width:self.view.frame.width, height: self.view.frame.height - 70)
        }
        let Y_offset = self.DroneTableView.contentSize.height + 178
        rhythmView.frame.origin.y = Y_offset
    }
}
