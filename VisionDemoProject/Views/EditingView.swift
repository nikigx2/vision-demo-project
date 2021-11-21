//
//  EditingView.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import SwiftUI

struct EditingView: View {
    let originalImage: UIImage
    let processedImage: UIImage?

    let saveHandler: () -> Void
    let chooseImageHandler: () -> Void
    let resetStateHandler: () -> Void

    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: originalImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(style: StrokeStyle(
                        lineWidth: 2,
                        dash: [6]
                    ))
            }
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                chooseImageHandler()
            }

            ZStack {
                Image(uiImage: processedImage ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(style: StrokeStyle(
                        lineWidth: 2,
                        dash: [6]
                    ))
            }
            .aspectRatio(contentMode: .fit)

            Spacer()

            HStack {
                Button(action: { saveHandler() }) {
                    Text("Save state")
                }

                Spacer()

                Button(action: { resetStateHandler() }) {
                    Text("Reset state")
                }
            }
            .padding()
        }
    }
}
