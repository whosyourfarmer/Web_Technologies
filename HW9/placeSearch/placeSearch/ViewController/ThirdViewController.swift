//
//  ThirdViewController.swift
//  placeSearch
//
//  Created by ticky on 4/10/18.
//  Copyright © 2018 tianqi. All rights reserved.
//
//import Foundation
import UIKit
import McPicker
import GooglePlaces
import EasyToast
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ThirdViewController: UIViewController {

    @IBOutlet weak var formLocation: UITextField!
    @IBOutlet weak var mcTextField: McTextField!
    @IBOutlet weak var distanceText: UITextField!
    
    let locationManager = CLLocationManager()
    var curLocation:CLLocation?
    let categoryTable = ["Default":"default", "Airport":"airport", "Amusement Park":"amusement_park", "Aquarium":"aquarium","Art Gallery":"art_gallery","Bakery":"bakery","Bar":"bar","Beauty Salon":"beauty_salon","Bowling Alley":"bowling_alley","Bus Station":"bus_station","Cafe":"cafe","Campground":"campground","Car Rental":"car_rental","Casino":"casino","Lodging":"lodging","Movie Theater":"movie_theater","Museum":"museum","Night Club":"night_club","Park":"park","Parking":"parking","Restaurant":"restaurant","Shopping Mall":"shopping_mall","Stadium":"stadium","Subway Station":"subway_station","Taxi Stand":"taxi_stand","Train Station":"train_station","Transit Station":"transit_station","Travel Agency":"travel_agency","Zoo":"zoo"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let data: [[String]] = [["Default", "Airport", "Amusement Park", "Aquarium","Art Gallery","Bakery","Bar","Beauty Salon","Bowling Alley","Bus Station","Cafe","Campground","Car Rental","Casino","Lodging","Movie Theater","Museum","Night Club","Park","Parking","Restaurant","Shopping Mall","Stadium","Subway Station","Taxi Stand","Train Station","Transit Station","Travel Agency","Zoo"]]
        let mcInputView = McPicker(data: data)
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        mcTextField.inputViewMcPicker = mcInputView
        
        mcTextField.doneHandler = { [weak mcTextField] (selections) in
            mcTextField?.text = selections[0]!
        }
        mcTextField.selectionChangedHandler = { [weak mcTextField] (selections, componentThatChanged) in
            mcTextField?.text = selections[componentThatChanged]!
        }
        mcTextField.cancelHandler = { [weak mcTextField] in
            mcTextField?.text = mcTextField?.text//"Cancelled."
        }
        mcTextField.textFieldWillBeginEditingHandler = { [weak mcTextField] (selections) in
            if mcTextField?.text == "" {
                // Selections always default to the first value per component
                mcTextField?.text = selections[0]
            }
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    @IBAction func clearClicked(_ sender: UIButton) {
        formLocation.text = ""
        mcTextField.text = "Default"
        distanceText.text = ""
        keyword.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func autocompleteClicked(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    

    
    @IBOutlet weak var keyword: UITextField!
    @IBAction func searchClicked(_ sender: UIButton) {
        let textVal = keyword?.text
        
        if !textVal!.trimmingCharacters(in: .whitespaces).isEmpty {
            SwiftSpinner.show("Searching...")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            let jsonObject:[String:Any] = [
                "lat":curLocation?.coordinate.latitude ?? 34.022352,
                "lon":curLocation?.coordinate.longitude ?? -118.285117
            ]
            let jsonString = JSONStringify(json:jsonObject)
            let categoryText = categoryTable[mcTextField?.text ?? "Default"]
            var place:String?
            if formLocation?.text == "Your location"{
                place = "here"
            }
            else{
                place = "other_place"
            }
            let parameters:Parameters = [
                "keyword":textVal ?? "",
                "category":categoryText ?? "default",
                "distance":distanceText?.text ?? "",
                "place":place!,
                "location_custom":formLocation?.text ?? "",
                "json_string":jsonString
            ]
            Alamofire.request("http://placesearchnodejsio-env.us-east-2.elasticbeanstalk.com:3000/", parameters: parameters, encoding: URLEncoding.default).responseJSON{(responseData) -> Void in
                switch responseData.result{
                case .success:
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        //print(swiftyJsonVar)
                        var rawResults:[[String:Any]] = []
                        for result in swiftyJsonVar["results"].arrayValue {
                            let name = result["name"].stringValue
                            let address = result["vicinity"].stringValue
                            let icon = result["icon"].stringValue
                            let place_id = result["place_id"].stringValue
                            let obj:[String:Any] = ["name": name, "address": address, "icon": icon,"place_id":place_id]
                            rawResults.append(obj)
                        }
                        newViewController.results = rawResults
                        newViewController.next_token = swiftyJsonVar["next_page_token"].stringValue
                        //newViewController.viewDidLoad()
                        newViewController.tableView.reloadData()
                        newViewController.prevButton.isEnabled = false
                        if newViewController.next_token != nil && newViewController.next_token != ""{
                            newViewController.nextButton.isEnabled = true
                        }
                        else{
                            newViewController.nextButton.isEnabled = false
                        }
                        SwiftSpinner.hide()
                    }
                case .failure:
                    self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
                    self.view.toastTextColor = UIColor.white
                    self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
                    self.view.showToast("Failed to get results", position: .bottom, popTime: 2, dismissOnTap: false)
                    SwiftSpinner.hide()
                }
            }
        }
        else{
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.boldSystemFont(ofSize: 19)
            self.view.showToast("Keyword cannot be empty", position: .bottom, popTime: 2, dismissOnTap: false)
        }
        
    }

}

extension ThirdViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        formLocation?.text = place.formattedAddress
        print("Place name: \(place.formattedAddress ?? "")")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension ThirdViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        curLocation = location
    }
}

func JSONStringify(json: Any, prettyPrinted: Bool = false) -> String {
    var options: JSONSerialization.WritingOptions = []
    if prettyPrinted {
        options = JSONSerialization.WritingOptions.prettyPrinted
    }
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: options)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
    } catch {
        print(error)
    }
    return ""
}
