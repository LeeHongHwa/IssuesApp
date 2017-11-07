//
//  Model.swift
//  IssuesApp
//
//  Created by david on 2017. 11. 4..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Model {
    
}
//각 역할에 맞게 extension으로 만듬
extension Model {
    struct Issue {
        let id: Int
        let number: Int
        let title: String
        let user: Model.User
        let state: State
        let comments: Int
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        let closedAt: Date?
        
        init(json: JSON) {
            print("issue json: \(json)")
            id = json["id"].intValue
            number = json["number"].intValue
            title = json["title"].stringValue
            user = Model.User(json: json["user"])
            state = State(rawValue: json["state"].stringValue) ?? .open
            comments = json["comments"].intValue
            body = json["body"].stringValue
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
            closedAt = format.date(from: json["closed_at"].stringValue)
        }
    }
}

//enum을 위에 정의하기 싫어서 여기서 정의
extension Model.Issue {
    enum State: String {
        case open
        case closed
    }
}

extension Model {
    struct User {
        let id: String
        let login: String
        let avatarURL: URL?
        
        init(json: JSON) {
            id = json["id"].stringValue
            login = json["login"].stringValue
            avatarURL = URL(string: json["avatar_url"].stringValue)
        }
    }
}
