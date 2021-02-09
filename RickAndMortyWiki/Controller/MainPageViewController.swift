//
//  MainPageViewController.swift
//  RickAndMortyWiki
//
//  Created by Rodion Chikerenda on 18.12.2020.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    var dataSource = [Character]() {
        didSet {
            contentCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
        contentCollectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        styleUI()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: contentCollectionView)
        }
        // Do any additional setup after loading the view.
    }
    
    func styleUI() {
        let width = view.frame.size.width / 2 - 20
        let layout = contentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        dataSource = DataManager.instance.getCharacters()
        layout.itemSize = CGSize(width: width, height: width)
        addNavBarImage()
        let img = #imageLiteral(resourceName: "jpg2pdf")
        navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func addNavBarImage() {
        
        let navController = navigationController
        
        let image = UIImage(named: "RickAndMortyLogo")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController?.navigationBar.frame.size.width
        let bannerHeight = navController?.navigationBar.frame.size.height
        
        let bannerX = bannerWidth! - image!.size.width
        let bannerY = bannerHeight! - image!.size.height
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth!, height: bannerHeight!)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    func loadMoreData() {
        let networkManager = NetworkManager()
        networkManager.mainPageDelegate = self
        networkManager.getCharacters(page: DataManager.instance.getPagesNumber(), isInitial: false)
    }
}

// MARK: -  CollectionView Methods
extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell else {
            fatalError("Unable to dequeue CharacterCell")
        }
        cell.update(character: dataSource[indexPath.row])
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("U tapped me at \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = contentCollectionView.numberOfItems(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
//            let loadingView = UIView()
//            loadingView.center = view.center
//            loadingView
//            let width = view.bounds.width / 4
//            indicatorView = UIView(frame: CGRect(x: view.bounds.midX - (width / 2), y: view.bounds.midY - (width / 2), width: width, height: width))
//            let spinner = UIActivityIndicatorView(style: .large)
//            spinner.color = UIColor.white
//            spinner.startAnimating()
//            indicatorView?.backgroundColor = UIColor.black
//            indicatorView?.alpha = 0.5
//            indicatorView?.layer.cornerRadius = 20
//            indicatorView?.addSubview(spinner)
//            view.addSubview(indicatorView!)
            self.showSpinner()
            loadMoreData()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}

// MARK: -  Loading Data Delegate Methods
extension MainPageViewController: MainPageDelegate {
    func didFinishDownloadingCharacters(array: [Character]) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (t) in
            self.dataSource.append(contentsOf: array)
            self.removeSpinner()
        }
        DataManager.instance.increasePagesNumber()
    }
}

// MARK: -  3D Touch Delegate Methods
extension MainPageViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let selectedIndexPath = contentCollectionView.indexPathForItem(at: location) else {return nil}
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "PreviewCellViewController")
        destVC.preferredContentSize = CGSize.init(width: view.frame.width, height: view.frame.width)
        let peekedData = dataSource[selectedIndexPath.row]
        (destVC as? PreviewCellViewController)?.selectedCharacter = peekedData
        //navigationController?.pushViewController(destVC, animated: true)
        return destVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
    
    
}
