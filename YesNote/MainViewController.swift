//
//  ViewController.swift
//  PickerExample
//
//  Created by Jeff Tobin on 10/13/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource {
    var numNotesInChord = 4  //no more than 7 interface builder doesn't like it
    
    
//placeholders----------------------------------------------------------------------------------------------
    func enterChord()->[Int] {
        var notes = Array(repeating: 0, count: numNotesInChord)
            
        for i in 0...numNotesInChord - 1 {
            notes[i] = (Int(arc4random_uniform(11)))
        }
        return notes
    }
//----------------------------------------------------------------------------------------------------------
    
    
 
//----------------------------------------------------------------------------------------------------------
// Drone Volume controlls
//----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var DroneTableView: UITableView!
    var toggleButtons = [Int: (Bool, Float)]()
    var volumeFloats = [Float]()
    var audioPlayer : AudioPlayer!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numNotesInChord
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DroneTableView.dequeueReusableCell(withIdentifier: "ChordToneReusableCell") as! CellTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        //cell?.textLabel?.text = "1234"
        cell.volumeSlider.tag = indexPath.row
        cell.volumeSlider.addTarget(self, action:#selector(sliderValueChange(sender:)), for: .valueChanged)
        cell.droneNoteAndMuteButton.tag = indexPath.row
        cell.droneNoteAndMuteButton.reference = cell.droneNoteAndMuteButton
        cell.droneNoteAndMuteButton.addTarget(self, action:#selector(droneButtonPress(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func sliderValueChange(sender: UISlider) {
        // Get the sliders values
        let buttonRow = sender.tag
        if toggleButtons[buttonRow] == nil{
            toggleButtons[buttonRow] = (true, 0.0)
        }
        
        let sliderRow = sender.tag
        if toggleButtons[sliderRow]?.0 == true {
            volumeFloats[sliderRow] = sender.value
            audioPlayer.changeVolume(note: sliderRow, volume: sender.value)
        }
        else{
            toggleButtons[sliderRow] = (false, sender.value)
        }
    }
    
    func droneButtonPress(sender: DroneNoteAndMuteButton) {
        // toggle button
        let buttonRow = sender.tag
        if toggleButtons[buttonRow] == nil{
            toggleButtons[buttonRow] = (true, 0.0)
        }
        
        if toggleButtons[buttonRow]?.0 == true {
            //change to false
            sender.reference.backgroundColor = UIColor.clear
            sender.reference.setTitleColor(UIColor(red:0.00, green:0.33, blue:0.58, alpha:1.0), for: .normal)
            toggleButtons[buttonRow] = (false, volumeFloats[buttonRow])
            audioPlayer.changeVolume(note: buttonRow, volume: 0.0)
            volumeFloats[buttonRow] = 0.0
        }
        else {
            sender.reference.backgroundColor = UIColor(red:0.00, green:0.33, blue:0.58, alpha:1.0)
            sender.reference.setTitleColor(UIColor.white, for: .normal)
            volumeFloats[buttonRow] = (toggleButtons[buttonRow]?.1)!
            audioPlayer.changeVolume(note: buttonRow, volume: (toggleButtons[buttonRow]?.1)!)
            toggleButtons[buttonRow] = (true, volumeFloats[buttonRow])
        }
    }
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        audioPlayer.togglePlay(chord: enterChord())
        for i in 0...numNotesInChord - 1 {
            audioPlayer.changeVolume(note: i, volume: volumeFloats[i])
        }
    }
    
    
//----------------------------------------------------------------------------------------------------------
// Popup Selectors controlls
//----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var chordButton: UIButton!
    @IBOutlet weak var scaleLabel: UILabel!
    
    @IBAction func chordPopUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "chordPopUp", sender: self)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
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
    }
    
    
//----------------------------------------------------------------------------------------------------------
// Overriden Functions
//----------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playPauseRefrence: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeFloats = Array(repeating: 0.5, count: numNotesInChord)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        self.view.insertSubview(backgroundImage, at: 0)
        
        DroneTableView.dataSource = self
        DroneTableView.backgroundColor = UIColor.clear
        DroneTableView.alwaysBounceVertical = false
        DroneTableView.isScrollEnabled = false
        DroneTableView.allowsSelection = false
        
        DispatchQueue.main.async {
            //This code will run in the main thread:
            var frame = self.DroneTableView.frame
            frame.size.height = self.DroneTableView.contentSize.height
            self.DroneTableView.frame = frame
            };
        
        view.addSubview(scrollView)
        view.bringSubview(toFront: playPauseRefrence)
        
        audioPlayer = AudioPlayer(numNotes: numNotesInChord)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        let height = (self.view.frame.height + self.DroneTableView.contentSize.height) - 180
        if height >= self.view.frame.height {
            scrollView.contentSize = CGSize(width:self.view.frame.width, height: height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
