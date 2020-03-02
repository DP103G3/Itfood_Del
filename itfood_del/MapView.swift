//
//  MapView.swift
//  itfood_del
//
//  Created by 徐承維 on 2020/2/26.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable{
    @EnvironmentObject var locationManager : LocationManager
    @EnvironmentObject var userData : UserData
    var followUser: Bool
    //    var order : Order
    
    
    //藉由EnviromentObejct locatioManager 取得使用者現在位置的經緯度
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: locationManager.lastLocation!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        //        let directions = getDirections()
        //        setAnnotations(mapView: mapView, directions: directions)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        view.delegate = context.coordinator
        //        view.userTrackingMode = .followWithHeading
        if followUser {
//            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//            let region = MKCoordinateRegion(center: locationManager.lastLocation!.coordinate, span: span)
//            view.setRegion(region, animated: true)
            view.userTrackingMode = .followWithHeading
            userData.followUser = false
        }
        
        
        
        //        let directions = getDirections()
        //        setPolyline(mapView: view, directions: directions)
        
        
        //        view.setRegion(region, animated: true)
    }
    
    //    func getDirections() -> MKDirections{
    //        let request = MKDirections.Request()
    //        let shopMapItem = getShopMapItem()
    //        let destinationMapItem = getDestinationMapItem()
    //        request.source = shopMapItem
    //        request.destination = destinationMapItem
    //        request.transportType = .automobile
    //        let directions = MKDirections(request: request)
    //        return directions
    //    }
    
    
    //    func setAnnotations (mapView : MKMapView, directions: MKDirections) {
    //
    //        //        print(request.source?.description)
    //        //        print(request.destination?.description)
    //        directions.calculate { (direct, error) in
    //            if error != nil {
    //                print (error?.localizedDescription ?? "Unknown error")
    //                return
    //            }
    //            let shopAnnotation = MKPointAnnotation()
    //            shopAnnotation.coordinate = (direct?.source.placemark.coordinate)!
    //            shopAnnotation.title = direct?.source.placemark.name
    //            //            shopAnnotation.imageName()
    //
    //            let destinationAnnotation = MKPointAnnotation()
    //            destinationAnnotation.coordinate = (direct?.destination.placemark.coordinate)!
    //            destinationAnnotation.title = direct?.destination.placemark.name
    //            mapView.addAnnotations([shopAnnotation, destinationAnnotation])
    //            //            print(polyline)
    //        }
    //    }
    //    func setPolyline(mapView: MKMapView, directions: MKDirections){
    //        directions.calculate { (direct, error) in
    //            let polyline = direct?.routes.first?.polyline
    //            mapView.addOverlay(polyline!)
    //            let rect = polyline!.boundingMapRect
    //            var origin = rect.origin
    //            let size = MKMapSize(width: rect.width * 1.4, height: rect.height * 1.4)
    //            let deltaX = rect.width - size.width
    //            let deltaY = rect.height - size.height
    //            origin.x = origin.x + deltaX / 2
    //            origin.y = origin.y + deltaY / 2
    //            let newRect = MKMapRect(origin: origin, size: size)
    //
    //            mapView.setRegion(MKCoordinateRegion(newRect), animated: true)
    //        }
    //
    //    }
    
    //    func getShopMapItem () -> MKMapItem{
    //        var mapItem = MKMapItem()
    //        let shopLat = order.shop.latitude
    //        let shopLong = order.shop.longitude
    //
    //        let coordinate = CLLocationCoordinate2D(latitude: shopLat, longitude: shopLong)
    //        let placeMark = MKPlacemark(coordinate: coordinate)
    //        mapItem = MKMapItem(placemark: placeMark)
    //        let name = order.shop.name
    //        let phone = order.shop.phone
    //        mapItem.name = name
    //        mapItem.phoneNumber = phone
    //
    //
    //        return mapItem
    //    }
    //
    //    func getDestinationMapItem () -> MKMapItem {
    //        var mapItem = MKMapItem()
    //        let lat = order.address.latitude
    //        let long = order.address.longitude
    //        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    //        let placeMark = MKPlacemark(coordinate: coordinate)
    //        mapItem = MKMapItem(placemark: placeMark)
    //        let name = order.address.info
    //        mapItem.name = name
    //
    //        return mapItem
    //    }
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        var mapViewController: MapView
        var annotation : MKAnnotation?
        
        init(_ control: MapView) {
            self.mapViewController = control
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            self.annotation = annotation
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotation .isKind(of: MKPointAnnotation.self) {
                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    let button = UIButton(type: .detailDisclosure)
                    annotationView?.rightCalloutAccessoryView = button
                } else {
                    annotationView?.annotation = annotation
                    
                }
                
                
                return annotationView
            } else {
                return nil
            }
        }
    }
    
    
}



//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
