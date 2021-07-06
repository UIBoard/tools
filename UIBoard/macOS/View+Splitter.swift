//
//  View+Splitter.swift
//  UIBoard (macOS)
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

func captureViews<Container: View>(in container: Container) -> [PreviewSnapshot] {
	let previewCollector = PreviewTagger.Collector()
	let viewCollector = ViewCollector()
	let taggedPreviews = HStack(spacing: 10) {
		container
			.environment(\.viewCollector, viewCollector)
			.overlay( PreviewTagger(collector: previewCollector) )
			.frame(maxWidth: 500, maxHeight: 310)
	}
	.render()

	let snapshots = viewCollector.children.map { preview in
		PreviewSnapshot(
			info: preview,
			image: taggedPreviews.cropping(to: preview.visibleArea)
		)
	}

	print(previewCollector.previewItems)
	print(viewCollector.description)

	return snapshots
}

extension NSImage {
	func cropping(to rect: CGRect) -> NSImage {
		let result = NSImage(size: rect.size)
		result.lockFocus()

		let destRect = CGRect(origin: .zero, size: result.size)
		draw(in: destRect, from: rect, operation: .copy, fraction: 1.0)

		result.unlockFocus()
		return result
	}
}
