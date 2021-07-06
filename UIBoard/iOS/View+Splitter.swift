//
//  View+Splitter.swift
//  UIBoard
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

func captureViews<Container: View>(in container: Container) -> [PreviewSnapshot] {
	let previewCollector = PreviewTagger.Collector()
	let _ = ZStack {
		container.background( PreviewTagger(collector: previewCollector) )
	}.frame(width: 375, height: 812).render()

	print(previewCollector.previewItems.count, "preview items")
	let capturedCount = CGFloat(previewCollector.previewItems.count)

	previewCollector.previewItems.removeAll(keepingCapacity: true)
	let viewCollector = ViewCollector()
	let taggedPreviews = HStack(spacing: 10) {
		container
			.environment(\.viewCollector, viewCollector)
			.overlay( PreviewTagger(collector: previewCollector) )
			.frame(maxWidth: 375, maxHeight: 812)
	}
	.frame(width: 375 * capturedCount + 10 * (capturedCount-1), height: 814)
	.render()

	let canvas = taggedPreviews.cgImage!
	let scaler = CGAffineTransform(scaleX: taggedPreviews.scale, y: taggedPreviews.scale)
	let snapshots = previewCollector.previewItems.map { preview in
		PreviewSnapshot(
			info: .init(visibleArea: .zero, type: AnyTypeInfo(type: EmptyView.self), collector: ViewCollector.defaultValue),
			image: SystemImage(cgImage: canvas.cropping(to: preview.applying(scaler))!)
		)
	}

	print(previewCollector.previewItems)
	print(viewCollector.description)
	print(taggedPreviews.scale)

	return snapshots
}
