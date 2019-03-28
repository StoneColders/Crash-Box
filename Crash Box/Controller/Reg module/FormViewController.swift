//
//  FormViewController.swift
//  Crash Box
//
//  Created by Sarvad shetty on 3/28/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameTextfield: TextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textfieldDelegateSetup()
        textfieldSetup()
    }
}

//MARK: - Extension
extension FormViewController: UITextFieldDelegate{
    
    func textfieldDelegateSetup(){
        nameTextfield.delegate = self
    }
    
    func textfieldSetup(){
        //for name
        nameTextfield.tintColor = UIColor.init(255, 255, 255, 1)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
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
    }
}
