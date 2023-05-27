//
//  ViewController.swift
//  SecondImage
//
//  Created by sang on 24/5/23.
//

import UIKit
import Printer
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
                     
                      let sec = storyboard?.instantiateViewController(identifier: "xccccc") as! ImageSecondView
                                                      present(sec,animated: true)
                       
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
                                        let newImage = convertImageToDifferentColorScale(with: UIImage(named: "sma")!, imageStyle: "CIPhotoEffectNoir")
                                   //  convertImageToBitmap22(image: newImage, cpher: peripheral, cchar: characteristic)
                                                                            
                                       
                                        let image = UIImage(named: "sma")
                                      
                                                                               
                                        let  ui8demo : [UInt8] = [1,2,3,4]
                                                                              
                                      
                                                                              // printImageOnPrinter(rasterBytes: arrayUnit, on: peripheral, with: characteristic)
                                       // printBitmapImage(image: newImage,cbccc: peripheral, chcar: characteristic)
                                        //convertImageToESCPOS(image: newImage, cpher: peripheral, cchar: characteristic)
                                        convertImageToESCPOSBitmap(image: newImage,cch: peripheral, cchar: characteristic)
                                        convertImageToESCPOS(image: newImage,cch: peripheral, cchar: characteristic)
                                       
                                        
                                        //print(ddd)
                                       // peripheral.writeValue(ddd, for: characteristic, type: .withoutResponse)
                                        break
                                    }
                                }
                        
                       
                        
                        
        
                        
                    
                  
                  
                
             }

    //demo testing
    func convertImageToESCPOS(image: UIImage, cpher: CBPeripheral, cchar: CBCharacteristic) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: bitmapInfo.rawValue)
        
        guard let bitmapContext = context else {
            return
        }
        
        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        bitmapContext.draw(cgImage, in: rect)
        
        guard let data = bitmapContext.data else {
            return
        }
        
        let totalBytes = cgImage.width * cgImage.height / 8
        var commandData = Data()
        
       
        commandData.append(contentsOf: [0x1B, 0x4B, 0x01, 0x00])
        
     
        let imageWidth = UInt16(cgImage.width)
        commandData.append(contentsOf: [0x1B, 0x57, UInt8(imageWidth & 0xFF), UInt8(imageWidth >> 8)])
        
        
        commandData.append(contentsOf: [0x1B, 0x2A, 0x21, UInt8(cgImage.height / 8), 0x00])
        commandData.append(Data(bytes: data, count: totalBytes))
        print(totalBytes)
        cpher.writeValue(commandData, for: cchar, type: .withoutResponse)
    }
    
    func convertImageToESCPOSBitmap(image: UIImage, cch : CBPeripheral, cchar : CBCharacteristic) -> Data? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil,
                                width: cgImage.width,
                                height: cgImage.height,
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: bitmapInfo.rawValue)

        guard let bitmapContext = context else {
            return nil
        }

        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        bitmapContext.draw(cgImage, in: rect)

        guard let data = bitmapContext.data else {
            return nil
        }

        var escposData = Data()

        // Add ESC/POS commands to set print mode and image size
        let imageWidth = cgImage.width
        let imageHeight = cgImage.height

        let setPrintModeCommand: [UInt8] = [0x1B, 0x21, 0x00] // Set print mode: normal text
        let setImageSizeCommand: [UInt8] = [0x1D, 0x76, 0x30, 0x00, UInt8(imageWidth), UInt8(imageWidth >> 8), UInt8(imageHeight), UInt8(imageHeight >> 8)] // Set image size

        escposData.append(Data(setPrintModeCommand))
        escposData.append(Data(setImageSizeCommand))

        // Convert bitmap data to monochrome image data
        for i in 0..<(imageWidth * imageHeight) {
            let byte = data.load(fromByteOffset: i, as: UInt8.self)
            escposData.append(byte)
        }
        print(escposData)
        cch.writeValue(escposData, for: cchar, type: .withoutResponse)

        // Append any necessary additional commands or data specific to your printer
        return escposData
    }
    
    func convertImageToESCPOS(image: UIImage, cch : CBPeripheral, cchar : CBCharacteristic) -> Data? {
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
    
        var commandData = Data()
        
      
        commandData.append(Data([0x1B, 0x21, 0x00]))
        
       
        let widthBytes = UInt16(cgImage.width / 8)
        commandData.append(Data([0x1D, 0x76, 0x30, UInt8(widthBytes & 0xFF), UInt8(widthBytes >> 8)]))
        
        
        let heightBytes = UInt16(cgImage.height)
        commandData.append(Data([0x1D, 0x76, 0x31, UInt8(heightBytes & 0xFF), UInt8(heightBytes >> 8)]))
        
        //
        commandData.append(Data(bytes: data, count: cgImage.width * cgImage.height))
        print(commandData)
        print(commandData)
        
        cch.writeValue(commandData, for: cchar, type: .withoutResponse)
        return commandData
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
    func convertImageToBitmap(image: UIImage) -> UIImage? {
        // Create a bitmap context with the same size as the image
        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        print(width.description)
        print(height.description)
        
        let bytesPerPixel = 4 // 1 byte for each RGBA component
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: bitmapInfo) else { return nil }
        
        // Draw the image in the bitmap context
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        // Retrieve the bitmap image from the context
        guard let bitmapImage = context.makeImage() else { return nil }
        
        // Create a UIImage from the bitmap image
        let bitmapUIImage = UIImage(cgImage: bitmapImage)
        print("Bitmap Image ")
        let  compress : CGFloat =  0.4
        let  imageMainData = image.jpegData(compressionQuality: compress)
        
        
        
        return bitmapUIImage
    }
    func convertImageToBitmap22(image: UIImage , cpher : CBPeripheral,cchar : CBCharacteristic  ) -> Data? {
           guard let cgImage = image.cgImage else {
               return nil
           }
        print("Se")
        print(cpher)
           
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
        print(Data(bytes: data, count: cgImage.width * cgImage.height))
    
        print("Getting")
        let  compress : CGFloat =  0.4
        let  imageMainData = image.jpegData(compressionQuality: compress)
        let bata : Data = Data(bytes: data, count: cgImage.width * cgImage.height)
        
       // cpher.writeValue(imageMainData ?? bata, for: cchar, type: .withoutResponse)
       
           return Data(bytes: data, count: cgImage.width * cgImage.height)
       }
    
    func convertImageToBitmap2(image: UIImage) -> [UInt8]? {
     
        guard let cgImage = image.cgImage else {
            print("Failed to get the CGImage from the image")
            return nil
        }
        

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        
    
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        
       
        let width = 40//cgImage.width
        let height = 40 //cgImage.height
        
       
        let pixelCount = width * height
        
      
        let bitmapData = UnsafeMutablePointer<UInt8>.allocate(capacity: pixelCount * bytesPerPixel)
        defer {
            bitmapData.deallocate()
        }
        
      
        guard let bitmapContext = CGContext(data: bitmapData,
                                            width: width,
                                            height: height,
                                            bitsPerComponent: bitsPerComponent,
                                            bytesPerRow: width * bytesPerPixel,
                                            space: colorSpace,
                                            bitmapInfo: bitmapInfo) else {
            print("Failed to create the bitmap context")
            return nil
        }
        
       
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        bitmapContext.draw(cgImage, in: rect)
        
        
        if let rawPixelData = bitmapContext.data {
          
            let pixelData = Array(UnsafeBufferPointer(start: rawPixelData.bindMemory(to: UInt8.self, capacity: pixelCount * bytesPerPixel), count: pixelCount * bytesPerPixel))
            
            return pixelData
        } else {
            print("Failed to get the raw pixel data from the bitmap context")
            return nil
        }
    }
    
    func printImageOnPrinter(rasterBytes: [UInt8], on peripheral: CBPeripheral, with characteristic: CBCharacteristic) {
          
          //  command.append(120)
         /*
          var command: [UInt8] = []
          command.append(0x1B)
          command.append(0x2A)
          command.append(0x21)
          command.append(0x1d)
       
           command.append(0x68)
          command.append(0x1d)
          command.append(0x48)
          command.append(0x01)
          command.append(0x1d)
          command.append(0x6B)
          command.append(0x02)
          command.append(0x00)
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
      //raster bit is our main bit for bitmap
      guard let image = UIImage(named: "mysmall") else { return  }
      let  testing: [UInt8] = [1,2,3,4,5]
      let mybitmapvalues : [UInt8] = convertImageToBitmap2(image: image) ?? testing
      command.append(UInt8(mybitmapvalues.count & 0xFF))
      
      
      command.append(UInt8((mybitmapvalues.count >> 8) & 0xFF))
      command.append(0x1C)
      command.append(0x5E)
      //over
      //send the command
      
         command.append(UInt8(rasterBytes.count & 0xFF))
         command.append(UInt8((rasterBytes.count >> 8) & 0xFF))
         command += rasterBytes
         
         let data = Data(bytes: command)
         print("Bitmap Complete....")
         guard let image = UIImage(named: "mysmall") else { return  }
         
       ///  peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
         guard let imageData = convertImageToBitmap(image : image) else { return }
         peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
          */
            //BITMAP WIDHT
        
        var command: [UInt8] = []
        //command.append(0x1B)
        //command.append(0x2A)
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
        let width  = 160
        let height = 160
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
    //raster bit is our main bit for bitmap
    guard let image = UIImage(named: "mysmall") else { return  }
    let  testing: [UInt8] = [1,2,3,4,5]
    let mybitmapvalues : [UInt8] = convertImageToBitmap2(image: image) ?? testing
    command.append(UInt8(mybitmapvalues.count & 0xFF))
    
    
    command.append(UInt8((mybitmapvalues.count >> 8) & 0xFF))
    command.append(0x1C)
    command.append(0x5E)
        print(command)    //over
    //send the command
    
       //command.append(UInt8(rasterBytes.count & 0xFF))
      // command.append(UInt8((rasterBytes.count >> 8) & 0xFF))
       //command += rasterBytes
       
       let data = Data(bytes: command)
        //print(command)
       print("Bitmap Complete....")
       //guard let image = UIImage(named: "mysmall") else { return  }
       
     ///  peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
       //guard let imageData = convertImageToBitmap(image : image) else { return }
       peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
       
        
        
       }
}
      
  

func convertImageToBitmap(image: UIImage) -> Data? {
           print("get")
           guard let cgImage = image.cgImage else { return nil }
           
           let width = 40 //cgImage.width
           let height = 40 //cgImage.height
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

   

   
  /*
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
   */

