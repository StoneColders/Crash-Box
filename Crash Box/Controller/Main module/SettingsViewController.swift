//
//  SettingsViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - IBOutlets
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var logoutButtonOutlet: UIButton!

    //MARK: - Main function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupImageView()
        viewSetup()
    }
    
    //MARK: - Functions
    func setupImageView(){
        profileImgView.layer.cornerRadius = profileImgView.frame.width / 2
        profileImgView.layer.masksToBounds = false
    }
    
    func viewSetup() {
        let UserDetails = UserDefaults.standard.object(forKey: UserObjKey) as! [String:String]
        let name = UserDetails["name"]!
        nameLabelOutlet.text = name
    }
    
    //MARK: - IBActions
    @IBAction func logoutTapped(_ sender: UIButton) {
        let UserDetails = UserDefaults.standard.object(forKey: UserObjKey) as! [String:String]
        let email = UserDetails["email"]!
        let pass = UserDetails["pass"]!
        
        let userObj = User(email, pass)
        userObj.logout { (stat) in
            if stat == "removed"{
                guard let loginVc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                    fatalError("Couldnt init login Vc")
                }
                self.appDelegate.window?.rootViewController = loginVc
            } else {
                let alert = UIAlertController(title: "Alert", message: "Not able to logout, check internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
