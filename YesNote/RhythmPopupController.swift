//
//  RhythmPopupController.swift
//  YesNote
//
//  Created by Jeff Tobin on 10/25/17.
//  Copyright © 2017 Elad. All rights reserved.
//

import UIKit

class RhythmPopupController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }

}
