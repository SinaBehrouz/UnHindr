//
//  HomeScreenViewController.swift
//  UnHindr
//
//  Created by ata87 on 10/31/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeScreenViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func WellnessTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "WellnessTestHome", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WellnessTestHomeViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func optionsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func profileTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func medicationTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Medication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainTabController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
}
