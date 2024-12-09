//
//  ViewController.swift
//  MapVieww
//
//  Created by Aslan  on 20.11.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapview: MKMapView!
    
    var destinationCoordinate: CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocation()
    
    var followMe = false
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Запрашиваем разрешение на использование местоположения пользователя
        locationManager.requestWhenInUseAuthorization()
        
        // delegate нужен для функции didUpdateLocations, которая вызывается при обновлении местоположения (для этого прописали CLLocationManagerDelegate выше)
        locationManager.delegate = self
        
        // Запускаем слежку за пользователем
        locationManager.startUpdatingLocation()
        
        // Настраиваем отслеживания жестов - когда двигается карта вызывается didDragMap
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap))
        
        // UIGestureRecognizerDelegate - чтоб мы могли слушать нажатия пользователя по экрану и отслеживать конкретные жесты
        mapDragRecognizer.delegate = self
        
        // Добавляем наши настройки жестов на карту
        mapview.addGestureRecognizer(mapDragRecognizer)
        
        // ______________ Метка на карте ______________
        // Новые координаты для метки на карте
        let lat:CLLocationDegrees = 37.957666//43.2374454
        let long:CLLocationDegrees = -122.0323133//76.909891
        
        // Создаем координта передавая долготу и широту
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        
        // Задаем коортинаты метке
        anotation.coordinate = location
        // Задаем название метке
        anotation.title = "Title"
        // Задаем описание метке
        anotation.subtitle = "subtitle"
        
        // Добавляем метку на карту
        mapview.addAnnotation(anotation)
        
        // Настраиваем долгое нажатие - добавляем новые метки на карту
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        // минимально 2 секунды
        longPress.minimumPressDuration = 2
        mapview.addGestureRecognizer(longPress)
        
        // MKMapViewDelegate - чтоб отслеживать нажатие на метки на карте (метод didSelect)
        mapview.delegate = self
    }
    // Вызывается каждый раз при изменении местоположения нашего пользователя
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        
        // Если активна функция Follow Me, обновляем область карты
        if followMe {
            let latDelta: CLLocationDegrees = 0.01
            let longDelta: CLLocationDegrees = 0.01
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapview.setRegion(region, animated: true)
        }
        
        // Если есть координаты назначения, строим маршрут
        if let destination = destinationCoordinate {
            showRoute(from: userLocation.coordinate, to: destination)
            destinationCoordinate = nil // Сбрасываем, чтобы маршрут не строился повторно
        }
        
    }
    @IBAction func myLocation(_ sender: Any) {
        followMe = true
    }
    
    // Вызывается когда двигаем карту
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        // Как только начали двигать карту
        if (gestureRecognizer.state == UIGestureRecognizer.State.changed) {
            
            // Говорим не следовать за пользователем
            followMe = false
            
            print("Map drag changed")
        }
    }
    
    // Долгое нажатие на карту - добавляем новые метки
    @objc func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        print("gestureRecognizer")
        
        // Получаем точку нажатия на экране
        let touchPoint = gestureRecognizer.location(in: mapview)
        
        // Конвертируем точку нажатия на экране в координаты пользователя
        let newCoor: CLLocationCoordinate2D = mapview.convert(touchPoint, toCoordinateFrom: mapview)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        anotation.coordinate = newCoor
        
        anotation.title = "Title"
        anotation.subtitle = "subtitle"
        
        mapview.addAnnotation(anotation)
    }
    
    // MARK: -  MapView delegate
    // Вызывается когда нажали на метку на карте
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print(view.annotation?.title)
        
        // Получаем координаты метки
        let location:CLLocation = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        
        // Считаем растояние до метки от нашего пользователя
        let meters:CLLocationDistance = location.distance(from: userLocation)
        distanceLabel.text = String(format: "Distance: %.2f m", meters)
        
        
        // Routing - построение маршрута
        // 1 Координаты начальной точки А и точки B
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        
        // 2 упаковка в Placemark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 3 упаковка в MapItem
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 4 Запрос на построение маршрута
        let directionRequest = MKDirections.Request()
        // указываем точку А, то есть нашего пользователя
        directionRequest.source = sourceMapItem
        // указываем точку B, то есть метку на карте
        directionRequest.destination = destinationMapItem
        // выбираем на чем будем ехать - на машине
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 5 Запускаем просчет маршрута
        directions.calculate {
            (response, error) -> Void in
            
            // Если будет ошибка с маршрутом
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            // Берем первый машрут
            let route = response.routes[0]
            // Удалить все существующие маршруты
            self.mapview.removeOverlays(self.mapview.overlays)
            // Рисуем на карте линию маршрута (polyline)
            self.mapview.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            // Приближаем карту с анимацией в регион всего маршрута
            let rect = route.polyline.boundingMapRect
            self.mapview.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    func showRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("Ошибка построения маршрута: \(error?.localizedDescription ?? "нет данных")")
                return
            }
            
            // Добавляем маршрут на карту
            self.mapview.addOverlay(route.polyline, level: .aboveRoads)
            // Настраиваем видимую область маршрута
            self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Цвет красный
        renderer.strokeColor = UIColor.red
        // Ширина линии
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
}
