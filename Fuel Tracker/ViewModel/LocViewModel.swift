//
//  LocViewModel.swift
//  Fuel Tracker
//
//  Created by Meder iZimov on 3/19/23.
//

import Combine
import Contacts
import CoreLocation

class LocViewModel: ObservableObject {
    
    @Published var addressLine : String?
    
     func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            let lon: Double = Double("\(pdblLongitude)")!
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        {(placemarks, error) in
                DispatchQueue.main.async {
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    if placemarks != nil {
                        let pm = placemarks! as [CLPlacemark]
                        
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            var addressString : String = ""
                            
                            if pm.locality != nil {
                                addressString = addressString + pm.locality! + ", "
                            }
                            if pm.administrativeArea != nil {
                                addressString = addressString + pm.administrativeArea! + ", "
                            }
                            if pm.country != nil {
                                addressString = addressString + pm.country!
                            }
                            print ("AddressString in CH: \(addressString)")
                            self.addressLine = addressString
                            
                        }
                        print ("AddressString after CH: \(self.addressLine ?? "Unknown")")
                    } else {return}
                }
            })
         return addressLine ?? "Please enter a city name!"
        }
}
