//
//  reviewsViewController.swift
//  placeSearch
//
//  Created by ticky on 4/15/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Cosmos
import EasyToast

class reviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var orderSegmented: UISegmentedControl!
    @IBOutlet weak var noRecordLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectedReviews:Int? = 0
    var selectedSortType:Int? = 0
    var selectedSortOrder:Int? = 0
    var results:[[String:Any]]?
    var yelpResults:[[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.tabBarController as! DetailTabBarController).reviewViewController = self
        self.tabBarController?.selectedIndex = 0
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var count:Int?
        if selectedReviews == 0{
            count = results?.count
        }
        else{
            count = yelpResults?.count
        }
        if count == nil{
            tableView.isHidden = true
            noRecordLabel.isHidden = true
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("Failed to get reviews", position: .bottom, popTime: 2, dismissOnTap: false)
        }
        else if count == 0{
            tableView.isHidden = true
            noRecordLabel.isHidden = false
            noRecordLabel.text = "No reviews"
        }
        else{
            tableView.isHidden = false
            noRecordLabel.isHidden = true
        }
        return count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReviewsTableViewCell
        let urlAsString = cell.urlToBeOpened
        let url = URL(string : urlAsString!)
        UIApplication.shared.open(url!,options: [:], completionHandler: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func sorterForAscRating(this:[String:Any], that:[String:Any]) -> Bool {
        return that["rating"] as! Float > this["rating"] as! Float
    }
    func sorterForAscTime(this:[String:Any], that:[String:Any]) -> Bool {
        return that["time"] as! Int > this["time"] as! Int
    }
    func sorterForDesRating(this:[String:Any], that:[String:Any]) -> Bool {
        return this["rating"] as! Float > that["rating"] as! Float
    }
    func sorterForDesTime(this:[String:Any], that:[String:Any]) -> Bool {
        return this["time"] as! Int > that["time"] as! Int
    }
    func sorterForAscTimeYelp(this:[String:Any], that:[String:Any]) -> Bool {
        let thatArray = (that["time"] as! String).components(separatedBy: [" ",":","-"])
        let thisArray = (this["time"] as! String).components(separatedBy:([" ",":","-"]))
        var thatVal = ""
        for x in thatArray{
            thatVal += x
        }
        var thisVal = ""
        for x in thisArray{
            thisVal += x
        }
        return Int(thatVal)! > Int(thisVal)!
    }
    func sorterForDesTimeYelp(this:[String:Any], that:[String:Any]) -> Bool {
        let thatArray = (that["time"] as! String).components(separatedBy: [" ",":","-"])
        let thisArray = (this["time"] as! String).components(separatedBy:([" ",":","-"]))
        var thatVal = ""
        for x in thatArray{
            thatVal += x
        }
        var thisVal = ""
        for x in thisArray{
            thisVal += x
        }
        return Int(thisVal)! > Int(thatVal)!
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewsCell") as! ReviewsTableViewCell
        if selectedReviews == 0{
            var resultArray:[[String:Any]]? = results
            if selectedSortType == 1{
                orderSegmented.isEnabled = true
                if selectedSortOrder == 0{
                    resultArray = resultArray?.sorted(by: sorterForAscRating)
                }
                else{
                    resultArray = resultArray?.sorted(by: sorterForDesRating)
                }
            }
            else if selectedSortType == 2{
                orderSegmented.isEnabled = true
                if selectedSortOrder == 0{
                    resultArray = resultArray?.sorted(by: sorterForAscTime)
                }
                else{
                    resultArray = resultArray?.sorted(by: sorterForDesTime)
                }
            }
            else{
                orderSegmented.isEnabled = false
            }
            Alamofire.request(resultArray![indexPath.row]["userImage"] as! String).responseImage { response in
                if let image = response.result.value {
                    cell.userImageView.image = image
                }
            }
            (cell.ratingView as! CosmosView).rating = Double(resultArray?[indexPath.row]["rating"] as! Float)
            (cell.ratingView as! CosmosView).settings.fillMode = .precise
            (cell.ratingView as! CosmosView).settings.filledColor = UIColor.red
            let exactDate = NSDate(timeIntervalSince1970:TimeInterval(resultArray![indexPath.row]["time"] as! Int))
            let dateFormatt = DateFormatter();
            dateFormatt.dateFormat = "yyy-MM-dd hh:mm:ss"
            cell.timeLabel.text = dateFormatt.string(from: exactDate as Date)
            cell.userName.text = resultArray?[indexPath.row]["name"] as? String
            cell.commentLabel.text = resultArray?[indexPath.row]["comment"] as? String
            cell.urlToBeOpened = resultArray?[indexPath.row]["url"] as? String
        }
        else{
            var resultArray:[[String:Any]]? = yelpResults
            if selectedSortType == 1{
                orderSegmented.isEnabled = true
                if selectedSortOrder == 0{
                    resultArray = resultArray?.sorted(by: sorterForAscRating)
                }
                else{
                    resultArray = resultArray?.sorted(by: sorterForDesRating)
                }
            }
            else if selectedSortType == 2{
                orderSegmented.isEnabled = true
                if selectedSortOrder == 0{
                    resultArray = resultArray?.sorted(by: sorterForAscTimeYelp)
                }
                else{
                    resultArray = resultArray?.sorted(by: sorterForDesTimeYelp)
                }
            }
            else{
                orderSegmented.isEnabled = false
            }
            Alamofire.request(resultArray![indexPath.row]["userImage"] as! String).responseImage { response in
                if let image = response.result.value {
                    cell.userImageView.image = image
                }
            }
            (cell.ratingView as! CosmosView).rating = Double(resultArray?[indexPath.row]["rating"] as! Float)
            (cell.ratingView as! CosmosView).settings.fillMode = .precise
            (cell.ratingView as! CosmosView).settings.filledColor = UIColor.red
            cell.timeLabel.text = resultArray?[indexPath.row]["time"] as? String
            cell.userName.text = resultArray?[indexPath.row]["name"] as? String
            cell.commentLabel.text = resultArray?[indexPath.row]["comment"] as? String
            cell.urlToBeOpened = resultArray?[indexPath.row]["url"] as? String
        }
        return cell
    }

    @IBAction func reviewsSwitch(_ sender: UISegmentedControl) {
        if selectedReviews != sender.selectedSegmentIndex{
            selectedReviews = sender.selectedSegmentIndex
            tableView.reloadData()
        }
    }
    
    @IBAction func SortSwitch(_ sender: UISegmentedControl) {
        if selectedSortType != sender.selectedSegmentIndex{
            selectedSortType = sender.selectedSegmentIndex
            tableView.reloadData()
        }
    }
    
    @IBAction func OrderSwitch(_ sender: UISegmentedControl) {
        if selectedSortOrder != sender.selectedSegmentIndex{
            selectedSortOrder = sender.selectedSegmentIndex
            tableView.reloadData()
        }
    }
}


