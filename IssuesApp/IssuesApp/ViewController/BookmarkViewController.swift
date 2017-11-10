//
//  BookmarkViewController.swift
//  IssuesApp
//
//  Created by david on 2017. 11. 10..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    //질문: 왜 튜플일까?
    let datasource: [(owner: String, repo: String)] = GlobalState.instance.repos
    var selectedRepo: (owner: String, repo: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        let data = datasource[indexPath.row]
        cell.textLabel?.text = "/\(data.owner)/\(data.repo)"
        return cell
    }
}

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datasource[indexPath.row]
        selectedRepo = data
        self.performSegue(withIdentifier: "unwindToIssue", sender: self)
    }
}
