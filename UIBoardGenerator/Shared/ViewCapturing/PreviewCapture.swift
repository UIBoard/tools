//
//  View+Splitter.swift
//  UIBoard
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

struct PreviewSnapshot {
	let image: SystemImage
	let info: Info

	init(_ image: SystemImage, tags: ViewCollector, scale: CGFloat) {
		self.image = image
		info = Info(tags: tags, scale: scale)
	}

	struct Info: Encodable {
		let tags: ViewCollector
		let scale: CGFloat
	}

	var tags: ViewCollector { info.tags }
	var scale: CGFloat { info.scale }
}

struct PreviewTagger: View {
	let collector: Collector
	var body: some View {
		GeometryReader(content: read)
	}

	func read(proxy: GeometryProxy) -> some View {
		collector.previewItems.append(proxy.frame(in: .global))
		return Color.clear
	}

	class Collector {
		var previewItems = [CGRect]()
	}
}
