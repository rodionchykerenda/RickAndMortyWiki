//
//  ViewController+Spinner.swift
//  RickAndMortyWiki
//
//  Created by Rodion Chikerenda on 19.01.2021.
//

import UIKit

fileprivate var loadingView: UIView?

extension UIViewController {
    
    func showSpinner() {
        loadingView = UIView(frame: self.view.bounds)
        loadingView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.white
        spinner.center = loadingView!.center
        spinner.startAnimating()
        loadingView?.addSubview(spinner)
        self.view.addSubview(loadingView!)
    }
    
    func removeSpinner() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
