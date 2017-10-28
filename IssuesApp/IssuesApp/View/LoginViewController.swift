//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by david on 2017. 10. 28..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {

    let oauth: OAuth2Swift = OAuth2Swift(
        consumerKey: "938c5fed73526a812bfe",
        consumerSecret: "01775ddc3e6f70f967b82c2663f8d50bb634e808",
        authorizeUrl: "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType: "code")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginToGitHubButtonDidTab(_ sender: Any) {
        oauth.authorize(withCallbackURL: "issuesapp://oauth_callback/github",
                        scope: "user,repo",
                        state: "state",
                        success: { (credential, _, _) in
                            let token = credential.oauthToken
                            print("token: \(token)")
        },
                        failure: {error in
                            print(error.localizedDescription)
        })
    }
    

}
