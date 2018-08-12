//
//  ParallaxFlowLayout.swift
//  CollectionViewTest
//
//  Created by N.A Shashank on 11/08/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

class ParallaxFlowLayout: UICollectionViewLayout {
    
    @IBInspectable var noOfCellsPerScreen:CGFloat = 4
    @IBInspectable var standardHeight:CGFloat = 100
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    var featuredItemIndex: Int {
        guard let unwrappedCollectionView = self.collectionView,let unwrappedConstantsInstance = self.constants else{
            return 0
        }
        return max(0, Int(unwrappedCollectionView.contentOffset.y / unwrappedConstantsInstance.dragOffset))
    }
    
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
    
    var nextItemPercentageOffset: CGFloat {
        guard let unwrappedCollectionView = self.collectionView,let unwrappedConstantsInstance = self.constants else{
            return 0
        }
        return (unwrappedCollectionView.contentOffset.y / unwrappedConstantsInstance.dragOffset) - CGFloat(self.featuredItemIndex)
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
        return unwrappedCollectionView.frame.size.height
    }
    
    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    func populateRequiredProperties(collectionView:UICollectionView,standardHeight:CGFloat) {
        let totalHeight = collectionView.frame.size.height
        let spaceOccupiedByStandardCells = CGFloat(self.noOfCellsPerScreen - 1) * standardHeight
        let featuredCellHeight = totalHeight - spaceOccupiedByStandardCells
        guard featuredCellHeight > 0 else{
            return
        }
        self.constants = Constants(standardHeight: standardHeight, featuredHeight: featuredCellHeight, dragOffset: CGFloat(featuredCellHeight))
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
        self.populateRequiredProperties(collectionView: unwrappedCollectionView, standardHeight: 100)
        guard let unwrappedConstantsInstance = self.constants else{
            return
        }
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            /* Important because each cell has to slide over the top of the previous one */
            attributes.zIndex = item
            /* Initially set the height of the cell to the standard height */
            var height = unwrappedConstantsInstance.standardHeight
            
            if indexPath.item == self.featuredItemIndex {
                /* The featured cell */
                height = unwrappedConstantsInstance.featuredHeight
                let yOffset = unwrappedConstantsInstance.standardHeight * self.nextItemPercentageOffset
                y = self.collectionView!.contentOffset.y - yOffset
                height = height - ((unwrappedConstantsInstance.featuredHeight - unwrappedConstantsInstance.standardHeight) * self.nextItemPercentageOffset)
                print("height of featured item is:\(height)")
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                height = height + ((unwrappedConstantsInstance.featuredHeight - unwrappedConstantsInstance.standardHeight) * self.nextItemPercentageOffset)
                print("height of to be featured item is \(height)")
            }
            frame = CGRect(x: 0, y: y, width: collectionViewWidth, height: height)
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
    
    //    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    //        let itemIndex = round(proposedContentOffset.y / dragOffset)
    //        let yOffset = itemIndex * dragOffset
    //        return CGPoint(x: 0, y: yOffset)
    //    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
