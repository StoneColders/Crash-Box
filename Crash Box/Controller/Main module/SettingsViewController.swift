//
//  SettingsViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/29/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var profileImgView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupImageView()
    }
    
    //MARK: - Function
    func setupImageView(){
        profileImgView.layer.cornerRadius = profileImgView.frame.width / 2
        profileImgView.layer.masksToBounds = false
    }
    
    
    //MARK: - IBActions
    @IBAction func aboutUsTapped(_ sender: UIButton) {
    }
    
    @IBAction func faqTapped(_ sender: UIButton) {
    }
    
    @IBAction func tcTapped(_ sender: UIButton) {
    }
    
}
