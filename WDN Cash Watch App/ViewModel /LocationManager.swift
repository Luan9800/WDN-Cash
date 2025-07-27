import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var currencyCode: String? = "BRL"
    @Published var locationError: String?
    @Published var countryName: String? = nil
    @Published var countryColors: [Color] = [.blue] 

    private let countryToCurrency: [String: String] = [
        "BR": "BRL",
        "US": "USD",
        "EU": "EUR",
        "GB": "GBP",
        "JP": "JPY",
        "CA": "CAD",
        "AU": "AUD",
        "CN": "CNY",
        "IN": "INR",
        "MX": "MXN"
    ]

    private let countryColorThemes: [String: [Color]] = [
        "BR": [.green, .yellow, .blue],
        "US": [.red, .white, .blue],
        "JP": [.white, .red],
        "GB": [.red, .white, .blue],
        "FR": [.blue, .white, .red],
        "IT": [.green, .white, .red],
        "DE": [.black, .red, .yellow],
        "IN": [.orange, .white, .green],
        "CA": [.red, .white],
        "CN": [.red, .yellow],
        "MX": [.green, .white, .red],
        "AU": [.green, .yellow],
        "EU": [.blue, .yellow]
    ]

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationError = nil
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = "Localização desativada. Use o seletor de moedas."
            currencyCode = "BRL"
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            locationError = "Erro desconhecido de localização."
            currencyCode = "BRL"
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.locationError = "Erro ao obter localização: \(error.localizedDescription)"
                self.currencyCode = "BRL"
                return
            }

            if let placemark = placemarks?.first {
                let countryCode = placemark.isoCountryCode ?? "BR"
                let currency = self.countryToCurrency[countryCode] ?? "BRL"
                self.currencyCode = currency
                self.countryName = placemark.country

                // Aplica o tema de cores baseado no país
                self.countryColors = self.countryColorThemes[countryCode] ?? [.blue]
            } else {
                self.locationError = "Não foi possível identificar o país."
                self.currencyCode = "BRL"
                self.countryName = "Brasil"
                self.countryColors = [.blue]
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            locationError = "Localização desativada. Use o seletor de moedas."
            currencyCode = "BRL"
        }
    }
}
