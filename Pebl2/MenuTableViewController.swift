//
//  MenuTableViewController.swift
//  Pebl
//
//  Created by Nick Florin on 10/16/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    ////////////////////////////////////////////////
    // Mark: Properties
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var indexDelegation : [Int:String] = [0:"home",1:"edit_profile",2:"settings",3:"about",4:"logout"]
    ////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    ////////////////////////////////////////////////
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    ////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    ////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSelected = indexPath.row as Int
        let keyExists = self.indexDelegation[rowSelected] != nil
        if keyExists {
            let pageSelected = self.indexDelegation[rowSelected]
            let baseVC = self.parent as? BaseViewController
            if pageSelected == "home"{
                baseVC?.gotoHome()
            }
            else if pageSelected == "edit_profile"{
                baseVC?.gotoEditProfile()
            }
            else if pageSelected == "settings"{
                baseVC?.gotoSettings()
            }
            else if pageSelected == "about"{
                baseVC?.gotoAbout()
            }
            else if pageSelected == "logout"{
                baseVC?.logout()
            }
        }

    }

}
