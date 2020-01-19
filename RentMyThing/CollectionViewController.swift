//
//  CollectionViewController.swift
//  RentMyThing
//
//  Created by vidit jindal on 03/08/18.
//  Copyright © 2018 vidit jindal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let reuseIdentifier = "cell"
protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: String)
}
class CollectionViewController: UICollectionViewController {
    var genre = ""
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = genre
        Database.database().reference().child("Email").queryOrdered(byChild: "Are you seller").queryEqual(toValue: true).observe(DataEventType.childAdded) { (snap) in
            if let dic = snap.value as? [String: Any] {
                if let email1 = dic["uid"] as? String{
                    Database.database().reference().child("Seller Inventory").child(email1).queryOrdered(byChild: "Book Genre").queryEqual(toValue: self.genre).observe(DataEventType.childAdded, with: { (snap1) in
                        if let dic = snap1.value as? [String: Any]{
                            if let images = dic["Book Image"] as? String {
                                self.images.append(images)
                                self.collectionView?.reloadData()
                            }
                        }
                        self.collectionView?.reloadData()
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? YourBookCollectionViewCell
        let image = self.images[indexPath.item]
        cell?.image1.sd_setImage(with: URL(string: image), completed: nil)
        return cell!
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
