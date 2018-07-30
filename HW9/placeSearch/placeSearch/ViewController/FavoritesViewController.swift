//
//  FavoritesViewController.swift
//  placeSearch
//
//  Created by ticky on 4/17/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import EasyToast

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var noFavoriteLabel: UILabel!
    @IBOutlet weak var favoriteTableView: UITableView!
    var firstViewController:FirstViewController?
    var results:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        firstViewController?.favoriteViewController = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        results = []
        let defaults = UserDefaults.standard
        let myArray = defaults.object(forKey: "myPlaceSearchApp_tianqi") as! [String]
        for iter in myArray{
            let obj = defaults.object(forKey: iter) as! [String:Any]
            results.append(obj)
        }
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteDetailSegue"
        {
            let detailTabBarController = ((segue.destination) as! DetailTabBarController)
            let indexPath = self.favoriteTableView.indexPathForSelectedRow!
            let result = results[indexPath.row]
            detailTabBarController.resultObj = result
            detailTabBarController.place_id = result["place_id"] as? String
            //print(detailTabBarController.place_id!)
            detailTabBarController.updatedTitle()
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            //detailTabBarController.favoriteViewController = self
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if results.count == 0{
            favoriteTableView.isHidden = true
            noFavoriteLabel.isHidden = false
            noFavoriteLabel.text = "No Favorites"
        }
        else{
            favoriteTableView.isHidden = false
            noFavoriteLabel.isHidden = true
        }
        return results.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoriteTableViewCell
        
        Alamofire.request(results[indexPath.row]["icon"] as! String).responseImage { response in
            if let image = response.result.value {
                cell.iconView.image = image
            }
        }
        cell.nameLabel.text = results[indexPath.row]["name"] as? String
        cell.addressLabel.text = results[indexPath.row]["address"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let defaults = UserDefaults.standard
            var myArray = defaults.object(forKey: "myPlaceSearchApp_tianqi") as! [String]
            myArray = myArray.filter{$0 != results[indexPath.row]["place_id"] as! String}
            defaults.removeObject(forKey: results[indexPath.row]["place_id"] as! String)
            defaults.set(myArray, forKey: "myPlaceSearchApp_tianqi")
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            let alert:String = results[indexPath.row]["name"] as! String + " was removed from favorites"
            self.view.showToast(alert, position: .bottom, popTime: 2, dismissOnTap: false)
            results.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
