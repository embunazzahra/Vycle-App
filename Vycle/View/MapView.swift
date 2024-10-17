//
//  MapView.swift
//  Vycle
//
//  Created by Vincent Senjaya on 14/10/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var locations: [LocationHistory]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        // tiap SLC nyala kasih titik
        var coordinates = [CLLocationCoordinate2D]()
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = "Saved Location"
            annotation.subtitle = "Distance: \(location.distance ?? 0.0) km"
            uiView.addAnnotation(annotation)
            
            coordinates.append(annotation.coordinate)
        }

        if coordinates.count > 1 {
            for i in 1..<coordinates.count {
                let start = coordinates[i - 1]
                let end = coordinates[i]
                context.coordinator.getRoute(from: start, to: end, mapView: uiView)
            }
        }

        if let lastLocation = locations.last {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude), latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // function buat path finding, nyari jalan antara 2 titik
        func getRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, mapView: MKMapView) {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else {
                    print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                mapView.addOverlay(route.polyline)
            }
        }

        // tarik garis
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

