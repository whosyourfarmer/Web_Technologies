//
//  InfoViewController.swift
//  placeSearch
//
//  Created by ticky on 4/13/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import GooglePlaces
import Cosmos

class InfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataObj:[String:Any]?
    let dataTable = ["Address","Phone Number","Price Level","Rating","Website","Google Page"]
    var traverseTable:[String] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        (self.tabBarController as! DetailTabBarController).infoViewController = self
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
        self.tabBarController?.selectedIndex = 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        traverseTable = []
        var count:Int = 0
        for header in dataTable{
            if header == "Price Level" || header == "Rating"{
                if header == "Rating" && dataObj?[header] != nil{
                    count += 1
                    traverseTable.append(header)
                }
                else if header == "Price Level" && dataObj?[header] != nil && (dataObj?[header] as! Int) != 0{
                    count += 1
                    traverseTable.append(header)
                }
            }
            else{
                if dataObj?[header] != nil && dataObj?[header] as! String != ""{
                    count += 1
                    traverseTable.append(header)
                }
            }
        }
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableCell") as! InfoTableViewCell
        let tempStr = traverseTable[indexPath.row]
        cell.cosmosView.isHidden = true
        cell.content.isHidden = false
        var content:String?
        switch(tempStr){
        case "Address":
            if dataObj?[tempStr] != nil && dataObj?[tempStr] != nil{
                content = dataObj?[tempStr] as? String
            }
        case "Phone Number":
            if dataObj?[tempStr] != nil && dataObj?[tempStr] != nil{
                content = dataObj?[tempStr] as? String
            }
        case "Price Level":
            if dataObj?[tempStr] != nil{
                switch(dataObj?[tempStr] as! Int){
                /*case GMSPlacesPriceLevel(rawValue: -1):
                    content = ""*/
                case 0:
                    content = ""
                case 1:
                    content = "$"
                case 2:
                    content = "$$"
                case 3:
                    content = "$$$"
                case 4:
                    content = "$$$$"
                default:
                    content = nil
                }
            }
        case "Rating":
            if dataObj?[tempStr] != nil{
                cell.cosmosView.isHidden = false
                (cell.cosmosView as! CosmosView).rating = Double(dataObj?[tempStr] as! Float)
                (cell.cosmosView as! CosmosView).settings.fillMode = .precise
                (cell.cosmosView as! CosmosView).settings.filledColor = UIColor.red
                cell.header.text = tempStr
                cell.content.isHidden = true
            }
        case "Website":
            if dataObj?[tempStr] != nil && dataObj?[tempStr] as! String != ""{
                content = dataObj?[tempStr] as? String
            }
        case "Google Page":
            if dataObj?[tempStr] != nil && dataObj?[tempStr] as! String != ""{
                content = dataObj?[tempStr] as? String
            }
        default:
            content = nil
        }
        if content != nil{
            cell.header.text = tempStr
            cell.content.text = content
            cell.content.isEditable = false
            cell.content.dataDetectorTypes = [UIDataDetectorTypes.phoneNumber,UIDataDetectorTypes.link]
        }
        return cell
    }
}
