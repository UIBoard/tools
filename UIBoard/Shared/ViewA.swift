//
//  ViewA.swift
//  UIBoard
//
//  Created by Damiaan on 21/06/2021.
//

import SwiftUI

/// This is my first view
struct ViewA: TaggedView {
    var content: some View {
		VStack {
			Text("View A")
			ViewX()
		}
    }
}

struct ViewA_Previews: PreviewProvider {
    static var previews: some View {
		ViewA().previewDisplayName("Hello Preview")
    }
}
