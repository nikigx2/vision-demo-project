//
//  MainScene.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import SwiftUI

struct MainScene: View {
    @StateObject var store = MainStore()

    var body: some View {
        VStack {
            if let originalImage = store.originalImage {
                EditingView(
                    originalImage: originalImage,
                    processedImage: store.processedImage,
                    saveHandler: {
                        store.saveState()
                    },
                    chooseImageHandler: {
                        store.chooseImage()
                    },
                    resetStateHandler: {
                        store.resetState()
                    }
                )
            } else {
                EmptyStateView(onTapHandler: { store.chooseImage() })
            }
        }
        .padding()
        .sheet(isPresented: $store.isImagePickerPresented) {
            ImagePicker(image: $store.originalImage)
        }
    }
}

struct MainScene_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
    }
}
