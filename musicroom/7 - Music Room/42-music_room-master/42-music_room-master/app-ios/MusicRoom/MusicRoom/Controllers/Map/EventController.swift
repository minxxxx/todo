//
//  EventController.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/15/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventController: UIViewController , UINavigationControllerDelegate, UIScrollViewDelegate{
    
    let imagePicker = UIImagePickerController()
    var resultSearchController:UISearchController? = nil
    var searchBar : UISearchBar?
    var urlImageToString : URL?
    var locationManager : CLLocationManager?
    var selectedPin:MKPlacemark? = nil
    var scrollView : UIScrollView? = nil
    var playlistView : PlaylistCollectionView?
    
    let titleTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.gray
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Event name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let datePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = UIColor.gray
        dp.datePickerMode = UIDatePickerMode.dateAndTime
        dp.minimumDate = Date()
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let segmentedBar : UISegmentedControl = {
        let items = ["Public", "Private"]
        let sb = UISegmentedControl(items: items)
        sb.selectedSegmentIndex = 0
        sb.layer.cornerRadius = 8
        sb.backgroundColor = UIColor.gray
        sb.tintColor = UIColor.white
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Description :"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTV : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tv.textAlignment = .center
        tv.backgroundColor = UIColor.gray
        tv.textColor = .white
        tv.layer.cornerRadius = 8
        tv.isEditable = true
        tv.returnKeyType = .done
        tv.enablesReturnKeyAutomatically = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

   var localizeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "Localize this event (optional)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let localizeTF : UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.gray
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.returnKeyType = .done
        tf.enablesReturnKeyAutomatically = true
        tf.attributedPlaceholder = NSAttributedString(string: "Distance in km", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let mapView : MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.backgroundColor = UIColor.gray
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.delegate = self
        descriptionTV.delegate = self
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView!.delegate = self
        scrollView!.alwaysBounceVertical = true
        scrollView?.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 1355, right: 0)
        self.view.addSubview(scrollView!)
        imagePicker.delegate = self
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Create", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        setupView()
        apiManager.getPlaylists(completion: { (res) in
            self.playlistView?.eventCreation = true
            guard let myPlaylists = res.myPlaylists else { return }
            self.playlistView!.myPlaylists = myPlaylists
            self.playlistView!.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    

    func setupView() {
        let button = UIButton(type: .roundedRect)
        button.titleEdgeInsets = UIEdgeInsets(top: -10,left: -10,bottom: -10,right: -10)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 8
        button.setAttributedTitle(NSAttributedString(string: "Add a picture", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        button.addTarget(self, action: #selector(handleSelectProfileImage), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        playlistView = PlaylistCollectionView([], .horizontal, nil)
        playlistView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.addSubview(imageView)
        scrollView!.addSubview(titleTF)
        scrollView!.addSubview(segmentedBar)
        scrollView!.addSubview(button)
        scrollView!.addSubview(datePicker)
        scrollView!.addSubview(descriptionTV)
        scrollView!.addSubview(playlistView!)
        scrollView!.addSubview(descriptionLabel)
        scrollView!.addSubview(localizeLabel)
        scrollView!.addSubview(localizeTF)
        
        NSLayoutConstraint.activate([
            
            titleTF.topAnchor.constraint(equalTo: scrollView!.topAnchor, constant: 20),
            titleTF.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            titleTF.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            button.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            
            imageView.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            imageView.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            imageView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            
            
            segmentedBar.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            segmentedBar.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            segmentedBar.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            localizeLabel.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            localizeLabel.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            localizeLabel.topAnchor.constraint(equalTo: segmentedBar.bottomAnchor, constant: 20),
            
            localizeTF.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            localizeTF.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            localizeTF.topAnchor.constraint(equalTo: localizeLabel.bottomAnchor, constant: 20),
            
            
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: localizeTF.bottomAnchor, constant: 20),
            
            descriptionTV.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            descriptionTV.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            descriptionTV.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTV.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6),
            
            datePicker.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            datePicker.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: descriptionTV.bottomAnchor, constant: 20),
            datePicker.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier : 0.6),
            
            playlistView!.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30),
            playlistView!.widthAnchor.constraint(equalTo: scrollView!.widthAnchor, multiplier: 0.9),
            playlistView!.centerXAnchor.constraint(equalTo: scrollView!.centerXAnchor),
            playlistView!.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func imagePick() {
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("not allowed")
        }
    }
    
    @objc func createEvent() {
        var distance_required = false
        let vc = self.navigationController?.viewControllers[0] as! MapController
        guard let _ = selectedPin, let _ = selectedPin?.coordinate, let _ = selectedPin?.coordinate.latitude, let _ = selectedPin?.coordinate.longitude, let _ = selectedPin?.administrativeArea, let _ = selectedPin?.locality, let _ = selectedPin?.isoCountryCode, let _ = selectedPin?.thoroughfare, let _ = selectedPin?.subThoroughfare else {
            self.navigationController?.popViewController(animated: true)
            ToastView.shared.short(vc.view, txt_msg: "Can't create an event here", color: UIColor.red)
            return
        }
        if self.segmentedBar.selectedSegmentIndex == 1 {
           distance_required = true
        }
        if titleTF.text != nil && imageView.image != nil && playlistView?.selectedPlaylist != nil {
            let myUser = userManager.currentUser
            let coord = Coord(lat: (selectedPin?.coordinate.latitude)!, lng: (selectedPin?.coordinate.longitude)!)
            let address = Address(p: (selectedPin?.administrativeArea)!, v: (selectedPin?.locality)!, cp: (selectedPin?.isoCountryCode)!, r: (selectedPin?.thoroughfare)!, n: (selectedPin?.subThoroughfare)!)
            let location = Location(address: address, coord: coord)
            apiManager.getMe((myUser?.token)!, completion: { (user) in
                let event = Event(_id : nil, creator : user, title: self.titleTF.text!, description: self.descriptionTV.text!, location: location, hasStarted: false, visibility: self.segmentedBar.selectedSegmentIndex, shared: self.segmentedBar.selectedSegmentIndex == 0 ? true : false , distance_required : distance_required, distance_max: distance_required && self.localizeTF.text != nil && Int(self.localizeTF.text!) != nil ? Int(self.localizeTF.text!) : nil, creationDate: String(describing: Date()), date: String(describing: Date()), playlist: self.playlistView?.selectedPlaylist!, members: [], adminMembers: [], picture : nil)
                apiManager.postEvent((myUser?.token)!, event: event, img: self.imageView.image!) { (resp) in
                    if resp {
                        vc.selectedPin = nil
                        vc.mapView.removeAnnotations(vc.mapView.annotations)
                        vc.printToastMsg()
                        vc.getAllEvents()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        ToastView.shared.short(self.view, txt_msg: "Error while creating your event", color : UIColor.red)
                    }
                }
            })
        }
        else {
            ToastView.shared.short(self.view, txt_msg: "Check twice your information", color : UIColor.red)
        }
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

extension EventController : UIImagePickerControllerDelegate {
    @objc func          handleSelectProfileImage()
    {
        let             picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var             selectedImageFromPicker: UIImage!
        
        if let          edit = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = edit
        } else if let   ori = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = ori
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image  = selectedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EventController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EventController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
