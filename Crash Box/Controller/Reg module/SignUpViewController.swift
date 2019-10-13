//
//  SignUpViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/12/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextfield: TextField2!
    @IBOutlet weak var passwordTextfield: TextField2!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSetup()
    }
    
    //MARK: - Functions
    func viewSetup() {
        textFieldDelegateSetup()
        buttonSetup()
    }
    
    func buttonSetup() {
        registerButtonOutlet.layer.masksToBounds = false
        registerButtonOutlet.layer.cornerRadius = 3
    }
    
    //MARK: - IBActions
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading.."
        hud.show(in: self.view)
        
        //check if fields are not empty
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            guard let regVc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FormViewController") as? FormViewController else {
                fatalError("couldnt init vc")
            }
            regVc.emailValue = emailTextfield.text!
            regVc.passwordValue = passwordTextfield.text!
            hud.dismiss(animated: true)
            self.present(regVc, animated: true, completion: nil)
        } else {
            hud.dismiss(animated: true)
            let alert = UIAlertController(title: "Notice", message: "Fill in all the values *", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK: - Extenions
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDelegateSetup() {
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        textfieldSetup()
        observeNotification()
    }
    
    func textfieldSetup() {
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
        passwordTextfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        passwordTextfield.textColor = UIColor.init(255, 255, 255, 1.0)
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: "ENTER PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        passwordTextfield.layer.cornerRadius = 3
        passwordTextfield.layer.masksToBounds = false
        passwordTextfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        passwordTextfield.layer.shadowRadius = 7
        passwordTextfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        passwordTextfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        passwordTextfield.layer.shadowOpacity = 1.0
        //border
        passwordTextfield.layer.borderWidth = 1
        passwordTextfield.layer.borderColor = #colorLiteral(red: 0.928627193, green: 0.2251094282, blue: 0.2785183191, alpha: 1)
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
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            passwordTextfield.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
