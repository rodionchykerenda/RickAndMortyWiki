//
//  LaunchScreenViewController.swift
//  RickAndMortyWiki
//
//  Created by Rodion Chikerenda on 18.12.2020.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        imageView.image = #imageLiteral(resourceName: "rick-and-morty-portal-shoes-white-clothing-zavvi-23")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let networkManager = NetworkManager()
        networkManager.launchScreenDelegate = self
        networkManager.getCharacters(page: 1)
    }
    
    private func animate() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffX / 2),
                                          y: diffY / 2,
                                          width: size,
                                          height: size)
        }
        
        UIView.animate(withDuration: 1,animations:  {
            self.imageView.alpha = 0
        }) { (done) in
            if done {
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationVC = storyboard.instantiateViewController(identifier: "MainPageViewController") as! MainPageViewController
                let navigationController = UINavigationController(rootViewController: destinationVC)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .crossDissolve
                //destinationVC.dataSource = DataManager.instance.getCharacters()
                
                self.present(navigationController, animated: true)
                //})
            }
        }
    }
}

// MARK: -  Delegate Methods
extension LaunchScreenViewController: LaunchScreenDelegate {
    func didFinishDownloadingCharacters(array: [Character]) {
        DataManager.instance.setCharactersArray(with: array)
        animate()
    }
}
