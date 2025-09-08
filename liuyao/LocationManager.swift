import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var currentCity: String = "定位中..."
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000 // 1公里更新一次
    }
    
    func requestLocation() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            locationError = "定位权限被拒绝"
            currentCity = "无法定位"
        @unknown default:
            break
        }
    }
    
    private func geocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.locationError = "地址解析失败"
                    self?.currentCity = "定位失败"
                    return
                }
                
                if let placemark = placemarks?.first {
                    // 优先显示市级行政区
                    if let city = placemark.locality {
                        self?.currentCity = city
                    } else if let administrativeArea = placemark.administrativeArea {
                        self?.currentCity = administrativeArea
                    } else if let country = placemark.country {
                        self?.currentCity = country
                    } else {
                        self?.currentCity = "未知地区"
                    }
                    self?.locationError = nil
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        geocodeLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = "定位失败: \(error.localizedDescription)"
            self.currentCity = "定位失败"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            case .denied, .restricted:
                self.locationError = "定位权限被拒绝"
                self.currentCity = "无法定位"
            case .notDetermined:
                self.currentCity = "等待授权..."
            @unknown default:
                break
            }
        }
    }
}