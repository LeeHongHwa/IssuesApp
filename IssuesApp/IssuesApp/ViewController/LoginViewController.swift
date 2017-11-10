//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by david on 2017. 10. 28..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    static var viewController: LoginViewController {
        guard let viewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return LoginViewController() }
        return viewContoller
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginToGitHubButtonTapped() {
        App.api.getToken { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
