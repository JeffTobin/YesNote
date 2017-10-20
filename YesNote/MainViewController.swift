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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DroneTableView.dequeueReusableCell(withIdentifier: "ChordToneReusableCell") as! CellTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        //cell?.textLabel?.text = "1234"
        cell.volumeSlider.tag = indexPath.row
        cell.volumeSlider.addTarget(self, action:#selector(sliderValueChange(sender:)), for: .valueChanged)
        
        return cell
    }
    
    func sliderValueChange(sender: UISlider) {
        // Get the sliders values
        //let currentValue = Int(sender.value)
        let sliderRow = sender.tag
        
        switch sliderRow {
        case 0:
            print("slider 1")
            break
        case 1:
            print("slider 2")
            break
        case 2:
            print("slider 3")
            break
        case 3:
            print("slider 4")
            break
        default:
            break
        }
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playPauseRefrence: UIButton!
    
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
        DroneTableView.isScrollEnabled = false;
        
        DispatchQueue.main.async {
            //This code will run in the main thread:
            var frame = self.DroneTableView.frame;
            frame.size.height = self.DroneTableView.contentSize.height;
            self.DroneTableView.frame = frame;
            };
        
        view.addSubview(scrollView)
        view.bringSubview(toFront: playPauseRefrence)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        let height = (self.view.frame.height + self.DroneTableView.contentSize.height) - 200
        if height > 667 {
            scrollView.contentSize = CGSize(width:self.view.frame.width, height: height)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
