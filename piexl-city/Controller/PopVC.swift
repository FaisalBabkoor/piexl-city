//
//  PopVC.swift
//  piexl-city
//
//  Created by Faisal Babkoor on 8/25/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class PopVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var popImageView: UIImageView!
    var passedImage: UIImage!
    var centerCoordinate: CLLocationCoordinate2D!
    var isHide = true
    let regionInMeters: Double = 10000
    var photo: Photo?
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    func centerViewOnUserLocation(){
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let photo = photo else {return}
        self.mapView.isHidden = true
        self.titleLabel.isHidden = true
        self.ownerLbl.isHidden = true
        popImageView.image = passedImage
        popImageView.contentMode = .scaleAspectFill
        ownerLbl.text = "owner: \(photo.owner)"
        titleLabel.text = "Title: \(photo.title)"
        centerViewOnUserLocation()
        addDoubleTap()
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideInfoBtnPressed(_ sender: Any) {
        if isHide{
            self.mapView.isHidden = false
            self.titleLabel.isHidden = false
            self.ownerLbl.isHidden = false
            isHide = !isHide
        }else{
            self.mapView.isHidden = true
            self.titleLabel.isHidden = true
            self.ownerLbl.isHidden = true
        }
    }
}
