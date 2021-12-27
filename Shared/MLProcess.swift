//
//  MLProcess.swift
//  TryCoreML (iOS)
//
//  Created by no145 on 2021/12/24.
//

import Foundation
import CoreML
import Vision
import UIKit

class MLProcess {
    
    private let model: VNCoreMLModel
    private let request: VNCoreMLRequest
    
    private let imageSize = 256
    
    init() {
        model = createVNModel()
        request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = .centerCrop
        request.usesCPUOnly = true
    }
    
    func process(image: UIImage) throws -> UIImage? {
        guard let image = CIImage(image: image) else { return nil }
        let processedImg = preprocess(image: image)
        let handler = VNImageRequestHandler(ciImage: processedImg)
        try handler.perform([request])
        if let result = request.results?[0] as? VNPixelBufferObservation {
            return UIImage(pixelBuffer: result.pixelBuffer)
        } else {
            return nil
        }
    }
    
    private func preprocess(image: CIImage) -> CIImage {
        return image
            .resizeToSquare()
            .changeScale(scaledWLeng: imageSize, scaledHLeng: imageSize)
    }
}

func createVNModel() -> VNCoreMLModel {
    let config = MLModelConfiguration()
    
    do {
        let model = try GANModel(configuration: config)
        let visionModel = try VNCoreMLModel(for: model.model)
        return visionModel
    } catch let error {
        print(error)
        fatalError("error in creating model")
    }
}
