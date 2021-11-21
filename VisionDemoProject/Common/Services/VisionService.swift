//
//  VisionService.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import CoreImage.CIFilterBuiltins
import UIKit.UIImage
import Vision

protocol VisionServicing {
    func runSegmentationRequest(for image: UIImage) throws -> UIImage?
}

final class VisionService: VisionServicing {
    private lazy var request: VNGeneratePersonSegmentationRequest = {
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8

        return request
    }()

    func runSegmentationRequest(for image: UIImage) throws -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        try handler.perform([request])

        let mask = request.results?.first
        let maskBuffer = mask?.pixelBuffer

        return maskImage(inputImage: image, maskBuffer)
    }

    func maskImage(inputImage: UIImage, _ buffer: CVPixelBuffer?) -> UIImage? {
        guard let input = CIImage(image: inputImage), let buffer = buffer else {
            return nil
        }

        let mask = CIImage(cvPixelBuffer: buffer)

        let maskScaleX = input.extent.width / mask.extent.width
        let maskScaleY = input.extent.height / mask.extent.height
        let transformation = CGAffineTransform(a: maskScaleX, b: 0, c: 0, d: maskScaleY, tx: 0, ty: 0)
        let maskScaled = mask.transformed(by: transformation)

        let blendFilter = CIFilter.blendWithMask()

        blendFilter.inputImage = input
        blendFilter.maskImage = maskScaled

        guard let blendedImage = blendFilter.outputImage else {
            return nil
        }

        let ciContext = CIContext(options: nil)
        let filteredImageRef = ciContext.createCGImage(blendedImage, from: blendedImage.extent)

        guard let filteredImageCgImage = filteredImageRef else {
            return nil
        }

        return UIImage(cgImage: filteredImageCgImage)
    }
}
