//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Puf, Roxana on 15/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import UIKit
import RealmSwift

protocol LocationDetailsProtocol {
    func updateLocationChanges()
}

class LocationDetailsViewController: ViewController {
    
    var location : Location? {
        didSet {
            if let image = location?.img {
                locationImage.downloaded(from: image)
            }
            locationName.text = location?.name
            locationAddress.text = location?.address
            if let lat = location?.latitude, let lon = location?.longitude {
                locationLatitude.text = "Latitude: \(String(describing: lat))"
                locationLongitude.text = "Longitude: \(String(describing: lon))"
            }
        }
    }
    var isEditable = false
    var isAddingNewLocation = false
    
    var delegate: LocationDetailsProtocol!
    
    private let locationImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let imageAddress : UITextField = {
        let textField = UITextField()
        textField.placeholder = "New location image adrress link"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let locationName : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location name"
        textField.textColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let locationAddress : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location address"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let locationLatitude: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location latitude"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let locationLongitude: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location longitude"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1)
        btn.setTitle("Save changes", for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 235/255, green: 96/255, blue: 91/255, alpha: 1).cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    convenience init(editable: Bool, newLocation: Bool) {
        self.init()
        isEditable = editable
        isAddingNewLocation = newLocation
    }

    override func loadView() {
        
        super.loadView()
        
        view = UIView()
        view.backgroundColor = .white

        view.addSubview(locationImage)
        view.addSubview(locationName)
        view.addSubview(locationAddress)
        view.addSubview(locationLatitude)
        view.addSubview(locationLongitude)
        view.addSubview(saveButton)
        
        locationName.isUserInteractionEnabled = isEditable || isAddingNewLocation
        locationAddress.isUserInteractionEnabled = isEditable || isAddingNewLocation
        locationLatitude.isUserInteractionEnabled = isEditable || isAddingNewLocation
        locationLongitude.isUserInteractionEnabled = isEditable || isAddingNewLocation
        saveButton.isUserInteractionEnabled = isEditable || isAddingNewLocation
        
        if isEditable || isAddingNewLocation {
            view.addSubview(imageAddress)
            saveButton.isHidden = false
            setupEditableTextFields([imageAddress, locationName, locationAddress, locationLatitude, locationLongitude])
        }
        setupConstraints()
    }
    
    func setupEditableTextFields(_ textFields: [UITextField]) {
        for textField in textFields {
            textField.borderStyle = .none
            textField.layer.backgroundColor = UIColor.white.cgColor
            textField.layer.masksToBounds = false
            textField.layer.shadowColor = UIColor.gray.cgColor
            textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            textField.layer.shadowOpacity = 1.0
            textField.layer.shadowRadius = 0.0
            
            textField.delegate = self
        }
        textFields[1].becomeFirstResponder()
    }
    
    func setupConstraints() {
        
        if isEditable || isAddingNewLocation {
            let imageConstraints:[NSLayoutConstraint] = [
                imageAddress.bottomAnchor.constraint(equalTo: locationName.topAnchor, constant: -20),
                imageAddress.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                imageAddress.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
            ]
            NSLayoutConstraint.activate(imageConstraints)
        }
        
        let constraints:[NSLayoutConstraint] = [
            locationImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            locationImage.heightAnchor.constraint(equalTo: view.widthAnchor),
            locationImage.topAnchor.constraint(equalTo: view.topAnchor),

            locationName.topAnchor.constraint(equalTo: locationImage.bottomAnchor, constant: 20),
            locationName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationName.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),

            locationAddress.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 10),
            locationAddress.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationAddress.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),

            locationLatitude.topAnchor.constraint(equalTo: locationAddress.bottomAnchor, constant: 20),
            locationLatitude.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationLatitude.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),

            locationLongitude.topAnchor.constraint(equalTo: locationLatitude.bottomAnchor, constant: 10),
            locationLongitude.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationLongitude.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            saveButton.topAnchor.constraint(equalTo: locationLongitude.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func saveChanges(sender: UIButton!) {
        if isAddingNewLocation {
            if textFieldsNotEmpty([locationName, locationAddress, locationLatitude, locationLongitude]) {
                saveLocation(newLocation())
                self.dismiss(animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Oops!", message: "Some of the fields are empty.\n Please enter data for you new location.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if let updatedLocation = location {
                updateLocation(updatedLocation)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func newLocation() -> Location {
        let newLocation = Location()
        if let imageLink = self.imageAddress.text {
            newLocation.img = imageLink
        }
        if let name = self.locationName.text {
            newLocation.id = name
            newLocation.name = name
        }
        if let address = self.locationAddress.text {
            newLocation.address = address
        }
        if let lat = self.locationLatitude.text{
            if let latitude = Double(lat) {
                newLocation.latitude = latitude
            }
        }
        if let lon = self.locationLongitude.text {
            if let longitude = Double(lon) {
                newLocation.longitude = longitude
            }
        }
        return newLocation
    }
    
    func saveLocation(_ location: Location) {
        realmManager.add(location)
        updateData()
    }
    
    func updateLocation(_ location: Location) {
        realmManager.update {
            if let image = self.imageAddress.text {
                location.img = image
            }
            if let name = self.locationName.text {
                location.name = name
            }
            if let address = self.locationAddress.text {
                location.address = address
            }
            if let latitude = Double(self.locationLatitude.text!) {
                location.latitude = latitude
            }
            if let longitude = Double(self.locationLatitude.text!){
                location.longitude = longitude
            }
        }
        updateData()
    }
    
    func updateData() {
        if let delegate = delegate {
            delegate.updateLocationChanges()
        }
    }
}

extension LocationDetailsViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldsNotEmpty(_ textFields: [UITextField]) -> Bool {
        return textFields.allSatisfy { $0.text?.isEmpty == false }
    }
}
