//
//  CacheService.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import Foundation
import UIKit

protocol CacheServicing {
    func getDocumentsDirectory() -> URL
    func resetCache()
    func save(savedState: SavedState)
    func getSavedState() -> SavedState?
}

final class CacheService: CacheServicing {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func resetCache() {
        let originalImage = getDocumentsDirectory().appendingPathComponent(Constants.originalImagePath)
        let processedImage = getDocumentsDirectory().appendingPathComponent(Constants.processedImagePath)

        try? FileManager.default.removeItem(at: originalImage)
        try? FileManager.default.removeItem(at: processedImage)
    }

    func save(savedState: SavedState) {
        if
            let originalImageData = savedState.originalImage.jpegData(compressionQuality: 1.0),
            let processedImageData = savedState.maskedImage.jpegData(compressionQuality: 1.0)
        {
            let originalImagePath = getDocumentsDirectory().appendingPathComponent(Constants.originalImagePath)
            let processedImagePath = getDocumentsDirectory().appendingPathComponent(Constants.processedImagePath)

            try? originalImageData.write(to: originalImagePath)
            try? processedImageData.write(to: processedImagePath)
        }
    }

    func getSavedState() -> SavedState? {
        let documentsDirectory = getDocumentsDirectory()
        let originalImagePath = documentsDirectory.appendingPathComponent(Constants.originalImagePath)
        let processedImagePath = documentsDirectory.appendingPathComponent(Constants.processedImagePath)

        guard
            let originalImage = UIImage(contentsOfFile: originalImagePath.path),
            let processedImage = UIImage(contentsOfFile: processedImagePath.path)
        else {
            return nil
        }

        return SavedState(
            originalImage: originalImage,
            maskedImage: processedImage
        )
    }
}
