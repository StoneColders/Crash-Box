//
//  LottieViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/13/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class LottieViewController: UIViewController {

    //NARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - IBOutlets
    @IBOutlet weak var animationView: LOTAnimationView!

    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    func setup(){
        animationView.setAnimation(named: "crash box")
        
        print(animationView.animationDuration)
        animationView.play(toProgress: 0.2) { (_) in
            self.observeAuthorisedState()
        }
    }
    
    func goToForm(){
        guard let formVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
            fatalError("couldnt init form vc")
        }
        //making root view controller
        self.appDelegate.window?.rootViewController = formVC
    }
    
    func goToApp(){
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController else{
            fatalError("couldnt init")
        }
        self.appDelegate.window?.rootViewController = vc
    }
    
    private func observeAuthorisedState() {
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user == nil {
//                self.goToForm()
//            } else {
//                self.goToApp()
//            }
//        }
        
        if UserDefaults.standard.object(forKey: UserObjKey) != nil {
            self.goToApp()
        } else {
            self.goToForm()
        }
    }
}
