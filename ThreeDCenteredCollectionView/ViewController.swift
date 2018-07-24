//
//  ViewController.swift
//  ThreeDCenteredCollectionView
//
//  Created by Abhishek Khedekar on 24/07/18.
//  Copyright © 2018 Abhishek Khedekar. All rights reserved.

import UIKit

let CELL_WIDTH = 100
let CELL_SPACING = 10

class ViewController: UIViewController {
    
    private var collectionViewLayout: LGHorizontalLinearFlowLayout!
    private var dataSource: Array<String>!
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageControl: UIPageControl!
    
    private var animationsCount = 0
    
    private var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    private var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureDataSource()
        self.configureCollectionView()
        self.configurePageControl()
    }
    
    private func configureDataSource() {
        self.dataSource = Array()
        for index in 1...10 {
            self.dataSource.append("Page \(index)")
        }
    }
    
    private func configureCollectionView() {        
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: 350, height: 180), minimumLineSpacing: -40)
    }
    
    private func configurePageControl() {
        self.pageControl.numberOfPages = self.dataSource.count
    }
    
    // MARK: Actions
    
    @IBAction private func pageControlValueChanged(sender: AnyObject) {
        self.scrollToPage(page: self.pageControl.currentPage, animated: true)
    }
    
    private func scrollToPage(page: Int, animated: Bool) {
        self.collectionView.isUserInteractionEnabled = false
        self.animationsCount += 1
        let pageOffset = CGFloat(page) * self.pageWidth - self.collectionView.contentInset.left
        self.collectionView.setContentOffset(CGPoint(x: pageOffset, y: 0), animated: true)
        self.pageControl.currentPage = page
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        collectionViewCell.pageLabel.text = self.dataSource[indexPath.row]
        return collectionViewCell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
//            return
//        }
//
//        let selectedPage = indexPath.row
//
//        if selectedPage == self.pageControl.currentPage {
//            NSLog("Did select center item")
//        }
//        else {
//            self.scrollToPage(page: selectedPage, animated: true)
//        }
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let animCount = self.animationsCount - 1
        if animCount == 0 {
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = CELL_WIDTH * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = CELL_SPACING * (collectionView.numberOfItems(inSection: 0) - 1)
        if CGFloat(totalCellWidth + totalSpacingWidth) < collectionView.bounds.size.width {
            let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: collectionView.frame.size.height)
    }
    
}


