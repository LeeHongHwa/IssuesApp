//
//  API.swift
//  IssuesApp
//
//  Created by david on 2017. 10. 28..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import Foundation

protocol API {
    func getToken(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssuesResponseHandler)
}
