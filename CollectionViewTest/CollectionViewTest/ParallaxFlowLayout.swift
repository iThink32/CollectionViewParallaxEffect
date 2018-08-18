//
//  ParallaxFlowLayout.swift
//  CollectionViewTest
//
//  Created by N.A Shashank on 11/08/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

class ParallaxFlowLayout: UICollectionViewFlowLayout {
    
    @IBInspectable var noOfCellsPerScreen:CGFloat = 4
    @IBInspectable var standardHeight:CGFloat = 100
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    struct Constants {
        let standardHeight:CGFloat
        let featuredHeight:CGFloat
        let dragOffset:CGFloat
        
        init(standardHeight:CGFloat,featuredHeight:CGFloat,dragOffset:CGFloat) {
            self.standardHeight = standardHeight
            self.featuredHeight = featuredHeight
            self.dragOffset = dragOffset
        }
    }
    
    var constants:Constants?
    
    var featuredItemIndex: Int {
        guard let unwrappedConstantsInstance = self.constants else{
            return 0
        }
        return max(0, Int(self.contentYOffsetConsideringNavigationController / unwrappedConstantsInstance.dragOffset))
    }
    
    var contentYOffsetConsideringNavigationController: CGFloat {
        guard let unwrappedCollectionView = self.collectionView else{
            return 0
        }
        return unwrappedCollectionView.contentOffset.y + unwrappedCollectionView.safeAreaInsets.top
    }
    
    var nextItemPercentageOffset: CGFloat {
        guard let unwrappedConstantsInstance = self.constants else{
            return 0
        }
        return ((self.contentYOffsetConsideringNavigationController) / unwrappedConstantsInstance.dragOffset) - CGFloat(self.featuredItemIndex)
    }
    
    var collectionViewWidth: CGFloat {
        guard let unwrappedCollectionView = self.collectionView else{
            return 0
        }
        return unwrappedCollectionView.frame.size.width
    }
    
    var collectionViewHeight: CGFloat {
        guard let unwrappedCollectionView = self.collectionView else{
            return 0
        }
        return unwrappedCollectionView.frame.size.height - unwrappedCollectionView.safeAreaInsets.top - unwrappedCollectionView.safeAreaInsets.bottom
    }
    
    override var collectionViewContentSize: CGSize {
        
        guard let unwrappedCollectionView = self.collectionView , let unwrappedConstantsInstance = self.constants else{
            return CGSize.zero
        }
        let itemsToAdd = CGFloat(unwrappedCollectionView.numberOfItems(inSection: 0)) - self.noOfCellsPerScreen
        let endOffsetOfLastFeaturedCell = unwrappedConstantsInstance.featuredHeight + (itemsToAdd * unwrappedConstantsInstance.featuredHeight)
        let itemsLeftAfterLastFeaturedCell = CGFloat(self.noOfCellsPerScreen - 1)
        let totalContentSize = endOffsetOfLastFeaturedCell + (itemsLeftAfterLastFeaturedCell * unwrappedConstantsInstance.standardHeight)
        return CGSize(width: self.collectionViewWidth, height: totalContentSize)
    }
    
    override func prepare() {
        super.prepare()
        self.cache.removeAll(keepingCapacity: false)
        guard let unwrappedCollectionView = self.collectionView else{
            return
        }
        self.populateDataModel(collectionView: unwrappedCollectionView, standardHeight: 100)
        guard let unwrappedConstantsInstance = self.constants else{
            return
        }
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<unwrappedCollectionView.numberOfItems(inSection: 0)
        {
            
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            var height = unwrappedConstantsInstance.standardHeight
            
            if indexPath.item == self.featuredItemIndex
            {
                height = unwrappedConstantsInstance.featuredHeight
                let yOffset = unwrappedConstantsInstance.standardHeight * self.nextItemPercentageOffset
                y = self.contentYOffsetConsideringNavigationController - yOffset
                height = height - ((unwrappedConstantsInstance.featuredHeight - unwrappedConstantsInstance.standardHeight) * self.nextItemPercentageOffset)
                //if indexPath.item == (featuredItemIndex + 1) && indexPath.item != unwrappedCollectionView.numberOfItems(inSection: 0)
            }
            else if indexPath.item == (featuredItemIndex + 1)
            {
                height = height + ((unwrappedConstantsInstance.featuredHeight - unwrappedConstantsInstance.standardHeight) * self.nextItemPercentageOffset)
            }
            frame = CGRect(x: 0, y: y , width: collectionViewWidth, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache where rect.intersects(attributes.frame){
            layoutAttributes.append(attributes)
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    func populateDataModel(collectionView:UICollectionView,standardHeight:CGFloat) {
        let totalHeight = self.collectionViewHeight
        let spaceOccupiedByStandardCells = CGFloat(self.noOfCellsPerScreen - 1) * standardHeight
        let featuredCellHeight = totalHeight - spaceOccupiedByStandardCells
        guard featuredCellHeight > 0 else{
            return
        }
        self.constants = Constants(standardHeight: standardHeight, featuredHeight: featuredCellHeight, dragOffset: CGFloat(featuredCellHeight))
    }
    
}
