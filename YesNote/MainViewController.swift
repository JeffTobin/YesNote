//
//  ViewController.swift
//  PickerExample
//
//  Created by Jeff Tobin on 10/13/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource {
    
//----------------------------------------------------------------------------------------------------------
// Drone Volume controlls
//----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var DroneTableView: UITableView!
    var numNotesInChord = 4
    var toggleButtons = [Int: (Bool, Float)]()
    var volumeFloats = [Float]()

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
        let sliderRow = sender.tag
        volumeFloats[sliderRow] = sender.value
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
            volumeFloats[buttonRow] = 0.0
        }
        else {
            sender.reference.backgroundColor = UIColor(red:0.00, green:0.33, blue:0.58, alpha:1.0)
            sender.reference.setTitleColor(UIColor.white, for: .normal)
            volumeFloats[buttonRow] = (toggleButtons[buttonRow]?.1)!
            toggleButtons[buttonRow] = (true, volumeFloats[buttonRow])
        }
    }
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        print(volumeFloats)
    }
    
    
//----------------------------------------------------------------------------------------------------------
// Popup Selectors controlls
//----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var chordButton: UIButton!
    
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
