//
//  ViewController.swift
//  Locate
//
//  Created by KyawLin on 10/16/17.
//  Copyright © 2017 KyawLin. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {

    @IBOutlet weak var uuidTF: UITextField!
    @IBOutlet weak var majorTF: UITextField!
    @IBOutlet weak var minorTF: UITextField!
    
    var uuid:UUID?
    var major:UInt16?
    var minor:UInt16?
    
    var locationManager = CLLocationManager()
    var bluetoothManager = CBPeripheralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        bluetoothManager.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        var status = ""
        switch peripheral.state {
        case .poweredOff: status = "Bluetooth Status: \n Turned Off"
        case .poweredOn: status = "Bluetooth Status: \n Turned On"
        case .resetting: status = "Bluetooth Status: \n Resetting"
        case .unauthorized: status = "BLuetooth Status: \n Not Authorized"
        case .unsupported: status = "Bluetooth Status: \n Not Supported"
        default: status = "Bluetooth Status: \n Unknown"
        }
        print(status)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func transmit(_ sender: UIButton) {
        if uuidTF.text != "" && majorTF.text != "" && minorTF.text != ""{
            uuid = NSUUID(uuidString: uuidTF.text!) as UUID?
            major = UInt16(majorTF.text!)
            minor = UInt16(minorTF.text!)
            let newRegion = CLBeaconRegion(proximityUUID: uuid!, major: major!, minor: minor!, identifier: "aa")
            let dataDictionary = newRegion.peripheralData(withMeasuredPower: nil)
            bluetoothManager.startAdvertising(dataDictionary as?[String: Any])
        }
    }

    @IBAction func load(_ sender: UIButton) {
        uuidTF.text = UserDefaults.standard.string(forKey: "uuid")
    }
    @IBAction func save(_ sender: UIButton) {
        UserDefaults.standard.set(uuidTF.text!, forKey: "uuid")
    }
    
    private func checkBluetooth(){
        if bluetoothManager.state == .poweredOff{
            let alert = UIAlertController(title: "Bluetooth Turn on Request", message: " AME would like to turn on your bluetooth!", preferredStyle: UIAlertControllerStyle.alert)
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Allow", style: UIAlertActionStyle.default, handler: { action in
                self.turnOnBlt()
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
        }
    }
    
    func turnOnBlt() {
        let url = URL(string: "App-Prefs:root=Bluetooth") //for bluetooth setting
        let app = UIApplication.shared
        app.open(url!, options: ["string":""], completionHandler: nil)
    }
}

