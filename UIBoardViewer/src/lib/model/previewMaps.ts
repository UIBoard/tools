import type {UIBoard} from './BoardDescription'

/** 
 * Creates a dictionary that maps a (view's identifier) to (all preview providers that provide a preview for that view).
 */
export function createPreviewProviderDictionary(visualDecomposition: UIBoard.PreviewProvider[]): PreviewProviderDecomposition {
	const previewsPerView = new Map<string,PreviewWithProvider[]>()

	for (const previewProvider of visualDecomposition) {
		for (const preview of previewProvider.previews) {
			const viewNames = new Set(preview.info.tags.children.map(child => child.type))
			if (viewNames.size == 1) {
				const viewName = preview.info.tags.children[0].type
				const context: PreviewWithProvider = {
					provider: previewProvider.identifier,
					preview
				}
				if ( previewsPerView.has(viewName) ) {
					previewsPerView.get(viewName).push(context)
				} else {
					previewsPerView.set(viewName, [context])
				}
			} else if (viewNames.size > 1) {
				console.warn(
					`Preview with multiple roots in ${previewProvider.identifier}`,
					preview.render,
					preview.info.tags.children.map(view => view.type)
				)
			} else {
				console.warn("Preview with no detected view", previewProvider.identifier, preview.render)
			}
		}
	}

	return previewsPerView
}

/**
 * Make a dictionary with the most diversive previews.
 * Diversity of a preview is measured using the number of distinct identifiers of views that are visible in the preview.
 * 
 * @param providerDictionary 
 * @returns A dictionary that maps a (view's identifier) to (the preview provider that provides the most diversive preview for that view).
 */
export function createViewCompositionMap(providerDictionary: PreviewProviderDecomposition): PreviewDecomposition {
	const result: PreviewDecomposition = new Map()
	for (const [viewName, providers] of providerDictionary.entries()) {
		if (providers.length == 0) { continue }
		const iterator = providers.values()
		let mostDiverseComposition = createPreviewComposition( iterator.next().value )
		for (const provider of iterator) {
			const newComposition = createPreviewComposition(provider)
			if (newComposition.viewNames.size > mostDiverseComposition.viewNames.size)
				mostDiverseComposition = newComposition
		}
		result.set(viewName, mostDiverseComposition)
	}
	return result
}

function createPreviewComposition(context: PreviewWithProvider): PreviewComposition {
	return { context, viewNames: getAllContainedVisibleViewsFromPreview(context.preview) }
}

export function getAllContainedVisibleViewsFromPreview(preview: UIBoard.Preview): Set<string> {
	return getAllContainedVisibleViewsFromViewCollector(preview.info.tags)
}

export function getAllContainedVisibleViewsFromViewCollector(collector: UIBoard.ViewCollector): Set<string> {
	const result = new Set(collector.children.flatMap(child => Array.from(getAllContainedVisibleViewsFromViewCollector(child.collector))))
	for (const child of collector.children) {
		result.add(child.type)
	}
	return result
}

type PreviewProviderDecomposition = Map<string, PreviewWithProvider[]>

export type PreviewDecomposition = Map<string, PreviewComposition>

export type PreviewComposition = {
	context: PreviewWithProvider
	viewNames: Set<string>
}

export type PreviewWithProvider = {
	provider: String
	preview: UIBoard.Preview
}