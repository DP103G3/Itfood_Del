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
    var status: String? {
        selectedOrder?["status"] as? String
    }
    
    
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
            resetMap(mapView: view)
            let directions = self.getDirections(status: status!)
            self.setAnnotationsAndPolyline(mapView: view, directions: directions)
        } else {
            resetMap(mapView: view)
        }
        //        view.setRegion(region, animated: true)
    }
    
    func getDirections(status: String) -> MKDirections{
        let request = MKDirections.Request()
        let mapItems = getOrderMapItems(order: selectedOrder!["order"] as! Order, status: status)
        var sourceMapItem = MKMapItem()
        if status == OrderStatus.queueing.rawValue {
            sourceMapItem = mapItems["shop"]!
        } else if (status == OrderStatus.deliveringShop.rawValue) || (status == OrderStatus.deliveryingMember.rawValue) {
            sourceMapItem = mapItems["currentPosition"]!
        }
        let destinationMapItem = mapItems["destination"]
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        return directions
    }
    
    enum OrderStatus: String {
        case queueing = "queueing"
        case deliveringShop = "deliveringShop"
        case deliveryingMember = "deliveringMember"
    }
    
    
    func setAnnotationsAndPolyline (mapView : MKMapView, directions: MKDirections, completion: (() -> Swift.Void)? = nil) {
        
        //        print(request.source?.description)
        //        print(request.destination?.description)
        directions.calculate { (direct, error) in
            if error != nil {
                print (error?.localizedDescription ?? "Unknown error")
                return
            }
            let sourceAnnotation = MKPointAnnotation()
            let destinationAnnotation = MKPointAnnotation()
            let order = self.selectedOrder!["order"] as! Order
            sourceAnnotation.coordinate = (direct?.source.placemark.coordinate)!
            sourceAnnotation.title = direct?.source.placemark.name
            destinationAnnotation.coordinate = (direct?.destination.placemark.coordinate)!
            destinationAnnotation.title = direct?.destination.placemark.name
            
            if self.status == OrderStatus.queueing.rawValue {
                sourceAnnotation.subtitle = order.shop.address
                mapView.addAnnotations([sourceAnnotation, destinationAnnotation])
            } else if self.status == OrderStatus.deliveringShop.rawValue {
                destinationAnnotation.subtitle = order.shop.address
                mapView.addAnnotations([destinationAnnotation])
            } else if self.status == OrderStatus.deliveryingMember.rawValue {
                destinationAnnotation.title = order.address!.info
                mapView.addAnnotations([destinationAnnotation])
            }
            
            
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
    
    func getOrderMapItems (order: Order, status: String) -> [String: MKMapItem]{
        var mapItems = [String: MKMapItem]()
        if status == OrderStatus.queueing.rawValue {
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
            mapItems["shop"] = shopMapItem
            
            var destinationMapItem = MKMapItem()
            let destinationLat = order.address?.latitude ?? 0
            let destinationLong = order.address?.longitude ?? 0
            let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
            let destinationName = order.address?.info ?? ""
            let destinationPhone = order.order_phone
            destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
            destinationMapItem.name = destinationName
            destinationMapItem.phoneNumber = destinationPhone
            mapItems["destination"] = destinationMapItem
            
        } else if status == OrderStatus.deliveringShop.rawValue {
            var currentMapItem = MKMapItem()
            let currentLat = Double(self.userLatitude)
            let currentLong = Double(self.userLongitude)
            let currentCoordinate = CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong!)
            let currentPlaceMark = MKPlacemark(coordinate: currentCoordinate)
            currentMapItem = MKMapItem(placemark: currentPlaceMark)
            let currentName = "我的位置"
            currentMapItem.name = currentName
            mapItems["currentPosition"] = currentMapItem
            
            var destinationMapItem = MKMapItem()
            let destinationLat = order.shop.latitude
            let destinationLong = order.shop.longitude
            let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
            let destinationName = order.shop.name
            let destinationPhone = order.shop.phone
            destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
            destinationMapItem.name = destinationName
            destinationMapItem.phoneNumber = destinationPhone
            mapItems["destination"] = destinationMapItem
        } else if status == OrderStatus.deliveryingMember.rawValue {
            var currentMapItem = MKMapItem()
            let currentLat = Double(self.userLatitude)
            let currentLong = Double(self.userLongitude)
            let currentCoordinate = CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong!)
            let currentPlaceMark = MKPlacemark(coordinate: currentCoordinate)
            currentMapItem = MKMapItem(placemark: currentPlaceMark)
            let currentName = "我的位置"
            currentMapItem.name = currentName
            mapItems["currentPosition"] = currentMapItem
            
            var destinationMapItem = MKMapItem()
            let destinationLat = order.address?.latitude ?? 0 
            let destinationLong = order.address?.longitude ?? 0
            let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinate)
            let destinationName = order.address?.info
            let destinationPhone = order.order_phone
            destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
            destinationMapItem.name = destinationName
            destinationMapItem.phoneNumber = destinationPhone
            mapItems["destination"] = destinationMapItem
        }
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
    
    func resetMap(mapView: MKMapView){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
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
