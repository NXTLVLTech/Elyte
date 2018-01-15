//
//  TutorialViewController.swift
//  Exotic Motor Club
//
//  Created by Lazar Vlaovic on 1/11/18.
//  Copyright © 2018 Nxtlvl. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - Properties
    let tutorialImage = ["tut1", "tut2", "tut3"]
    let tutorialTitle = ["text1", "text2", "text3"]
    var tappedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - Setup View
    private func setupView() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
    }
    
    //MARK: - Button Action
    @IBAction func skipButtonAction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "tutorialWatched")
        UserDefaults.standard.synchronize()
        loginVCRoot()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        tappedIndex += 1
        pageControl.currentPage = tappedIndex
        if tappedIndex >= 3 {
            UserDefaults.standard.set(true, forKey: "tutorialWatched")
            UserDefaults.standard.synchronize()
            loginVCRoot()
        } else {
            let indexPath = IndexPath(item: tappedIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath) as? TutorialCollectionViewCell {
            
            cell.image.image = UIImage(named: tutorialImage[indexPath.row])
            cell.title.image = UIImage(named: tutorialTitle[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        tappedIndex = Int(pageIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
