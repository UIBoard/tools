//
//  View+Render.swift
//  UIBoard (iOS)
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

#if os(iOS)
typealias SystemImage = UIImage
typealias SystemHostingController = UIHostingController
#elseif os(macOS)
typealias SystemImage = NSImage
typealias SystemHostingController = NSHostingController
#endif

extension View {
	func render() -> SystemImage {
		let controller = SystemHostingController(rootView: self)
		#if os(macOS)
		let view = controller.view
		#else
		let view = controller.view!
		#endif
		let frame = CGRect(origin: .zero, size: view.intrinsicContentSize)
		print(view.intrinsicContentSize)
		view.frame = frame

		let image: SystemImage
		#if os(macOS)
		let repository = view.bitmapImageRepForCachingDisplay(in: frame)!
		view.cacheDisplay(in: frame, to: repository)
		image = NSImage(cgImage: repository.cgImage!, size: frame.size)
		#else
		let renderer = UIGraphicsImageRenderer(size: view.frame.size)
		image = renderer.image { ctx in
			print("rendered", view.drawHierarchy(in: view.frame, afterScreenUpdates: true))
		}
		#endif

		return image
	}
}
