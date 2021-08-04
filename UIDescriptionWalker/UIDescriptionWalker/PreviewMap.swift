//
//  PreviewMap.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 04/08/2021.
//

extension BoardDescription {
	typealias PreviewProviderDictionary = [String: [PreviewWithProvider]]

	// Maps view names to preview providers that provide that view
	func createPreviewProviderDictionary() -> PreviewProviderDictionary {
		var previewsPerView = PreviewProviderDictionary()
		for previewProvider in visualDecomposition {
			for preview in previewProvider.previews {
				if preview.info.tags.children.count == 1 {
					let viewName = preview.info.tags.children[0].type
					let context = PreviewWithProvider(provider: previewProvider.identifier, preview: preview)
					if previewsPerView.keys.contains(viewName) {
						previewsPerView[viewName]!.append(context)
					} else {
						previewsPerView[viewName] = [context]
					}
				} else if preview.info.tags.children.count > 1 {
					print("\tPreview with multiple roots in \(previewProvider.identifier)", preview.render, preview.info.tags.children.map{$0.type})
				} else {
					print("\tPreview with no detected view", previewProvider.identifier, preview.render)
				}
			}
		}
		return previewsPerView
	}

	func createViewCompositionMap(from providerDictionary: PreviewProviderDictionary) -> [String: PreviewComposition] {
		/// The providers that contain the largest collection of distinct view types
		return providerDictionary.compactMapValues { previewContexts -> PreviewComposition? in
			var composition = previewContexts.first.map(PreviewComposition.init)
			for context in previewContexts.dropFirst() {
				let newComposition = PreviewComposition(context: context)
				if newComposition.viewsNames.count > composition!.viewsNames.count {
					composition = newComposition
				}
			}
			return composition
		}
	}

	struct PreviewComposition {
		let context: PreviewWithProvider
		let viewsNames: Set<String>
		init(context: PreviewWithProvider) {
			self.context = context
			viewsNames = context.preview.allContainedViews
		}
	}

	struct PreviewWithProvider {
		var provider: String
		var preview: PreviewProvider.Preview
	}
}

extension BoardDescription.PreviewProvider.Preview {
	var allContainedViews: Set<String> {
		info.tags.flattenedChildren
	}
}
extension BoardDescription.PreviewProvider.Preview.Info.ViewCollector {
	var flattenedChildren: Set<String> {
		Set(children.map(\.type)).union(children.lazy.flatMap(\.collector.flattenedChildren))
	}
}
