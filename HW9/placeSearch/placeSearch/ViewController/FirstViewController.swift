//
//  ViewController.swift
//  placeSearch
//
//  Created by ticky on 4/9/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import McPicker

class FirstViewController: UIViewController {

    @IBOutlet weak var searchForm: UIView!
    @IBOutlet weak var favoritesView: UIView!
    var favoriteViewController:FavoritesViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "myPlaceSearchApp_tianqi") == nil{
            let tempArray:[String]? = []
            defaults.set(tempArray, forKey: "myPlaceSearchApp_tianqi")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            UIView.animate(withDuration: 0.0, animations: {
                self.searchForm.alpha = 1.0
                self.favoritesView.alpha = 0.0
            })
        }
        else{
            UIView.animate(withDuration: 0.0, animations: {
                self.searchForm.alpha = 0.0
                self.favoritesView.alpha = 1.0
                self.favoriteViewController?.favoriteTableView.reloadData()
            })
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteSegue"
        {
            let favoriteController = ((segue.destination) as! FavoritesViewController)
            favoriteController.firstViewController = self
        }
    }
    
}

