//
//  RepoViewController.swift
//  IssuesApp
//
//  Created by david on 2017. 11. 4..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    @IBOutlet var ownerTextField: UITextField!
    @IBOutlet var repoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerTextField.text = GlobalState.instance.owner
        repoTextField.text = GlobalState.instance.repo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //질문: 이동을 할까요?
    //질문: API 문서보기 sender는 뭐가 올까?
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "EnterRepoSegue" {
            //변경하기: 띄어쓰기에 대한 예외처리 넣기
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return false }
            return !(owner.isEmpty || repo.isEmpty)
        }
        return true
    }
    
    //질문: 이동합니다요
    //질문: API 문서보기 sender는 뭐가 올까?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterRepoSegue" {
            //변경하기: 두번 검사할필요는 없을텐데 위에서 처리하자
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return }
            GlobalState.instance.owner = owner
            GlobalState.instance.repo = repo
            GlobalState.instance.addRepo(owner: owner, repo: repo)
        }
    }
    
    
}

extension RepoViewController {
    @IBAction func logoutButtonTapped(_ sender: Any) {
        //토큰 초기화 및 로그인 이동
        GlobalState.instance.token = ""
        let loginViewController = LoginViewController.viewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0 ) { [weak self] in
            self?.present(loginViewController, animated: true, completion: nil)
        }
    }
    //unwindFromRepos란? unwind 뜻 되돌리다
    @IBAction func unwindFromRepos(_ segue: UIStoryboardSegue) {
        guard let BookmarkViewController = segue.source as? BookmarkViewController else { return }
        //까서 쓰는게 불편해서 이렇게 튜플로 받아왔나보다
        guard let (owner, repo) = BookmarkViewController.selectedRepo else { return }
        ownerTextField.text = owner
        repoTextField.text = repo
        DispatchQueue.main.async { [weak self] in
            //Identifier 이름도 변경이 필요할것 같다 EnterIssuesSegue
            self?.performSegue(withIdentifier: "EnterRepoSegue", sender: nil)
        }
    }
}
