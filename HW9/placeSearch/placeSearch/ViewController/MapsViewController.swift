//
//  MapsViewController.swift
//  placeSearch
//
//  Created by ticky on 4/15/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
//import GoogleMaps

class MapsViewController: UIViewController {
    @IBOutlet weak var fromText: UITextField!
    var selectedindex = 0
    var directionViewController:DirectionViewController?
    var locationInfo:CLLocationCoordinate2D?
    var originLocation:CLLocationCoordinate2D?
    //var destination:String?
    let travelMode = ["driving","bicycling","transit","walking"]
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.tabBarController as! DetailTabBarController).mapsViewController = self
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func traveModeSwitch(_ sender: UISegmentedControl) {
            selectedindex = sender.selectedSegmentIndex
            requestDirectionData()
    }
    @IBAction func autocompleteClicked(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    public func createMaps(){
        directionViewController?.currentLocation = locationInfo
        directionViewController?.loadMaps()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapsSegue"
        {
            directionViewController = ((segue.destination) as! DirectionViewController)
        }
    }
    func requestDirectionData(){
        let origin = fromText.text
        if origin != nil && origin != ""{
            let parameters:Parameters = [
                "origin":(originLocation?.latitude.description)!+","+(originLocation?.longitude.description)!,
                "destination":(locationInfo?.latitude.description)!+","+(locationInfo?.longitude.description)!,
                "travelMode":travelMode[selectedindex]
            ]
            Alamofire.request("http://placesearchnodejsio-env.us-east-2.elasticbeanstalk.com:3000/", parameters: parameters, encoding: URLEncoding.default).responseJSON{(responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    //print(swiftyJsonVar)
                    let polypoints = swiftyJsonVar["routes"][0]["overview_polyline"]["points"].stringValue
                    self.directionViewController?.polypoints = polypoints
                    self.directionViewController?.directionDisplay()
                }
            }
        }
    }
}

extension MapsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        fromText?.text = place.formattedAddress
        originLocation = place.coordinate
        directionViewController?.origin = place.coordinate
        
        requestDirectionData()
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
