//
//  MapVC.swift
//  Media
//
//  Created by Apple on 23/12/2022.
//

import MapKit

protocol AddressDelegation: AnyObject {
    func sendAddress(location: String)
}

class MapVC: UIViewController {
    
    //MARK: - Outlets.
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties.
    private let locationManager = CLLocationManager()
    weak var delegate: AddressDelegation?
    
    //MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
    }
    
    //MARK: - Actions.
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        let address = userAddressLabel.text ?? ""
        self.navigationController?.popViewController(animated: true)
        delegate?.sendAddress(location: address)
    }
}

//MARK: - MapView Delegate.
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: lat, longitude: long)
        setAddressFrom(location: location)
    }
}

//MARK: - Private Methods
extension MapVC {
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            checkLocationAuthorization()
        } else {
            showAlert(title: "Sorry", message: "Can't Get Location Please open GPS")
        }
    }
    private func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
           centerOfSpecifacationLocation()
            // ADD THE CURRENT LOCATION METHOD?
        case .denied, .restricted:
            showAlert(title: "Sorry", message: "Can't Get Location")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            showAlert(title: "Error", message: "Try Again")
        }
    }
    private func centerOfSpecifacationLocation(){
        let location = CLLocation(latitude: 29.959615, longitude: 31.270600)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        setAddressFrom(location: location)
    }
    private func setAddressFrom(location: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let error = error {
                print("\(error)")
            } else if let firstPlaceMarks = placeMarks?.first {
                self.userAddressLabel.text = firstPlaceMarks.compactAddress
            }
        }
    }
}
