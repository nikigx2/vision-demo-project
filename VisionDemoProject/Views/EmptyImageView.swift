//
//  EmptyImageView.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import SwiftUI

struct EmptyImageView: View {
    let imageSystemResource: String
    var onTapHandler: (() -> Void)?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(style: StrokeStyle(
                    lineWidth: 2,
                    dash: [6]
                ))
                .foregroundColor(.secondary)

            Image(systemName: "photo")
        }
        .aspectRatio(1.5, contentMode: .fit)
        .onTapGesture {
            onTapHandler?()
        }
    }
}

struct EmptyImageView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyImageView(imageSystemResource: "photo")
    }
}
