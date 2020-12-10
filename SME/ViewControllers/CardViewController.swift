//
//  CardViewController.swift
//  Monsh2atTask
//
//  Created by Aya Essam on 12/1/20.
//  Copyright © 2020 Aya E Mahmoud. All rights reserved.
//

import UIKit
import PullToRefreshKit
import Windless
import Reachability
import ToastSwiftFramework

class CardViewController: UIViewController {

    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var imageMarkView: UIImageView!
    @IBOutlet private weak var bannerLabel: UILabel!
    
    var profiles = [Profiles]()
    var windelssCount = 10;
    
    let reachability = try! Reachability()
    
    var maximumBannerHeight: CGFloat = 219
    var minimumBannerHeight: CGFloat = 145
    
    lazy var presenter = CardPresenter(with: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        bannerLabel.font = UIFont(font: FontFamily._29LTAzer.bold, size: 21.9)
        
        self.imageMarkView.layer.cornerRadius = 2
        
        registerCell()
        startWindless()
        initLoadMore()
        initPullToRefresh()
        presenter.getProfiles()
        
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "Card", bundle: nil), forCellWithReuseIdentifier: "Card")
      }
   
    func initLoadMore() {
        self.collectionView.configRefreshFooter(container: self) {
            self.presenter.page += 1
            self.presenter.getProfiles()
        }
     }
    
    func initPullToRefresh() {
        self.collectionView.configRefreshHeader(container: self) {
            self.presenter.page = 1
            self.presenter.getProfiles()
        }
    }
    
     func startWindless() {
         self.collectionView.windless
             .apply {
                 $0.beginTime = 0
                 $0.pauseDuration = 1
                 $0.duration = 1.5
                 $0.animationLayerOpacity = 0.8
             }
             .start()
     }
    
}

extension CardViewController: UICollectionViewDelegate {
    
}

extension CardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath as IndexPath) as? Card
        
        print("profiles.isEmpty \(profiles.isEmpty)")
        
        if !profiles.isEmpty {
            let card = profiles[indexPath.row]
            cell?.setCellData(profile: card)
        }
        return cell!
    }
    
    func showAlert() {
         let alert = UIAlertController(title: "", message: "Nothing to show!", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
         })
         alert.addAction(action)
         self.present(alert, animated: true, completion: nil)
     }
}

extension CardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
        -> CGSize {
        return CGSize(width: 160.81, height: 219.73)
    }
}

extension CardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = bannerHeightConstraint.constant - offset

        if newHeaderViewHeight > maximumBannerHeight {
            bannerHeightConstraint.constant = maximumBannerHeight
        } else if newHeaderViewHeight < minimumBannerHeight {
            bannerHeightConstraint.constant = minimumBannerHeight
        } else {
            bannerHeightConstraint.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
        }
    }
}

extension CardViewController: CardPresenterView {
    
    func displayToast(isInternetConnectionError: Bool) {
        if isInternetConnectionError {
            print("in tosat")
            self.collectionView.switchRefreshFooter(to: .normal)
            self.collectionView.switchRefreshHeader(to: .normal(.success, 0.0))
            self.collectionView.windless.end()
            self.windelssCount = 0

            self.view.makeToast("The Internet connection appears to be offline!", duration: 3.0, position: .bottom)
        } else {
            self.view.makeToast("Something went wrong!", duration: 3.0, position: .bottom)
        }
    }
    
    func updateCollectionBackground() {
        self.collectionView.switchRefreshFooter(to: .normal)
        self.collectionView.switchRefreshHeader(to: .normal(.success, 0.0))
        self.collectionView.windless.end()
        self.windelssCount = 0
        self.collectionView.backgroundView = NoInternet()
    }
    
    func updateModel(profiles: [Profiles]) {

        self.collectionView.switchRefreshFooter(to: .normal)
        self.collectionView.switchRefreshHeader(to: .normal(.success, 0.0))
        self.collectionView.windless.end()
        self.collectionView.backgroundView = nil
        self.windelssCount = 0
        self.profiles = profiles
        self.collectionView.reloadData()
       
    }
    
}
