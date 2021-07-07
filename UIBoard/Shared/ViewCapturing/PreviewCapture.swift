//
//  View+Splitter.swift
//  UIBoard
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

struct PreviewSnapshot {
	let info: ViewCollector
	let image: SystemImage
}

struct PreviewTagger: View {
	let collector: Collector
	var body: some View {
		GeometryReader(content: read)
	}

	func read(proxy: GeometryProxy) -> some View {
		collector.previewItems.append(proxy.frame(in: .global))
		return Ellipse().stroke().foregroundColor(.blue)
	}

	class Collector {
		var previewItems = [CGRect]()
	}
}
