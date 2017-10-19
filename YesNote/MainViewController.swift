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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DroneTableView.dequeueReusableCell(withIdentifier: "ChordToneReusableCell")
        
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.text = "1234"
        
        return cell!
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
            destinationVC.preferredContentSize = CGSize(width: 300, height: 300)
            
            if let PopUp = destinationVC.popoverPresentationController{
                PopUp.delegate = self
            }
        }
    }
    
    
//----------------------------------------------------------------------------------------------------------
// Overriden Functions
//----------------------------------------------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        self.view.insertSubview(backgroundImage, at: 0)
        
        DroneTableView.dataSource = self
        DroneTableView.backgroundColor = UIColor.clear
        DroneTableView.alwaysBounceVertical = false;
        
        DispatchQueue.main.async {
            //This code will run in the main thread:
            var frame = self.DroneTableView.frame;
            frame.size.height = self.DroneTableView.contentSize.height;
            self.DroneTableView.frame = frame;
            };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
