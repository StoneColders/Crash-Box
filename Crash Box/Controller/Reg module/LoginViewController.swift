//
//  LoginViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/12/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextfield: TextField2!
    @IBOutlet weak var passwordTextfiled: TextField2!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    //MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSetup()        
    }
    
    //MARK: - Functions
    func viewSetup() {
        textfieldDelegateSetup()
        buttonSetup()
    }
    
    func buttonSetup() {
        loginButtonOutlet.layer.masksToBounds = false
        loginButtonOutlet.layer.cornerRadius = 3
        
        signUpButtonOutlet.layer.masksToBounds = false
        signUpButtonOutlet.layer.cornerRadius = 3
    }
    
    func goToApp(){
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController else{
            fatalError("couldnt init")
        }
        //persist state in userdefaults
//        UserDefaults.standard.set(true, forKey: "KFIRSTSTATE")
        self.appDelegate.window?.rootViewController = vc
    }

    
    //MARK: - IBActions
    @IBAction func loginTapped(_ sender: UIButton) {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading.."
        hud.show(in: self.view)
        
        if emailTextfield.text != ""  && passwordTextfiled.text != "" {
            let userObj = User(emailTextfield.text!, passwordTextfiled.text!)
            userObj.login { (stat) in
                if stat == "created" {
                    hud.dismiss(animated: true)
                    self.goToApp()
                } else {
                    hud.dismiss(animated: true)
                }
            }
        } else {
            hud.dismiss(animated: true)
            let alert = UIAlertController(title: "Notice", message: "Fill in all details*", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let formVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else{
            fatalError("couldnt init form vc")
        }
        self.present(formVC, animated: true, completion: nil)
    }
}

//MARK: - Extension
extension LoginViewController: UITextFieldDelegate {
    
    func textfieldDelegateSetup() {
        emailTextfield.delegate = self
        passwordTextfiled.delegate = self
        txtFieldSetup()
        observeNotification()
    }
    
    func txtFieldSetup() {
        //email
        emailTextfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        emailTextfield.textColor = UIColor.init(255, 255, 255, 1.0)
        emailTextfield.attributedPlaceholder = NSAttributedString(string: "ENTER EMAIL", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        emailTextfield.layer.cornerRadius = 3
        emailTextfield.layer.masksToBounds = false
        emailTextfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        emailTextfield.layer.shadowRadius = 7
        emailTextfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        emailTextfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        emailTextfield.layer.shadowOpacity = 1.0
        //border
        emailTextfield.layer.borderWidth = 1
        emailTextfield.layer.borderColor = #colorLiteral(red: 0.928627193, green: 0.2251094282, blue: 0.2785183191, alpha: 1)
        
        //password
        passwordTextfiled.tintColor = UIColor.init(255, 255, 255, 1.0)
        passwordTextfiled.textColor = UIColor.init(255, 255, 255, 1.0)
        passwordTextfiled.attributedPlaceholder = NSAttributedString(string: "ENTER PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        passwordTextfiled.layer.cornerRadius = 3
        passwordTextfiled.layer.masksToBounds = false
        passwordTextfiled.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        passwordTextfiled.layer.shadowRadius = 7
        passwordTextfiled.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        passwordTextfiled.layer.shadowOffset = CGSize(width: 0, height: 1)
        passwordTextfiled.layer.shadowOpacity = 1.0
        //border
        passwordTextfiled.layer.borderWidth = 1
        passwordTextfiled.layer.borderColor = #colorLiteral(red: 0.928627193, green: 0.2251094282, blue: 0.2785183191, alpha: 1)

    }
    
    //MARK: - Textfield notification properties
    func observeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -130, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    @objc func keyboardWillHide(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            emailTextfield.resignFirstResponder()
            passwordTextfiled.becomeFirstResponder()
        } else if textField == passwordTextfiled {
            passwordTextfiled.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
