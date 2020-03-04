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
    @EnvironmentObject var orderItemViewModel: OrderItemViewModel
    var followUser: Int
    var selectedOrder: [String: Any]?
    
    
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
        //        mapView.userTrackingMode = .followWithHeading
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        
        //        let directions = getDirections()
        //        setAnnotations(mapView: mapView, directions: directions)
        
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        view.delegate = context.coordinator
        if followUser % 1 == 0 {
            //            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            //            let region = MKCoordinateRegion(center: locationManager.lastLocation!.coordinate, span: span)
            //            view.setRegion(region, animated: true)
            view.setUserTrackingMode(.followWithHeading, animated: true)
            orderItemViewModel.selectedOrder.removeAll()
            //            userData.followUser = false
        }
        
        if (selectedOrder?["selected"] as? Bool ?? false){
            view.removeAnnotations(view.annotations)
            view.removeOverlays(view.overlays)
            print("mapview function")
            let directions = self.getDirections()
            self.setAnnotationsAndPolyline(mapView: view, directions: directions)
        } else {
            view.removeAnnotations(view.annotations)
            view.removeOverlays(view.overlays)
            view.setUserTrackingMode(.followWithHeading, animated: true)
        }
        
        
        
        
        
        //        view.setRegion(region, animated: true)
    }
    
    func getDirections() -> MKDirections{
        let request = MKDirections.Request()
        let mapItems = getOrderMapItems(order: selectedOrder!["order"] as! Order)
        let shopMapItem = mapItems["shop"]
        let destinationMapItem = mapItems["destination"]
        request.source = shopMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        return directions
    }
    
    
    func setAnnotationsAndPolyline (mapView : MKMapView, directions: MKDirections, completion: (() -> Swift.Void)? = nil) {
        
        //        print(request.source?.description)
        //        print(request.destination?.description)
        directions.calculate { (direct, error) in
            if error != nil {
                print (error?.localizedDescription ?? "Unknown error")
                return
            }
            let shopAnnotation = MKPointAnnotation()
            shopAnnotation.coordinate = (direct?.source.placemark.coordinate)!
            shopAnnotation.title = direct?.source.placemark.name
            let order = self.selectedOrder!["order"] as! Order
            shopAnnotation.subtitle = order.shop.address
            //            shopAnnotation.imageName()
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = (direct?.destination.placemark.coordinate)!
            destinationAnnotation.title = direct?.destination.placemark.name
            mapView.addAnnotations([shopAnnotation, destinationAnnotation])
            
            let polyline = direct?.routes.first?.polyline
            mapView.addOverlay(polyline!)
            let rect = polyline!.boundingMapRect
            var origin = rect.origin
            let size = MKMapSize(width: rect.width * 1.4, height: rect.height * 1.4)
            let deltaX = rect.width - size.width
            let deltaY = rect.height - size.height
            origin.x = origin.x + deltaX / 2
            origin.y = origin.y + deltaY / 2
            let newRect = MKMapRect(origin: origin, size: size)
            
            mapView.setRegion(MKCoordinateRegion(newRect), animated: true)
            
            //            print(polyline)
        }
    }
    
    func getOrderMapItems (order: Order) -> [String: MKMapItem]{
        var shopMapItem = MKMapItem()
        let shopLat = order.shop.latitude
        let shopLong = order.shop.longitude
        let shopCoordinate = CLLocationCoordinate2D(latitude: shopLat, longitude: shopLong)
        let shopPlaceMark = MKPlacemark(coordinate: shopCoordinate)
        shopMapItem = MKMapItem(placemark: shopPlaceMark)
        let shopName = order.shop.name
        let shopPhone = order.shop.phone
        shopMapItem.name = shopName
        shopMapItem.phoneNumber = shopPhone
        var mapItems =  [String: MKMapItem]()
        mapItems["shop"] = shopMapItem
        
        var destinationMapItem = MKMapItem()
        let destinationLat = order.address.latitude
        let destinationLong = order.address.longitude
        let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
        let destinationName = order.address.info
        let destinationPhone = order.order_phone
        destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        destinationMapItem.name = destinationName
        destinationMapItem.phoneNumber = destinationPhone
        mapItems["destination"] = destinationMapItem
        
        return mapItems
    }
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
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let start = mapView.userLocation.coordinate
            let end = view.annotation!
            direct(start: start, end: end)
        }
        
        func direct(start: CLLocationCoordinate2D, end: MKAnnotation) {
            let placemark_start = MKPlacemark(coordinate: start, addressDictionary: nil)
            let placemark_end = MKPlacemark(coordinate: end.coordinate, addressDictionary: nil)
            
            let mapItem_start = MKMapItem(placemark: placemark_start)
            let mapItem_end = MKMapItem(placemark: placemark_end)
            
            mapItem_start.name = "我的位置"
            let name = end.title!
            mapItem_end.name = name
            
            let mapItems = [mapItem_start, mapItem_end]
            /* 設定導航模式：開車、走路、搭車 */
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: mapItems, launchOptions: options)
        }
    }
    
    
}



//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
