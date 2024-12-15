//
//  DetailViewController.swift
//  MapVieww
//
//  Created by Aslan  on 20.11.2024.
//

import UIKit
import MapKit

class DetailViewController: UIViewController,CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    

    @IBOutlet weak var uiImage: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var mapView2: MKMapView!
    
    var building: Building!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Убедитесь, что building не nil
        if let building = building {
            // Настроим UI с помощью переданных данных
            label1.text = building.name
            label2.text = building.info
            uiImage.image = UIImage(named: building.image)
            
            // Создаем аннотацию на карте
            let coordinate = CLLocationCoordinate2D(latitude: building.lat, longitude: building.long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = building.name
            mapView2.addAnnotation(annotation)
            
            // Центрируем карту на здании
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView2.setRegion(region, animated: true)
        }
        
        // Устанавливаем делегат для карты, чтобы обработать нажатие на аннотацию
        mapView2.delegate = self
    }

        
        // Обработка выбора аннотации на карте
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            // Действия при нажатии на аннотацию (например, показать детали)
            print("Selected annotation: \(annotation.title ?? "No Title")")
        }
    }
    @IBAction func mapSwitch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let mapVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
           
           // Передача координат из текущего здания
           mapVC.destinationCoordinate = CLLocationCoordinate2D(latitude: building.lat, longitude: building.long)
           
           // Переход на экран
           navigationController?.pushViewController(mapVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
