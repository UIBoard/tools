import {getRoots} from '$lib/model/trees/roots'
import {createPreviewProviderDictionary, createViewCompositionMap} from '$lib/model/previewMaps'
import { createGenericParentMap } from '$lib/model/browserContext'

const boardDescriptions = new Map()

export async function loadBoard(moduleName, fetch) {
	if (boardDescriptions.has(moduleName)) {
		const cache = boardDescriptions.get(moduleName)
		return {
			board: cache,
			ok: true
		}
	} else {
		const descriptionUrl = `/BoardDescriptions/${moduleName}/index.json`
		const descriptionResult = await fetch(descriptionUrl)
		if (descriptionResult.ok) {
			const moduleDescription = await descriptionResult.json()
			const roots = getRoots(moduleDescription.genericDecomposition)
			const previewProviders = createPreviewProviderDictionary(moduleDescription.visualDecomposition)
			const board = {
				moduleDescription,
				roots,
				previewProviders,
				mostDiversePreviews: createViewCompositionMap(previewProviders),
				parentMap: createGenericParentMap(moduleDescription.genericDecomposition)
			}
			boardDescriptions.set(moduleName, board)
			return {
				board,
				ok: true
			}
		} else {
			return {
				ok: false,
				status: descriptionResult.status,
				error: new Error(`Could not load ${descriptionUrl}`)
			}
		}
	}
}
