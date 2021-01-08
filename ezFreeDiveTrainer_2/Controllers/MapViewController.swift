//
//  MapViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/31.
//

import UIKit
import MapKit
import SCLAlertView

class MapViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var userCurrentLocation = CLLocationCoordinate2D()
    let annotation = MKPointAnnotation()
    let annotationview = MKPinAnnotationView()
    
    var regionUpdateCenter = CLLocationCoordinate2D()
    
    var isTheFistTimeLocated = false
    
    var placeTextfield = UITextField()
    var isAddDiveSite = false
    var isFirstTimeLoadAnnotition = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        myMapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else if locationManager.authorizationStatus == .denied {
            let alert = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func popViewEditNewDiveSite(_ sender: Any) {
        print("AddAdd")
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 30,
            kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
            kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
            kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
            contentViewCornerRadius: 20
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.view.backgroundColor = UIColor.clear
        
        placeTextfield = alertView.addTextField("Place")
        placeTextfield.backgroundColor = UIColor.clear
        placeTextfield.textColor = UIColor.systemGray
        alertView.addButton("Add", target: self, selector: #selector(addBtnPressed))
        
        alertView.showSuccess("Add new dive site 🥰", subTitle: "Let's go~~", closeButtonTitle: "Cancel", circleIconImage: #imageLiteral(resourceName: "buoy"))
    }
    
    @objc func addBtnPressed() {
        guard let text = placeTextfield.text else { return }
        
        if text != "" {
            //New Annotation
            let newDiveSite = MKPointAnnotation()
            newDiveSite.coordinate = regionUpdateCenter
            newDiveSite.title = "\(text)"
            newDiveSite.subtitle = String(format: "%0.4f, ", regionUpdateCenter.latitude) + String(format: "%0.4f", regionUpdateCenter.longitude)
            myMapView.addAnnotation(newDiveSite)
            isAddDiveSite = true
        } else {
            print("Textfiled is Empty@@")
        }
        
    }


}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        regionUpdateCenter = mapView.region.center
        print("\(regionUpdateCenter.latitude) , \(regionUpdateCenter.longitude)")
        if !isTheFistTimeLocated {
            //將使用者定位定在中間去新增
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            let region = MKCoordinateRegion(center: regionUpdateCenter, span: span)
            myMapView.setRegion(region, animated: true)
            isTheFistTimeLocated = true
        }
        
        //下圖釘
        annotation.coordinate = regionUpdateCenter
        annotation.title = "Dive Site"
        myMapView.selectAnnotation(annotation, animated: true)
        myMapView.addAnnotations([annotation])
        
    }
    
}
extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        //first time
        var resultID = "AddDiveSite"
        //second time
        if isAddDiveSite == true {
            resultID = "\(regionUpdateCenter.latitude)_\(regionUpdateCenter.longitude)"
            isAddDiveSite = false
        }
        //different ID
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: resultID)

        if result == nil {
            if isFirstTimeLoadAnnotition == true {
                result = MKAnnotationView(annotation: annotation, reuseIdentifier: resultID)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = #imageLiteral(resourceName: "buoy")
                result?.leftCalloutAccessoryView = imageView
                result?.canShowCallout = true
                result?.image = #imageLiteral(resourceName: "anchor").resize(newSize: CGSize(width: 50.0, height: 50.0))
                
                let button = UIButton(type: .contactAdd)//圓形一個i的圖案  //custom自訂圖案摟
                button.addTarget(self, action: #selector(popViewEditNewDiveSite(_:)), for: .touchUpInside)
                result?.rightCalloutAccessoryView = button
                isFirstTimeLoadAnnotition = false
            } else {
                result = MKAnnotationView(annotation: annotation, reuseIdentifier: resultID)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
                imageView.image = #imageLiteral(resourceName: "shark")
                result?.leftCalloutAccessoryView = imageView
                result?.canShowCallout = true
                result?.image = #imageLiteral(resourceName: "buoy").resize(newSize: CGSize(width: 30.0, height: 30.0))
            }
        } else {
            //Use exist one!
            result?.annotation = annotation
        }
        
        return result
        
    }
}
//MARK: UIPopoverPresentationControllerDelegate
extension MapViewController: UIPopoverPresentationControllerDelegate{
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
