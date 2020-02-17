//
//  LocationCell.swift
//  MyLocations
//
//  Created by Puf, Roxana on 15/02/2020.
//  Copyright © 2020 Puf, Roxana. All rights reserved.
//

import UIKit
import CoreLocation

class LocationCell : UITableViewCell {
    
    var topInset = CGFloat(0)
    var bottomInset = CGFloat(0)
    
    var location: Location? {
        didSet {
            if let image = location?.img {
                locationImage.downloaded(from: image)
            }
            locationName.text = location?.name
            locationDescription.text = String(format: "Air Distance: %.2f meters", airDistance())
        }
    }
    
    private let locationName : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let locationDescription: UILabel = {
        let location: CLLocation = CLLocation(latitude: 45.5, longitude: 45.5)
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
        
    private let locationImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(locationImage)
        addSubview(locationName)
        addSubview(locationDescription)
                
        addContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationImage.image = nil
        locationName.text = nil
        locationDescription.text = nil
    }
    
    func addContraints() {

        NSLayoutConstraint.activate([
            locationImage.topAnchor.constraint(equalTo: topAnchor),
            locationImage.leftAnchor.constraint(equalTo: leftAnchor),
            locationImage.heightAnchor.constraint(equalToConstant: 90),
            locationImage.widthAnchor.constraint(equalToConstant: 90),

            locationName.topAnchor.constraint(equalTo: topAnchor),
            locationName.leftAnchor.constraint(equalTo: locationImage.rightAnchor, constant: 5),
            locationName.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            
            locationDescription.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 5),
            locationDescription.leftAnchor.constraint(equalTo: locationImage.rightAnchor, constant: 5),
            locationDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
            
        ])
        
    }
    
    func airDistance() -> Double {
        guard let currentLocation = LocationManager.sharedManager.currentLocation,
            let lat = location?.latitude,
            let lon = location?.longitude else { return 0.0 }
        
        let loc = CLLocation(latitude: lat, longitude: lon)

        return currentLocation.distance(from: loc)
    }

}
