//
//  View+Splitter.swift
//  UIBoard
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

func captureViews<Container: View>(in container: Container, name: String = "no name") -> [PreviewSnapshot] {
	let previewCollector = PreviewTagger.Collector()
	let _ = ZStack {
		container.background( PreviewTagger(collector: previewCollector) )
	}.frame(width: 375, height: 812).render()

	print(previewCollector.previewItems.count, "found preview items")
	let capturedCount = CGFloat(previewCollector.previewItems.count)

	previewCollector.previewItems.removeAll(keepingCapacity: true)
	let viewCollector = ViewCollector()
	let taggedPreviews = HStack(spacing: 300) {
		container
			.environment(\.viewCollector, viewCollector)
			.overlay( PreviewTagger(collector: previewCollector) )
			.frame(maxWidth: 375, maxHeight: 812)
	}
	.frame(width: (375 + 300) * capturedCount, height: 814)
	.render()

	let canvas = taggedPreviews.cgImage!
	let scaler = CGAffineTransform(scaleX: taggedPreviews.scale, y: taggedPreviews.scale)
	let snapshots = previewCollector.previewItems.map { preview -> PreviewSnapshot in
		let containedViews = viewCollector.children.filter { view in
			preview.contains(view.visibleArea)
		}
		let childContainer = ViewCollector(children: containedViews)
		return PreviewSnapshot(
			SystemImage(cgImage: canvas.cropping(to: preview.applying(scaler))!),
			tags: childContainer,
			scale: taggedPreviews.scale,
			viewport: preview
		)
	}

	return snapshots
}
