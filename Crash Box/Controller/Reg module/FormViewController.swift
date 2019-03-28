//
//  FormViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Firebase

class FormViewController: UIViewController {
    
    //MARK: - Variables
    var nameText:String!
    var bloodGroup:String!
    var contact1Text:String!
    var contact2Text:String!
    var contact3Text:String!
    //db part
    var ref: DatabaseReference!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameTextfield: TextField!
    @IBOutlet weak var bloodGroupTextfield: TextField!
    @IBOutlet weak var contact1Textfield: TextField!
    @IBOutlet weak var contact2Textfield: TextField!
    @IBOutlet weak var contact3Textfield: TextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    //MARK: - Main function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textfieldDelegateSetup()
        textfieldSetup()
        observeNotification()
        buttonSetup()
    }
    
    //MARK: - IBAction
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("send button pressed")
        if nameTextfield.text == "" && bloodGroupTextfield.text == "" && contact1Textfield.text == "" && contact2Textfield.text == "" && contact3Textfield.text == ""{
            let alert = UIAlertController(title: "Notice", message: "Please fill in all your fields!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            nameText = nameTextfield.text!
            bloodGroup = bloodGroupTextfield.text!
            contact1Text = contact1Textfield.text!
            contact2Text = contact2Textfield.text!
            contact3Text = contact3Textfield.text!
            //save to db
            self.save(cn1: contact1Text, cn2: contact2Text, cn3: contact3Text) { (val) in
                if val == "done"{
                    self.goToApp()
                }
            }
        }
    }
    
    //MARK: - Function
    func buttonSetup(){
        submitButtonOutlet.layer.cornerRadius = 3
        submitButtonOutlet.layer.masksToBounds = false
    }
    
    func save(cn1:String,cn2:String,cn3:String,done:@escaping(_ stat:String)->Void){
        ref = Database.database().reference().child("numbers")
        ref.setValue([cn1:false,cn2:false,cn3:false])
        done("done")
    }
    
    func goToApp(){
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController else{
            fatalError("couldnt init")
        }
        //persist state in userdefaults
        UserDefaults.standard.set(true, forKey: "KFIRSTSTATE")
        self.appDelegate.window?.rootViewController = vc
    }
}

//MARK: - Extension
extension FormViewController: UITextFieldDelegate{
    
    func textfieldDelegateSetup(){
        nameTextfield.delegate = self
        bloodGroupTextfield.delegate = self
        contact1Textfield.delegate = self
        contact2Textfield.delegate = self
        contact3Textfield.delegate = self
    }
    
    func textfieldSetup(){
        //for name
        nameTextfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        nameTextfield.textColor = UIColor.init(255, 255, 255, 1.0)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profs")
        imageView.image = image
        //name line
        let lineView = UIView(frame: CGRect(x: imageView.frame.width + 20, y: 0, width: 0.5, height: nameTextfield.frame.height))
        lineView.backgroundColor = UIColor.init(8, 21, 37, 1)
        nameTextfield.addSubview(lineView)
        NSLayoutConstraint.activate([lineView.centerXAnchor.constraint(equalTo: nameTextfield.centerXAnchor)])
        nameTextfield.leftView = imageView
        nameTextfield.leftViewMode = .always
        nameTextfield.layoutIfNeeded()
        //to move image 10 pts
        nameTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        nameTextfield.attributedPlaceholder = NSAttributedString(string: "ENTER NAME", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        nameTextfield.layer.cornerRadius = 3
        nameTextfield.layer.masksToBounds = false
        nameTextfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        nameTextfield.layer.shadowRadius = 7
        nameTextfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        nameTextfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        nameTextfield.layer.shadowOpacity = 1.0
        
        //blood group
        bloodGroupTextfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        bloodGroupTextfield.textColor = UIColor.init(255, 255, 255, 1.0)
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView2.contentMode = .scaleAspectFit
        let image2 = UIImage(named: "form1")
        imageView2.image = image2
        //name line
        let lineView2 = UIView(frame: CGRect(x: imageView2.frame.width + 20, y: 0, width: 0.5, height: bloodGroupTextfield.frame.height))
        lineView2.backgroundColor = UIColor.init(8, 21, 37, 1)
        bloodGroupTextfield.addSubview(lineView2)
        NSLayoutConstraint.activate([lineView2.centerXAnchor.constraint(equalTo: bloodGroupTextfield.centerXAnchor)])
        bloodGroupTextfield.leftView = imageView2
        bloodGroupTextfield.leftViewMode = .always
        bloodGroupTextfield.layoutIfNeeded()
        //to move image 10 pts
        bloodGroupTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        bloodGroupTextfield.attributedPlaceholder = NSAttributedString(string: "ENTER BLOOD GROUP", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        bloodGroupTextfield.layer.cornerRadius = 3
        bloodGroupTextfield.layer.masksToBounds = false
        bloodGroupTextfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        bloodGroupTextfield.layer.shadowRadius = 7
        bloodGroupTextfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        bloodGroupTextfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        bloodGroupTextfield.layer.shadowOpacity = 1.0
        
        //contact1
        contact1Textfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        contact1Textfield.textColor = UIColor.init(255, 255, 255, 1.0)
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView3.contentMode = .scaleAspectFit
        let image3 = UIImage(named: "form2")
        imageView3.image = image3
        //name line
        let lineView3 = UIView(frame: CGRect(x: imageView3.frame.width + 20, y: 0, width: 0.5, height: contact1Textfield.frame.height))
        lineView3.backgroundColor = UIColor.init(8, 21, 37, 1)
        contact1Textfield.addSubview(lineView3)
        NSLayoutConstraint.activate([lineView3.centerXAnchor.constraint(equalTo: contact1Textfield.centerXAnchor)])
        contact1Textfield.leftView = imageView3
        contact1Textfield.leftViewMode = .always
        contact1Textfield.layoutIfNeeded()
        //to move image 10 pts
        contact1Textfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        contact1Textfield.attributedPlaceholder = NSAttributedString(string: "EMERGENCY CONTACT 1", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        contact1Textfield.layer.cornerRadius = 3
        contact1Textfield.layer.masksToBounds = false
        contact1Textfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        contact1Textfield.layer.shadowRadius = 7
        contact1Textfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        contact1Textfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        contact1Textfield.layer.shadowOpacity = 1.0
        
        //contact2
        contact2Textfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        contact2Textfield.textColor = UIColor.init(255, 255, 255, 1.0)
        let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView4.contentMode = .scaleAspectFill
        let image4 = UIImage(named: "form3")
        imageView4.image = image4
        //name line
        let lineView4 = UIView(frame: CGRect(x: imageView4.frame.width + 20, y: 0, width: 0.5, height: contact2Textfield.frame.height))
        lineView4.backgroundColor = UIColor.init(8, 21, 37, 1)
        contact2Textfield.addSubview(lineView4)
        NSLayoutConstraint.activate([lineView4.centerXAnchor.constraint(equalTo: contact2Textfield.centerXAnchor)])
        contact2Textfield.leftView = imageView4
        contact2Textfield.leftViewMode = .always
        contact2Textfield.layoutIfNeeded()
        //to move image 10 pts
        contact2Textfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        contact2Textfield.attributedPlaceholder = NSAttributedString(string: "EMERGENCY CONTACT 2", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        contact2Textfield.layer.cornerRadius = 3
        contact2Textfield.layer.masksToBounds = false
        contact2Textfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        contact2Textfield.layer.shadowRadius = 7
        contact2Textfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        contact2Textfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        contact2Textfield.layer.shadowOpacity = 1.0
        
        //contact3
        contact3Textfield.tintColor = UIColor.init(255, 255, 255, 1.0)
        contact3Textfield.textColor = UIColor.init(255, 255, 255, 1.0)
        let imageView5 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView5.contentMode = .scaleAspectFit
        let image5 = UIImage(named: "form4")
        imageView5.image = image5
        //name line
        let lineView5 = UIView(frame: CGRect(x: imageView5.frame.width + 20, y: 0, width: 0.5, height: contact3Textfield.frame.height))
        lineView5.backgroundColor = UIColor.init(8, 21, 37, 1)
        contact3Textfield.addSubview(lineView5)
        NSLayoutConstraint.activate([lineView5.centerXAnchor.constraint(equalTo: contact3Textfield.centerXAnchor)])
        contact3Textfield.leftView = imageView5
        contact3Textfield.leftViewMode = .always
        contact3Textfield.layoutIfNeeded()
        //to move image 10 pts
        contact3Textfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        contact3Textfield.attributedPlaceholder = NSAttributedString(string: "EMERGENCY CONTACT 3", attributes: [NSAttributedString.Key.foregroundColor:UIColor(255, 255, 255, 0.5)])
        //corner radius
        contact3Textfield.layer.cornerRadius = 3
        contact3Textfield.layer.masksToBounds = false
        contact3Textfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        //shadow
        contact3Textfield.layer.shadowRadius = 7
        contact3Textfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.07).cgColor
        contact3Textfield.layer.shadowOffset = CGSize(width: 0, height: 1)
        contact3Textfield.layer.shadowOpacity = 1.0
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
        if textField == nameTextfield{
            nameTextfield.resignFirstResponder()
            bloodGroupTextfield.becomeFirstResponder()
        }else if textField == bloodGroupTextfield{
            bloodGroupTextfield.resignFirstResponder()
            contact1Textfield.becomeFirstResponder()
        }else if textField == contact1Textfield{
            contact1Textfield.resignFirstResponder()
            contact2Textfield.becomeFirstResponder()
        }else if textField == contact2Textfield{
            contact2Textfield.resignFirstResponder()
            contact3Textfield.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func clearTextfields(){
        nameTextfield.text = ""
        bloodGroupTextfield.text = ""
        contact1Textfield.text = ""
        contact2Textfield.text = ""
        contact3Textfield.text = ""
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }

}
