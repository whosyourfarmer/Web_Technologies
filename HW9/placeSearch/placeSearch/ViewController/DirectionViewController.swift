//
//  DirectionViewController.swift
//  placeSearch
//
//  Created by ticky on 4/15/18.
//  Copyright © 2018 tianqi. All rights reserved.
//

import UIKit
import GoogleMaps

class DirectionViewController: UIViewController {

    var currentLocation:CLLocationCoordinate2D?
    var origin:CLLocationCoordinate2D?
    var polypoints:String?
    //var mapView:GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    public func loadMaps(){
        let camera = GMSCameraPosition.camera(withLatitude:(currentLocation?.latitude)!, longitude:(currentLocation?.longitude)!, zoom:14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        view = mapView
        let marker = GMSMarker(position:currentLocation!)
        marker.map = mapView
    }
    public func directionDisplay(){
        let camera = GMSCameraPosition.camera(withLatitude:(currentLocation?.latitude)!, longitude:(currentLocation?.longitude)!, zoom:12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        view = mapView
        let path = GMSPath.init(fromEncodedPath: polypoints!)
        let singleline = GMSPolyline.init(path: path)
        singleline.strokeWidth = 5;
        singleline.strokeColor = UIColor.blue;
        singleline.map = mapView
        let markerOri = GMSMarker(position:origin!)
        markerOri.map = mapView
        let markerDes = GMSMarker(position:currentLocation!)
        markerDes.map = mapView
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(markerOri.position)
        bounds = bounds.includingCoordinate(markerDes.position)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))
    }
}
