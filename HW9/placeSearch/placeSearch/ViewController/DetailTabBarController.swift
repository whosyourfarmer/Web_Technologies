//
//  DetailViewController.swift
//  placeSearch
//
//  Created by ticky on 4/12/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GooglePlaces
import SwiftSpinner
import SwiftyJSON
import EasyToast
import SafariServices

class DetailTabBarController: UITabBarController {
    var place_id:String?
    var placeObj:[String:Any]?
    var resultObj:[String:Any]?
    var infoViewController:InfoViewController?
    var photosViewController:PhotosViewController?
    var mapsViewController:MapsViewController?
    var reviewViewController:reviewsViewController?
    var secondViewController:SecondViewController?
    //var favoriteViewController:FavoritesViewController?
    var favorEmpty:UIImage?
    var favorFilled:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favorEmpty = UIImage(named:"favorite-empty")?.tint(with:self.view.tintColor)
        self.favorFilled = UIImage(named:"favorite-filled")?.tint(with: self.view.tintColor)
        Alamofire.request("http://cs-server.usc.edu:45678/hw/hw9/images/ios/forward-arrow.png").responseImage { response in
            if let shareImg = response.result.value {
                let image = shareImg.tint(with: self.view.tintColor)
                let sharebutton = UIButton(type: UIButtonType.custom)
                sharebutton.frame=CGRect.init(x: 0, y: 0, width: 20, height: 20)
                sharebutton.setBackgroundImage(image, for: UIControlState.normal)
                sharebutton.addTarget(self, action:#selector(self.buttonTouchDown(sender:)), for: .touchUpInside)
                let shareBarButton = UIBarButtonItem.init(customView: sharebutton)
                //TODO check with local storage
                //let favorImg:UIImage? = UIImage(named:"favorite-empty")
                //let imageUpdated = favorImg!.tint(with: self.view.tintColor)
                let favorbutton = UIButton(type: UIButtonType.custom)
                favorbutton.frame=CGRect.init(x: 0, y: 0, width: 20, height: 20)
                let defaults = UserDefaults.standard
                let myArray = defaults.object(forKey: "myPlaceSearchApp_tianqi") as! [String]
                if myArray.contains(self.place_id!){
                    favorbutton.setBackgroundImage(self.favorFilled, for: UIControlState.normal)
                }
                else{
                    favorbutton.setBackgroundImage(self.favorEmpty, for: UIControlState.normal)
                }
                favorbutton.addTarget(self, action:#selector(self.favorTouchDown(sender:)), for: .touchUpInside)
                let favorBarButton = UIBarButtonItem.init(customView: favorbutton)
                self.navigationItem.rightBarButtonItems = [favorBarButton,shareBarButton]
                
            }
        }
    }
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            secondViewController?.tableView.reloadData()
            //favoriteViewController?.favoriteTableView.reloadData()
        }
    }
    @objc func buttonTouchDown(sender:UIButton) {
        print("share button Touch Down")
        var tweet = "https://twitter.com/intent/tweet?";
        var webUrl:String?
        if placeObj!["Website"] != nil{
            webUrl = placeObj!["Website"] as? String
        }
        else{
            webUrl = placeObj!["Google Page"] as? String
        }
        var tweetPath = "text=Check out " + (resultObj!["name"] as! String)
        tweetPath += " located at "
        tweetPath += (placeObj!["Address"] as! String)
        tweetPath += ". Website: "
        tweetPath += webUrl!
        tweetPath = tweetPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        tweetPath += "&button_hashtag=TravelAndEntertainmentSearch"
        tweet += tweetPath
        let url = URL(string:tweet)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    @objc func favorTouchDown(sender:UIButton) {
        let defaults = UserDefaults.standard
        var myArray = defaults.object(forKey: "myPlaceSearchApp_tianqi") as! [String]
        if (sender.currentBackgroundImage!.isEqual(favorFilled)){
            sender.setBackgroundImage(favorEmpty, for: .normal)
            myArray = myArray.filter{$0 != place_id}
            defaults.removeObject(forKey: place_id!)
            defaults.set(myArray, forKey: "myPlaceSearchApp_tianqi")
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            let alert:String = resultObj!["name"] as! String + " was removed from favorites"
            self.view.showToast(alert, position: .bottom, popTime: 2, dismissOnTap: false)
        }
        else{
            sender.setBackgroundImage(favorFilled, for: .normal)
            myArray.append(place_id!)
            defaults.set(resultObj!, forKey: place_id!)
            defaults.set(myArray,forKey:"myPlaceSearchApp_tianqi")
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            let alert:String = resultObj!["name"] as! String + " was added to favorites"
            self.view.showToast(alert, position: .bottom, popTime: 2, dismissOnTap: false)
        }
    }
    
    public func updatedTitle(){
        SwiftSpinner.show("Fetching place details...")
        self.title = self.resultObj!["name"] as? String
        let parameters:Parameters = [
            "place_id":self.place_id!
        ]
        Alamofire.request("http://placesearchnodejsio-env.us-east-2.elasticbeanstalk.com:3000/", parameters: parameters, encoding: URLEncoding.default).responseJSON{(responseData) -> Void in
            switch responseData.result{
            case .success:
                if((responseData.result.value) != nil) {
                    let place = JSON(responseData.result.value!)["result"]
                    let obj:[String:Any] = ["Address": place["formatted_address"].stringValue, "Phone Number": place["international_phone_number"].stringValue, "Price Level": place["price_level"].intValue ,"Rating":place["rating"].floatValue,"Website":place["website"].stringValue,"Google Page":place["url"].stringValue]
                    self.infoViewController?.dataObj = obj
                    self.placeObj = obj
                    self.infoViewController?.tableView.reloadData()
                    self.photosViewController?.place_id = self.place_id
                    self.photosViewController?.getPhotosArray()
                    self.photosViewController?.collectView.reloadData()
                    let placeLocation = CLLocationCoordinate2DMake(place["geometry"]["location"]["lat"].doubleValue, place["geometry"]["location"]["lng"].doubleValue)
                    self.mapsViewController?.locationInfo = placeLocation
                    self.mapsViewController?.createMaps()
                    var googleReviews:[[String:Any]] = []
                    for result in place["reviews"].arrayValue {
                        let name = result["author_name"].stringValue
                        let url = result["author_url"].stringValue
                        let userImage = result["profile_photo_url"].stringValue
                        let rating = result["rating"].floatValue
                        let comment = result["text"].stringValue
                        let time = result["time"].intValue
                        let reviewsObj:[String:Any] = ["name": name, "url": url, "userImage": userImage,"rating":rating, "comment":comment,"time":time]
                        googleReviews.append(reviewsObj)
                    }
                    self.reviewViewController?.results = googleReviews
                    self.reviewViewController?.tableView.reloadData()
                
                    var city = "";
                    var state = "";
                    var country = "";
                    var zip = "";
                    for result in place["address_components"].arrayValue{
                        if(result["types"][0] == "locality"){
                            city = result["long_name"].stringValue;
                        }
                        if(result["types"][0] == "administrative_area_level_1"){
                            state = result["short_name"].stringValue;
                        }
                        if(result["types"][0] == "country"){
                            country = result["short_name"].stringValue;
                        }
                        if(result["types"][0] == "postal_code"){
                            zip = result["short_name"].stringValue;
                        }
                    }
                    let yelpParameters:Parameters = [
                        "name":place["name"].stringValue,
                        "address1":place["formatted_address"].stringValue,
                        "city":city,
                        "state":state,
                        "country":country,
                        "zip":zip
                    ]
                    Alamofire.request("http://placesearchnodejsio-env.us-east-2.elasticbeanstalk.com:3000/", parameters: yelpParameters, encoding: URLEncoding.default).responseJSON{(responseData) -> Void in
                        switch responseData.result{
                        case .success:
                            if((responseData.result.value) != nil) {
                                let yelpRes = JSON(responseData.result.value!)
                                var yelpReviews:[[String:Any]] = []
                                if yelpRes["reviews"] != JSON.null{
                                    for result in yelpRes["reviews"].arrayValue {
                                        let name = result["user"]["name"].stringValue
                                        let url = result["url"].stringValue
                                        let userImage = result["user"]["image_url"].stringValue
                                        let rating = result["rating"].floatValue
                                        let comment = result["text"].stringValue
                                        let time = result["time_created"].stringValue
                                        let reviewsObj:[String:Any] = ["name": name, "url": url, "userImage": userImage,"rating":rating, "comment":comment,"time":time]
                                        yelpReviews.append(reviewsObj)
                                    }
                                }
                                if yelpReviews.count > 0 || yelpRes["businesses"] != JSON.null{
                                    self.reviewViewController?.yelpResults = yelpReviews
                                }
                            }
                        case .failure:
                            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
                            self.view.toastTextColor = UIColor.white
                            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
                            self.view.showToast("Failed to get yelp reviews", position: .bottom, popTime: 2, dismissOnTap: false)
                        }
                    }
                    SwiftSpinner.hide()
                }
            case .failure:
                self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
                self.view.toastTextColor = UIColor.white
                self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
                self.view.showToast("Failed to get details", position: .bottom, popTime: 2, dismissOnTap: false)
                SwiftSpinner.hide()
            }
        }
    }
    
}

extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
