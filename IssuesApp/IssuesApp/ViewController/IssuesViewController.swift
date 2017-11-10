//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by david on 2017. 11. 10..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit
import Alamofire

protocol DataSourceRefreshable: class {
    associatedtype Item
    var dataSource: [Item] { get set }
    var needRefreshDataSource: Bool { get set }
}

extension DataSourceRefreshable {
    func setNeedRefreshDataSource() {
        needRefreshDataSource = true
    }
    func refreshDataSourceIfNeeded() {
        if needRefreshDataSource {
            dataSource = []
            needRefreshDataSource = false
        }
    }
}

class IssuesViewController: UIViewController, DataSourceRefreshable {
    //view
    var needRefreshDataSource: Bool = false
    @IBOutlet var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    var loadMoreFooterView: LoadMoreFooterView?
    
    //model
    let owner: String = GlobalState.instance.owner
    let repo: String = GlobalState.instance.repo
    var dataSource: [Model.Issue] = []
    lazy var targetSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    
    //paging
    var page: Int  = 1
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension IssuesViewController {
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "IssueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IssueCollectionViewCell")
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 375, height: 100)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        load()
    }
    
    func load() {
        guard isLoading == false else { return }
        isLoading = true
        App.api.repoIssues(owner: owner, repo: repo, page: page) { [weak self] (dataResponse: DataResponse<[Model.Issue]>) in
            guard let `self` = self else { return }
            switch dataResponse.result {
                
            case .success(let items):
                
                self.dataLoaded(items: items)
                self.isLoading = false
            case .failure:
                self.isLoading = false
                break
            }
            
        }
    }
    func dataLoaded(items: [Model.Issue]) {
        //처음은 refresh할 필요가 없다. refresh 한다면 데이터를 없앤다
        refreshDataSourceIfNeeded()
        refreshControl.endRefreshing()
        //다음페이지를 위한 값세팅
        page += 1
        
        guard !items.isEmpty else {
            canLoadMore = false
            loadMoreFooterView?.loadDone()
            return
        }
        dataSource.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    func refresh() {
        page = 1
        canLoadMore = true
        loadMoreFooterView?.load()
        setNeedRefreshDataSource()
        load()
    }
    
    func loadMore(indexPath: IndexPath) {
        guard page != 1 && indexPath.item == dataSource.count - 1  && !isLoading && canLoadMore else { return }
        load()
        
    }
}

extension IssuesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCollectionViewCell", for: indexPath) as? IssueCollectionViewCell else { return IssueCollectionViewCell() }
        let data = dataSource[indexPath.item]
        cell.update(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            assert(false, "unexpected element Kind")
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooterView", for: indexPath) as? LoadMoreFooterView ?? LoadMoreFooterView()
            loadMoreFooterView = footer
            return footer
        default:
            assert(false, "unexpected element Kind")
            return UICollectionReusableView()
        }
    }
}

extension IssuesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
}
