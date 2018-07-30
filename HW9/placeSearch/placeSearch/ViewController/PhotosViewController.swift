//
//  PhotosViewController.swift
//  placeSearch
//
//  Created by ticky on 4/14/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import GooglePlaces

class PhotosViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var place_id:String? = ""
    var photoResults = [UIImage]()
    @IBOutlet weak var collectView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.delegate = self
        collectView.dataSource = self
        (self.tabBarController as! DetailTabBarController).photosViewController = self
        // Do any additional setup after loading the view.
        self.tabBarController?.selectedIndex = 2
    }
    public func getPhotosArray(){
        self.photoResults = [UIImage]()
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: place_id!) { (photos, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                if let photos = photos?.results{
                    for pic in photos{
                        self.loadImageForMetadata(photoMetadata: pic)
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if place_id == ""{
            return 0
        }
        return photoResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = photoResults[indexPath.item]
        return cell
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.photoResults.append(photo!);
            }
        })
    }
}
