//
//  MapController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/15/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController {
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var events : [Event]?
    var searchBar : UISearchBar?
    var creating : Bool?
    
    let mapView : MKMapView = {
        let mk = MKMapView()
        return mk
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        if creating != nil && creating! {
            resultSearchController?.becomeFirstResponder()
            // searchBar?.becomeFirstResponder()
        }
        getAllEvents()
    }
    
    func getAllEvents() {
        apiManager.getEvents(completion: { res in
            let events = res.allEvents + res.friendEvents + res.myEvents
            self.events = events
            DispatchQueue.main.async {
                for ev in self.events! {
                    let annotation = MyAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(ev.location.coord.lat, ev.location.coord.lng)
                    annotation.title = ev.title
                    annotation.identifier = ev._id
                    annotation.imagePath = ev.picture!
                    annotation.event = ev
                    let city = ev.location.address.p
                    let state = ev.location.address.v
                    annotation.subtitle = "\(city) \(state)"
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = false
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        getAllEvents()
        self.view = mapView
        let locationSearchTable = LocationSearchController()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        searchBar = resultSearchController!.searchBar
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search for places"
        resultSearchController?.isActive = true
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        if creating != nil && creating! {
            print("yoooo")
            resultSearchController?.becomeFirstResponder()
            searchBar?.becomeFirstResponder()
        }
        
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func localizeMe() {
        if let locations = locationManager.location{
            let position = locations.coordinate
            let center = CLLocationCoordinate2D(latitude: (position.latitude), longitude: (position.longitude))
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupButton() {
        let localize = UIButton()
        localize.setImage(UIImage(named: "localize"), for: .normal)
        localize.addTarget(self, action: #selector(localizeMe), for: .touchUpInside)
        localize.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(localize)

        NSLayoutConstraint.activate([
            localize.widthAnchor.constraint(equalToConstant: 30),
            localize.heightAnchor.constraint(equalToConstant: 30),
            localize.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            localize.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135)
            ])
        
    }
    
    func printToastMsg() {
        ToastView.shared.short(self.view, txt_msg: "Event created", color : UIColor.green)
        selectedPin = nil
    }
    
    @objc func goToEventDescription() {
        let selected = mapView.selectedAnnotations[0] as? MyAnnotation
        if selected != nil {
            let vc = EventDetailController(selected!.event!)
            vc.rootMap = self
            
            guard selected!.event!.playlist != nil else { return }
            apiManager.getMe(userManager.currentUser!.token!) { (user) in
                SocketIOManager.sharedInstance.createEventRoom(roomID: selected!.event!._id!, userID: user.id)
                userID = user.id
                vc.type = selected?.event!.creator!.id == userID ? .mine : .friends
                vc.iAmMember = true
                let bool = selected!.event?.adminMembers.first(where: { (ur) -> Bool in
                    return ur.id == userID
                })
                vc.iAmAdmin = bool != nil ? true : false
                if currentTrack != nil {
                    playerController.handlePause()
                }
                (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.minimizedPlayer.isUserInteractionEnabled = false
                playerController.view.isUserInteractionEnabled = false
                (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.minimizedPlayer.titleLabel.text = "live event"
                (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.minimizedPlayer.authorLabel.text = "\(selected!.event!.title)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func createEvent() {
        let dest = EventController()
        dest.locationManager = locationManager
        dest.selectedPin = selectedPin
        self.navigationController?.pushViewController(dest, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        if status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
        print(error.localizedDescription)
    }
}

extension MapController : MKMapViewDelegate {
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        
        let smallSquare = CGSize(width: 30, height: 30)
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.annotation = annotation
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        let button = UIButton(frame: CGRect(origin: CGPoint(), size: smallSquare))
        activityView.center = button.center
        activityView.color = UIColor.black
        activityView.startAnimating()
        button.addSubview(activityView)
        let bool = ((selectedPin != nil) && annotation.title! == selectedPin!.name && annotation.coordinate.latitude == selectedPin!.coordinate.latitude && annotation.coordinate.longitude == selectedPin!.coordinate.longitude)
        if bool {
            pinView?.pinTintColor = UIColor.orange
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            button.setImage(#imageLiteral(resourceName: "add_black_event"), for: .normal)
            button.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        } else {
            pinView?.pinTintColor = UIColor.red
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            if let a = annotation as? MyAnnotation {
                apiManager.getImgEvent(a.imagePath!, completion: { (image) in
                    if image != nil {
                        DispatchQueue.main.async {
                            a.image = image
                            button.setImage(image, for: .normal)
                            button.addTarget(self, action: #selector(self.goToEventDescription), for: .touchUpInside)
                            activityView.stopAnimating()
                            activityView.removeFromSuperview()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        
                    }
                })
                
            }
        
        }
        pinView?.canShowCallout = true
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}


extension MapController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        for annotation in mapView.selectedAnnotations {
            mapView.removeAnnotation(annotation)
            mapView.deselectAnnotation(annotation, animated: true)
        }
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}

class MyAnnotation : MKPointAnnotation {
    var identifier : String?
    var imagePath : String?
    var image : UIImage?
    var id : Int?
    var event : Event?
    override init() {
        super.init()
    }
}
