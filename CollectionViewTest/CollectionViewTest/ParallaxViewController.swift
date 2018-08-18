//
//  ParallaxCollectionViewController.swift
//  CollectionViewTest
//
//  Created by N.A Shashank on 11/08/18.
//  Copyright © 2018 Razorpay. All rights reserved.
//

import UIKit

// UICollectionViewDelegateFlowLayout
class ParallaxViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
//
    var arrColors = [UIColor.red,UIColor.blue,UIColor.purple,UIColor.lightGray,UIColor.magenta,UIColor.black,UIColor.green,UIColor.brown,UIColor.cyan,UIColor.lightGray]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.collectionView.contentInsetAdjustmentBehavior = .always
//                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -40, right: 0)
//        self.collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.always
        self.collectionView.reloadData()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reqdColor = self.arrColors[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParallaxCollectionViewCell", for: indexPath) as! ParallaxCollectionViewCell
        cell.setData(color: reqdColor)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
