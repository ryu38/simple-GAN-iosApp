//
//  CIImageProcessor.swift
//  TryCoreML (iOS)
//
//  Created by no145 on 2021/12/26.
//

import Foundation
import CoreImage
import UIKit
import VideoToolbox

extension CIImage {
    
    func resizeToSquare() -> CIImage {
        let width = self.extent.width
        let height = self.extent.height
        
        let resizedImage: CIImage
        if width > height {
            print("width longer")
            let diffLeng = width - height
            let shortLeng = height
            resizedImage = self.cropped(to: CGRect(x: ceil(diffLeng / 2), y: 0, width: shortLeng, height: shortLeng))
        } else {
            let diffLeng = height - width
            let shortLeng = width
            resizedImage = self.cropped(to: CGRect(x: 0, y: ceil(diffLeng / 2), width: shortLeng, height: shortLeng))
        }
        
        return resizedImage
    }
    
    func changeScale(scaledWLeng: Int, scaledHLeng: Int) -> CIImage {
        let scaledWLeng = CGFloat(scaledWLeng)
        let scaledHLeng = CGFloat(scaledHLeng)
        
        let widthScale = scaledWLeng / self.extent.width
        let heightScale = scaledHLeng / self.extent.height
        
        // change scale
        var scaledImage = self.transformed(
            by: CGAffineTransform(scaleX: widthScale, y: heightScale))
        
        // adjust lengths
        scaledImage = scaledImage.cropped(to: CGRect(
            x: scaledImage.extent.minX, y: scaledImage.extent.minY, width: scaledWLeng, height: scaledHLeng
        ))
        
        return scaledImage
    }
    
    func uiImage() -> UIImage? {
        let context = CIContext()
        guard let cgImage = context.createCGImage(self, from: self.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    /**
    Creates a new UIImage from a CVPixelBuffer.
    - Note: Not all CVPixelBuffer pixel formats support conversion into a
            CGImage-compatible pixel format.
    */
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        if let cgImage = CGImage.create(pixelBuffer: pixelBuffer) {
          self.init(cgImage: cgImage)
        } else {
          return nil
        }
    }
}

extension CGImage {
  /**
    Creates a new CGImage from a CVPixelBuffer.
    - Note: Not all CVPixelBuffer pixel formats support conversion into a
            CGImage-compatible pixel format.
  */
  public static func create(pixelBuffer: CVPixelBuffer) -> CGImage? {
    var cgImage: CGImage?
    VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
    return cgImage
  }
}
