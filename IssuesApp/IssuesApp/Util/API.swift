//
//  API.swift
//  IssuesApp
//
//  Created by david on 2017. 10. 28..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import Foundation
import OAuthSwift

protocol API {
    func getToken(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
}


struct GitHubAPI: API {
    
    let oauth: OAuth2Swift = OAuth2Swift(
        consumerKey: "938c5fed73526a812bfe",
        consumerSecret: "01775ddc3e6f70f967b82c2663f8d50bb634e808",
        authorizeUrl: "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType: "code")
    
    func getToken(handler: @escaping (() -> Void)) {
        oauth.authorize(withCallbackURL: "issuesapp://oauth_callback/github",
                        scope: "user,repo",
                        state: "state",
                        success: { (credential, _, _) in
                            let token = credential.oauthToken
                            let refreshToken = credential.oauthRefreshToken
                            print("token: \(token)")
                            GlobalState.instance.token = token
                            GlobalState.instance.refreshToken = refreshToken
                            handler()
        },
                        failure: {error in
                            print(error.localizedDescription)
        })
    }
    
    func tokenRefresh(handler: @escaping (() -> Void)) {
        guard let refreshToken = GlobalState.instance.refreshToken else { return }
        oauth.renewAccessToken(withRefreshToken: refreshToken
            , success: { (credential, _, _) in
                let token = credential.oauthToken
                let refreshToken = credential.oauthRefreshToken
                print("token: \(token)")
                GlobalState.instance.token = token
                GlobalState.instance.refreshToken = refreshToken
                handler()
        },
              failure: {error in
                print(error.localizedDescription)
        })
    }
    
}
