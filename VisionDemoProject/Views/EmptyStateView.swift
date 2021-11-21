//
//  EmptyStateView.swift
//  VisionDemoProject
//
//  Created by Nick Beresnev on 11/21/21.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    let onTapHandler: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            EmptyImageView(
                imageSystemResource: "photo",
                onTapHandler: onTapHandler
            )

            EmptyImageView(imageSystemResource: "theatermasks")

            Spacer()
        }
    }
}
