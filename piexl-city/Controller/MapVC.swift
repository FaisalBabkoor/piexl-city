//
//  MapVC.swift
//  piexl-city
//
//  Created by Faisal Babkoor on 8/22/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit
import CoreLocation


let cellidentifier = "cellPhoto"

class MapVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //variable
    var locationManager = CLLocationManager()
    var authorizationStatus = CLLocationManager.authorizationStatus()
    let regionInMeters: Double = 10000
    var collectionView: UICollectionView?
    let layout = UICollectionViewFlowLayout()
    var photos = [Photo]()
    var imageArray = [UIImage]()
    let spinner: UIActivityIndicatorView = {
       let sp = UIActivityIndicatorView(style: .whiteLarge)
        sp.translatesAutoresizingMaskIntoConstraints = false
        sp.color = #colorLiteral(red: 0.9647058824, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        return sp
    }()
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.darkGray
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        return lbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        addDoubleTap()
        addSwipe()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: cellidentifier)
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        pullUpView.addSubview(collectionView!)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.invalidateLayout()
        setupLayout()
        registerForPreviewing(with: self, sourceView: collectionView!)
        
    }
    @IBAction func centerBtnPressed(_ sender: Any) {
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
    func setupLayout(){
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: pullUpView.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: pullUpView.trailingAnchor).isActive = true
        collectionView?.heightAnchor.constraint(equalToConstant: 280).isActive = true
        collectionView?.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
        spinner.centerYAnchor.constraint(equalTo: (collectionView?.centerYAnchor)!).isActive = true
        collectionView?.addSubview(descriptionLbl)
        descriptionLbl.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 5).isActive = true
        descriptionLbl.leftAnchor.constraint(equalTo: pullUpView.leftAnchor, constant: 10).isActive = true
        descriptionLbl.rightAnchor.constraint(equalTo: pullUpView.rightAnchor, constant: 10).isActive = true
        descriptionLbl.heightAnchor.constraint(equalToConstant: 80).isActive = true

    }
    
    func addDoubleTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapVC.dropPin(sender:)))
        tap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(tap)
    }
    
    func addSwipe(){
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(MapVC.animateViewDown(sender:)))
        swip.direction = .down
        pullUpView.addGestureRecognizer(swip)
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else {return}
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    

    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAutoraizaionServices()
        }else{
            let alert = UIAlertController(title: "Maker sure lciation service Enablet", message: "make sure location Services Enabled", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
    }
    
    func checkLocationAutoraizaionServices(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        case .restricted:
            break
        }
    }
    
    func animateViewUp(){
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.heightConstraint.constant = 300
        }, completion: nil)
    }
    
    @objc func animateViewDown(sender: UISwipeGestureRecognizer){
        UIView.animate(withDuration: 0.3) {
            self.pullUpView.alpha = 0.3
            self.heightConstraint.constant = 0
        }
        self.pullUpView.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as? PhotoCell{
            cell.imageView.image = imageArray[indexPath.item] 
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let storyboard = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC{
            storyboard.passedImage = imageArray[indexPath.row]
            storyboard.photo = photos[indexPath.item]
            storyboard.centerCoordinate = mapView.centerCoordinate

            present(storyboard, animated: true, completion: nil)
        }
    }
    
    func getPhotoByLocation(droppablePin: DroppablePin, compleition: @escaping (_ finshed: Bool) -> ()){
        let url = getFlickerURL(forApiKey: api_key, withAnnotation: droppablePin)
        Alamofire.request(url).responseJSON { (response) in
            DispatchQueue.global(qos: .userInteractive).async {
                if response.result.error == nil{
                    if let dict = response.result.value as? Dictionary<String, Any>{
                        if let photos = dict["photos"] as? Dictionary<String, Any>{
                            if let photo = photos["photo"] as? [Dictionary<String, Any>]{
                                for photoInfo in photo{
                                    let farm = photoInfo["farm"] as! Int
                                    let id = photoInfo["id"] as! String
                                    let owner = photoInfo["owner"] as! String
                                    let server = photoInfo["server"] as! String
                                    let title = photoInfo["title"] as! String
                                    let secret = photoInfo["secret"] as! String
                                    let urlPhoto = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
                                    self.photos.append(Photo.init(title: title, urlPhoto: urlPhoto , owner: owner))
                                }
                                
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()

                }
                compleition(true)
            }
        }
    }
    
    func downloadImage(compleition: @escaping (_ finshed: Bool) -> ()){
        for photo in photos{
            Alamofire.request(photo.urlPhoto).responseImage { (response) in
                if response.result.error == nil{
                    if let photo = response.result.value{
                        self.imageArray.append(photo)
                        self.collectionView?.reloadData()
                    }
                }
                if self.photos.count == self.imageArray.count{
                    compleition(true)
                    
                }
            }
        }
  
    }
    
    func cancelAllSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (data, upload, download) in
            data.forEach({$0.cancel()})
            download.forEach({$0.cancel()})

        }
    }
    
    
    
    
    
    
    
}

extension MapVC: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutoraizaionServices()
    }
}

extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "dp")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    @objc func dropPin(sender: UITapGestureRecognizer){
        cancelAllSession()
        imageArray = []
        photos = []
        descriptionLbl.text = ""
        collectionView?.reloadData()
        mapView.removeAnnotations(mapView.annotations)
        spinner.startAnimating()
        animateViewUp()
        self.descriptionLbl.text = "downloading..."

        
        let location = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let center = CLLocationCoordinate2D(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        let anno = DroppablePin(coordinate: touchCoordinate, identifier: "dp")
        mapView.addAnnotation(anno)
        mapView.setRegion(region, animated: true)
        getPhotoByLocation(droppablePin: anno) { (success) in
            if success{
                self.downloadImage(compleition: { (success) in
                    if success{
                        DispatchQueue.main.async {
                            self.descriptionLbl.text = ""
                            self.collectionView?.reloadData()
                            self.spinner.stopAnimating()

                        }
                    }
                })
            
            }
          

        }
    }
    
}

extension MapVC: UIViewControllerPreviewingDelegate{
    
  
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let index = collectionView?.indexPathForItem(at: location) else {return nil}
        guard let cell = collectionView?.cellForItem(at: index) else {return nil}
        if let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC{
           popVC.passedImage = imageArray[index.item]
            previewingContext.sourceRect = cell.contentView.bounds
            return popVC
        }else{
            return UIViewController()
        }
    
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}




