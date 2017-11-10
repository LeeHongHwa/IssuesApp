//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by david on 2017. 11. 10..
//  Copyright © 2017년 lyhonghwa. All rights reserved.
//

import UIKit

@IBDesignable
class LoadMoreFooterView: UICollectionReusableView {
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var doneView: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    //질문: main번들과의차이는 ?
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadMoreFooterView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return UIView() }
        return view
    }
    
    fileprivate func setupNib() {
        let view = self.loadNib()
        self.addSubview(view)
        //질문: 이거 하는 이유는?
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        //질문: 이 메서드는?
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
}

//변경하기: extension으로 코드분리
extension LoadMoreFooterView {
    func loadDone() {
        activityIndicatorView.isHidden = true
        doneView.isHidden = false
    }
    
    func load() {
        activityIndicatorView.isHidden = false
        doneView.isHidden = true
    }
}
