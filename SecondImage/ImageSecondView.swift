//
//  ImageSecondView.swift
//  SecondImage
//
//  Created by sang on 24/5/23.
//

import UIKit

class ImageSecondView: UIViewController {
    @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var clickbutton: UIButton!
    @IBOutlet weak var firstimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clickedon(_ sender: UIButton) {
        let newImage = convertImageToDifferentColorScale(with: UIImage(named: "small")!, imageStyle: "CIPhotoEffectNoir")
               secondImage.image = newImage
        convertImageToBitmap(image: newImage)
        let dataaa : Data = newImage.cgImag
        
        let  imageData : Data = convertImageToBitmap3(image: newImage) ?? dataaa
        print(imageData.debugDescription)
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
        print(bitmapUIImage)
        
        
        return bitmapUIImage
    }
    func convertBitmapToImage(bitmapData: Data, width: Int, height: Int) -> UIImage? {
        let bytesPerPixel = 4 // 1 byte for each RGBA component
        let bytesPerRow = bytesPerPixel * width
        
        guard let providerRef = CGDataProvider(data: bitmapData as CFData) else { return nil }
        
        guard let cgImage = CGImage(width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bitsPerPixel: bytesPerPixel * 8,
                                    bytesPerRow: bytesPerRow,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                   
                                    bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue) ,
                                    provider: providerRef,
                                    decode: nil,
                                    shouldInterpolate: true,
                                    intent: .defaultIntent) else { return nil }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }

   
       func convertImageToBitmap3(image: UIImage) -> Data? {
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
 
}
