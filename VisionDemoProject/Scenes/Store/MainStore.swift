//
//  MainStore.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import Combine
import Foundation
import class UIKit.UIImage

final class MainStore: ObservableObject {
    @Injected var visionService: VisionServicing
    @Injected var cacheService: CacheServicing

    @Published var originalImage: UIImage?
    @Published var processedImage: UIImage?
    @Published var isImagePickerPresented = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        restoreSavedState()

        $originalImage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.getPeopleMask()
            })
            .store(in: &cancellables)
    }

    func chooseImage() {
        isImagePickerPresented.toggle()
        processedImage = nil
    }

    func saveState() {
        guard let originalImage = originalImage, let processedImage = processedImage else {
            return
        }

        let state = SavedState(originalImage: originalImage, maskedImage: processedImage)
        cacheService.save(savedState: state)
    }

    func resetState() {
        cacheService.resetCache()
        originalImage = nil
        processedImage = nil
    }
}

// MARK: - Private methods
private extension MainStore {
    func getPeopleMask() {
        guard let originalImage = originalImage else {
            return
        }

        let maskImage = try? visionService.runSegmentationRequest(for: originalImage)
        self.processedImage = maskImage
    }

    func restoreSavedState() {
        guard let savedStated = cacheService.getSavedState() else {
            return
        }

        originalImage = savedStated.originalImage
        processedImage = savedStated.maskedImage
    }
}
