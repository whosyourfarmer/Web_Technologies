//
//  SecondViewController.swift
//  placeSearch
//
//  Created by ticky on 4/9/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import SwiftSpinner
import EasyToast

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var norecordLabel: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var prevButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var globalResults:[[[String:Any]]] = [[["":""]],[["":""]],[["":""]]]
    var nextArray:[String] = ["","",""]
    var results:[[String:Any]]?
    var curIndex:Int = 0
    var next_token:String?
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Search Results"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue"
        {
            let detailTabBarController = ((segue.destination) as! DetailTabBarController)
            let indexPath = self.tableView.indexPathForSelectedRow!
            let result = results?[indexPath.row]
            detailTabBarController.resultObj = result!
            detailTabBarController.place_id = result!["place_id"] as? String
            //print(detailTabBarController.place_id!)
            detailTabBarController.updatedTitle()
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            detailTabBarController.secondViewController = self
        }
    }

    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        var myArray = defaults.object(forKey: "myPlaceSearchApp_tianqi") as! [String]
        if(sender.currentBackgroundImage?.isEqual(UIImage(named:"favorite-empty")))!{
            sender.setBackgroundImage(UIImage(named: "favorite-filled"), for: .normal)
            myArray.append(results![sender.tag]["place_id"] as! String)
            defaults.set(results![sender.tag], forKey: results![sender.tag]["place_id"] as! String)
            defaults.set(myArray,forKey:"myPlaceSearchApp_tianqi")
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            let alert = results![sender.tag]["name"] as! String + " was added to favorites"
            self.view.showToast(alert, position: .bottom, popTime: 2, dismissOnTap: false)
        }
        else{
            sender.setBackgroundImage(UIImage(named: "favorite-empty"), for: .normal)
            myArray = myArray.filter{$0 != results![sender.tag]["place_id"] as! String}
            defaults.removeObject(forKey: results![sender.tag]["place_id"] as! String)
            defaults.set(myArray, forKey: "myPlaceSearchApp_tianqi")
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            let alert = results![sender.tag]["name"] as! String + " was removed from favorites"
            self.view.showToast(alert, position: .bottom, popTime: 2, dismissOnTap: false)
        }
    }
    @IBAction func nextPage(_ sender: UIBarButtonItem) {
        SwiftSpinner.show("Loading next page...")
        let parameters:Parameters = [
            "next_page":next_token ?? ""
        ]
        Alamofire.request("http://placesearchnodejsio-env.us-east-2.elasticbeanstalk.com:3000/", parameters: parameters, encoding: URLEncoding.default).responseJSON{(responseData) -> Void in
            switch responseData.result{
            case .success:
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    var rawResults:[[String:Any]] = []
                    for result in swiftyJsonVar["results"].arrayValue {
                        let name = result["name"].stringValue
                        let address = result["vicinity"].stringValue
                        let icon = result["icon"].stringValue
                        let place_id = result["place_id"].stringValue
                        let obj:[String:Any] = ["name": name, "address": address, "icon": icon,"place_id":place_id]
                        rawResults.append(obj)
                    }
                    self.results = rawResults
                    self.next_token = swiftyJsonVar["next_page_token"].stringValue
                    self.curIndex += 1
                    //self.globalResults[self.curIndex] = self.results!
                    self.tableView.reloadData()
                    self.prevButton.isEnabled = true
                    if self.next_token != nil && self.next_token != ""{
                        self.nextButton.isEnabled = true
                    }
                    else{
                        self.nextButton.isEnabled = false
                    }
                    SwiftSpinner.hide()
                }
            case .failure:
                self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
                self.view.toastTextColor = UIColor.white
                self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
                self.view.showToast("Failed to get next page", position: .bottom, popTime: 2, dismissOnTap: false)
                SwiftSpinner.hide()
            }
        }
    }
    @IBAction func prevPage(_ sender: UIBarButtonItem) {
        self.curIndex -= 1
        self.results = self.globalResults[self.curIndex]
        self.next_token = self.nextArray[self.curIndex]
        if self.curIndex > 0{
            self.prevButton.isEnabled = true
        }
        else{
            self.prevButton.isEnabled = false
        }
        self.nextButton.isEnabled = true
        self.tableView.reloadData()
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if results == nil{
            tableView.isHidden = true
            norecordLabel.isHidden = true
        }
        else if results!.count == 0{
            tableView.isHidden = true
            norecordLabel.isHidden = false
            norecordLabel.text = "No Results"
        }
        else{
            tableView.isHidden = false
            norecordLabel.isHidden = true
        }
        return results?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        Alamofire.request(results![indexPath.row]["icon"] as! String).responseImage { response in
            if let image = response.result.value {
                cell.iconView.image = image
            }
        }
        cell.nameView.text = results?[indexPath.row]["name"] as? String
        cell.addressView.text = results?[indexPath.row]["address"] as? String
        let defaults = UserDefaults.standard
        let myArray = defaults.object(forKey: "myPlaceSearchApp_tianqi") as! [String]
        if myArray.contains(results![indexPath.row]["place_id"] as! String){
            cell.favorView.setBackgroundImage(UIImage(named:"favorite-filled"), for: .normal)
        }
        else{
            cell.favorView.setBackgroundImage(UIImage(named:"favorite-empty"), for: .normal)
        }
        cell.favorView.tag = indexPath.row
        globalResults[curIndex] = results!
        nextArray[curIndex] = next_token!
        return cell
    }

}
