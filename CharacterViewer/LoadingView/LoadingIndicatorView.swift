//
//  LoadingIndicatorView.swift
//  Simpsonsviewer
//
//  Created by Jagruti Patel CW on 6/15/23.
//

import UIKit

class LoadingIndicatorView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func showSpinner(_ view: UIView) {
        hideSpinner()
        
        loadingIndicator.frame = self.frame
        self.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        self.frame = view.frame       
        view.addSubview(self)
    }
    
    func hideSpinner() {
        self.removeFromSuperview()
        loadingIndicator.removeFromSuperview()
        loadingIndicator.stopAnimating()
    }
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        var activityVC = UIActivityIndicatorView(style: .large)
        activityVC.startAnimating()
        return activityVC
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
