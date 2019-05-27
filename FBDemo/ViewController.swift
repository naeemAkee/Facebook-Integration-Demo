//
//  ViewController.swift
//  FBDemo
//
//  Created by MNA Developer on 25/05/2019.
//  Copyright © 2019 Naeem. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Kingfisher

class ViewController: UIViewController, LoginButtonDelegate {
    
    
    @IBOutlet weak var abc: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    
    @IBAction func loginFBButton(_ sender: UIButton) {
        let loginManager : LoginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            
            if (error == nil){
                let fbLoginResult: LoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil{
                    if fbLoginResult.grantedPermissions.contains("email"){
                        self.getFBUserData()
                        loginManager.logOut()
                        self.loginButton.setTitle("LogOut", for: .normal)
                    }
                }
            }
        }
    }
    
    
    func getFBUserData(){
        if AccessToken.current != nil{
            GraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start { (connect, result, error) in
                
                if error == nil {
                    let faceDic = result as! [String: AnyObject]
                    print(faceDic)
                    let email = faceDic["emai"] as? String
                    let name = faceDic["name"] as! String
                    self.abc.text = name
                    
                    if let img = faceDic["picture"] as? NSDictionary,  let data = img["data"] as? NSDictionary,  let url = data["url"] as? String{
                        let url = URL(string: "\(url)")
                        self.myImage.kf.indicatorType = .activity
                        self.myImage.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(9))], progressBlock: nil)
                    }
                }
            }
        }
    }
    
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
}

