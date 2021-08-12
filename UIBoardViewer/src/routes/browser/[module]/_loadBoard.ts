import {getRoots} from '$lib/model/trees/roots'
import {createPreviewProviderDictionary, createViewCompositionMap} from '$lib/model/previewMaps'
import type {PreviewProviderDecomposition, PreviewDecomposition} from '$lib/model/previewMaps'
import { createGenericParentMap } from '$lib/model/browserContext'
import type { UIBoard } from '$lib/model/BoardDescription'

const boardDescriptions = new Map()

export type EnhancedBoard = {
	moduleDescription: UIBoard.Description,
	roots: Set<string>
	previewProviders: PreviewProviderDecomposition
	mostDiversePreviews: PreviewDecomposition,
	parentMap: Map<string, Set<string>>
}

type BoardResult = {ok: true, board: EnhancedBoard} | {ok: false, status: any, error: Error}

export async function loadBoard(moduleName: string, fetch: (info: RequestInfo, init?: RequestInit) => Promise<Response>): Promise<BoardResult> {
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
