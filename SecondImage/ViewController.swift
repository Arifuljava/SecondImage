//
//  ViewController.swift
//  SecondImage
//
//  Created by sang on 24/5/23.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController ,  CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource{
    var coreCenter = CBCentralManager();
    private var centralManager: CBCentralManager?
          private var discoveredPeripherals: [CBPeripheral] = []
    //cnc
      var manager:CBCentralManager!
      var peripheral:CBPeripheral!

      let BEAN_NAME = "AC695X_1(BLE)"
      var myCharacteristic : CBCharacteristic!
          
          var isMyPeripheralConected = false

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
               // Do any additional setup after loading the view.
                     tableView.delegate = self
                                  tableView.dataSource = self
                             centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
                                            tableView.delegate = self
                                            tableView.dataSource = self

                                     // Do any additional setup after loading the view.
                                     
                                     manager = CBCentralManager(delegate: self, queue: nil)
                 }
                 @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
                             if central.state == .poweredOn {
                                 if let peripheral = peripheral {
                                             if peripheral.state == .connected {
                                                 // The peripheral is connected
                                                 print("Peripheral is connected.")
                                             } else {
                                                 // The peripheral is not connected
                                                 print("Peripheral is not connected.")
                                                 central.scanForPeripherals(withServices: nil, options: nil)
                                             }
                                         } else {
                                             // No peripheral is currently assigned
                                             print("No peripheral assigned.")
                                             central.scanForPeripherals(withServices: nil, options: nil)
                                         }
                                 
                             } else {
                                 print("Bluetooth is not available.")
                             }
                         }
                 func cancelPeripheralConnection(_ peripheral: CBPeripheral)
                 {
                     
                     discoveredPeripherals.dropFirst()
                     print("discc")
                 }
                    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
                               if !discoveredPeripherals.contains(peripheral) {
                                  
                                   discoveredPeripherals.append(peripheral)
                                   tableView.reloadData()
                                   
                               }
                              
                        
                        
                             //  print(mainflagg.description)
                               if peripheral.name?.contains("AC695X_1(BLE)") == true {
                                  
                                   manager.cancelPeripheralConnection(peripheral)
                                   manager.cancelPeripheralConnection(peripheral)
                                  
                                
                                           self.peripheral = peripheral
                                           self.peripheral.delegate = self

                                           manager.connect(peripheral, options: nil)
                                   peripheral.delegate = self
                                   peripheral.discoverServices(nil)
                                
                                           print("My  discover peripheral", peripheral)
                                   self.manager.stopScan()
                   //check pherifiral
                                  
                                   
                                   
                                       }
                               
                               
                               
                    }
                 func cancelConnection() {
                     //peripheral.writeValue(x, for: y, type: .withResponse)
                 }
                    //
                    // MARK: - UITableViewDelegate & UITableViewDataSource
                  @objc  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                       let peripheral = discoveredPeripherals[indexPath.row]
                       let devicename = peripheral.identifier.uuidString
                     
           
                       
                   }
                       
                     @objc   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                          /// print("se")
                           return discoveredPeripherals.count
                       }
                       
                      @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                           let peripheral = discoveredPeripherals[indexPath.row]
                           cell.textLabel?.text = peripheral.name ?? "Unknown Device"
                           cell.detailTextLabel?.text = peripheral.identifier.uuidString
                         
                           return cell
                       }
                   func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
                       if let error = error {
                           print("Failed to connect to peripheral: \(error.localizedDescription)")
                       } else {
                           print("Failed to connect to peripheral")
                       }
                       // Perform any necessary error handling or recovery steps
                   }
                  
                   
                   
                  @objc  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
                            isMyPeripheralConected = true //when connected change to true
                            peripheral.delegate = self
                            peripheral.discoverServices(nil)
                        
                    
                      print("Connected  \(peripheral.name)")
                        var statusMessage = "Connected Successfully with this device : "+BEAN_NAME.description
                      
                        
                        
                  }
                 
                 func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
                           isMyPeripheralConected = false //and to falso when disconnected
                           var statusMessage = "Can't  connected with this device : "+BEAN_NAME.description
                         
                     print("Disconnect \(error.debugDescription)")
                       }
                   func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
                       print("not connect")
                   }
                    
                    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
                                 guard let services = peripheral.services else { return }
                                 
                                 for service in services {
                                   peripheral.discoverCharacteristics(nil, for: service)
                                     print("Discoveri")
                                 }
                             }
                    private var printerCharacteristic: CBCharacteristic!
                    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
                                guard let characteristics = service.characteristics else { return }
                                
                                for characteristic in characteristics {
                                    if characteristic.properties.contains(.writeWithoutResponse) {
                                        printerCharacteristic = characteristic
                                      print("geeeeeee")
                                        
                                        break
                                    }
                                }
                        
                       
                        
                        
                
                  
                  
                
             }
   
    func printMyImage(imageDtaget : Data, phe : CBPeripheral, chara : CBCharacteristic)
    {
        peripheral.writeValue(imageDtaget, for: chara, type: .withResponse)
        
    }
    func converDuplicate(image : UIImage)  ->Data?
    {
        guard let imageget = image.cgImage else
        {
            return nil
        }
        let width = imageget.width
        let height = imageget.height
        
        let  colorShape = CGColorSpaceCreateDeviceRGB()
        let  bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
        let bytesPerPixcel = 4
        let bytePerRow = bytesPerPixcel * width
        let bitsPerComponent = 8
        var rawData = [UInt8](repeating: 0, count: height*bytePerRow)
        var context = CGContext(data: &rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytePerRow, space: colorShape, bitmapInfo: bitmapInfo.rawValue)
        let  imageRect = CGRect(x: 0, y: 0, width: width, height: height)
        context?.draw(imageget, in: imageRect)
        return Data(bytes: &rawData, count: rawData.count)
        
        
    }
           func convertImageToBitmap22(image: UIImage) -> Data? {
               guard let cgImage = image.cgImage else {
                   return nil
               }
               
               let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
               let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: bitmapInfo.rawValue)
               
               guard let bitmapContext = context else {
                   return nil
               }
               
               let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
               bitmapContext.draw(cgImage, in: rect)
               
               guard let data = bitmapContext.data else {
                   return nil
               }
               
               return Data(bytes: data, count: cgImage.width * cgImage.height)
           }
           
           func convertImageToBitmap11(image: UIImage) -> [UInt8]? {
               guard let cgImage = image.cgImage else { return nil }
               
               let width = cgImage.width
               let height = cgImage.height
               
               let colorSpace = CGColorSpaceCreateDeviceRGB()
               let bytesPerPixel = 4
               let bytesPerRow = bytesPerPixel * width
               let bitsPerComponent = 8
               let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
               
               var bitmapData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
               
               guard let context = CGContext(data: &bitmapData,
                                             width: width,
                                             height: height,
                                             bitsPerComponent: bitsPerComponent,
                                             bytesPerRow: bytesPerRow,
                                             space: colorSpace,
                                             bitmapInfo: bitmapInfo) else {
                   return nil
               }
               
               let rect = CGRect(x: 0, y: 0, width: width, height: height)
               context.draw(cgImage, in: rect)
               
               return bitmapData
           }
           
  
          func convertImageToBitmap(image: UIImage) -> Data? {
                  print("get")
                  guard let cgImage = image.cgImage else { return nil }
                  
              let width = cgImage.width
              let height = cgImage.height
                  let colorSpace = CGColorSpaceCreateDeviceGray()
                  
                  let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
                  guard let context = CGContext(data: nil,
                                                width: width,
                                                height: height,
                                                bitsPerComponent: 8,
                                                bytesPerRow: 0,
                                                space: colorSpace,
                                                bitmapInfo: bitmapInfo.rawValue) else {
                      return nil
                  }
                 
                  
                  let rect = CGRect(x: 0, y: 0, width: width, height: height)
                  context.draw(cgImage, in: rect)
                  guard let bitmapData = context.data else { return nil }
                  
                  let dataSize = width * height
                  let buffer = UnsafeBufferPointer(start: bitmapData.assumingMemoryBound(to: UInt8.self), count: dataSize)
                  print("Bitmap Value : "+buffer.debugDescription)
                  
                  return Data(buffer: buffer)
              }
       
   
        
        }
    
 
    
  
           
           func printImageOnPrinter(rasterBytes: [UInt8], on peripheral: CBPeripheral, with characteristic: CBCharacteristic) {
                  var command: [UInt8] = []
                  command.append(0x1B)
                  command.append(0x2A)
                  command.append(0x21)
                  command.append(0x1d)
               
               command.append(0x68)
             //  command.append(120)
               command.append(0x1d)
               command.append(0x48)   //command use cpcl
               command.append(0x01)
               command.append(0x1d)
               command.append(0x6B)
               command.append(0x02)
               command.append(0x00)
               
               
               //comand esc^^^^^^^^^
               command.append(0x1D)
               command.append(0x0E)
               command.append(0x1C)
               command.append(0x60)
            
                command.append(0x4D)
          
                command.append(0x53)
                command.append(0x1C)   //command use cpcl
                command.append(0x60)
                command.append(0x7E)
                command.append(0x7E)
                command.append(0x1D)
               command.append(0x76)
                command.append(0x30)
                command.append(0x00)
               //BITMAP WIDHT
               let width  = 40
               let height = 40
               let widthL=width/8%256
               let widthH=width/256
               let heightL=height/8%256
               let heightH=height/256
               let valrues: [UInt8] = [1, 2, 3, 4]
              let new_vales1 = UInt8(widthL)
               command.append(new_vales1)
               let new_vales2 = UInt8(widthH)
                command.append(new_vales2)
              let  new_vales3 = UInt8(heightL)
                command.append(new_vales3)
              let  new_vales4 = UInt8(heightH)
                command.append(new_vales4)
               
               
               //this  place add bitmapdata
               //here
               //this is our bitmap data
               guard let image = UIImage(named: "mysmall") else { return  }
               guard let imageData = convertImageToBitmap(image : image) else { return }
               //th is is on data formate
              //second
               let mydata : Data = imageData
               var unit8 = [UInt8](repeating: 0, count : mydata.count)
               mydata.withUnsafeBytes{
                   rawBufferPoint in
                   let bufferPoint  =  rawBufferPoint.bindMemory(to: UInt8.self)
                   unit8 = Array(bufferPoint)
               }
               let  again = mydata.withUnsafeBytes{
                   [UInt8](UnsafeBufferPointer(start: $0, count: mydata.count))
               }
               let  dafta = mydata // Sample data

               
               //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
               
               
                  command.append(UInt8(rasterBytes.count & 0xFF))
                  command.append(UInt8((rasterBytes.count >> 8) & 0xFF))//what is this?
                  command += rasterBytes
                  
                  let data = Data(bytes: command)
                  print("Bitmap Complete....")
                 
peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
                  
                  peripheral.writeValue(imageData, for: characteristic, type: .withoutResponse)
                
              }
             
          

           var context = CIContext(options: nil)
           func convertImageToDifferentColorScale(with originalImage:UIImage, imageStyle:String) -> UIImage {
               let currentFilter = CIFilter(name: imageStyle)
               currentFilter!.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
               let output = currentFilter!.outputImage
               let context = CIContext(options: nil)
               let cgimg = context.createCGImage(output!,from: output!.extent)
               let processedImage = UIImage(cgImage: cgimg!)
               return processedImage
           }
           func convertImageToBitmap(image: UIImage) -> Data? {
                 print("get")
                 guard let cgImage = image.cgImage else { return nil }
                 
                 let width = cgImage.width
                 let height = cgImage.height
                 let colorSpace = CGColorSpaceCreateDeviceGray()
                 
                 let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
                 guard let context = CGContext(data: nil,
                                               width: width,
                                               height: height,
                                               bitsPerComponent: 8,
                                               bytesPerRow: 0,
                                               space: colorSpace,
                                               bitmapInfo: bitmapInfo.rawValue) else {
                     return nil
                 }
                
                 
                 let rect = CGRect(x: 0, y: 0, width: width, height: height)
                 context.draw(cgImage, in: rect)
                 guard let bitmapData = context.data else { return nil }
                 
                 let dataSize = width * height
                 let buffer = UnsafeBufferPointer(start: bitmapData.assumingMemoryBound(to: UInt8.self), count: dataSize)
                 print("Bitmap Value : "+buffer.debugDescription)
              
               
                 
                 return Data(buffer: buffer)
             }

public extension Data {
    
    func to<T>(_ type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}
