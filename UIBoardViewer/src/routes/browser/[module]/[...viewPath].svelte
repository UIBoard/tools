<script context="module" lang="ts">
	import {loadBoard} from './_loadBoard'
	import type { LoadInput } from '@sveltejs/kit'
	import Board from '$lib/UI/Board/index.svelte'

	export async function load({page, fetch, session, context}: LoadInput) {
		const viewPath = page.params.viewPath
		const viewPathComponents = viewPath.split('/')
		const mainViewIdentifier = (viewPath && viewPath.length > 0) ? viewPathComponents[viewPathComponents.length-1] : null

		const boardResult = await loadBoard(page.params.module, fetch)
		const pageData: {status?: any, error?: Error, props?: {board: EnhancedBoard, mainViewIdentifier?: string, breadcrumbPath: string[]}} = {}
		if (boardResult.ok) {
			pageData.props = {
				board: boardResult.board,
				mainViewIdentifier,
				breadcrumbPath: viewPathComponents
			}
		} else if (boardResult.ok == false) {
			pageData.status = boardResult.status
			pageData.error = boardResult.error
		}
		return pageData
	}
</script>

<script lang="ts">
	import type {EnhancedBoard} from './_loadBoard'
	import { createOverview } from '$lib/model/trees/views'
	import SimpleTree from '$lib/UI/SimpleTree/index.svelte'
	import { createGenericParentMap, createLimitedDepthBrowserContext } from '$lib/model/browserContext'
	import type {LimitedDepthBrowserContext} from '$lib/model/browserContext'
	import type { PreviewComposition } from '$lib/model/previewMaps';

	export let board: EnhancedBoard, mainViewIdentifier: string, breadcrumbPath: string[]
	
	let visibleChildMap, overview
	$: visibleChildMap = new Map(Array.from(board.mostDiversePreviews.entries(), ([name, previewComposition])=>[name, previewComposition.viewNames]))
	$: enhancedBoardDescription = {genericDecomposition: board.moduleDescription.genericDecomposition, visibleChildMap, moduleName: board.moduleDescription.module}
	$: overview = createOverview({roots: board.roots, ...enhancedBoardDescription})
	$: parentMap = createGenericParentMap(board.moduleDescription.genericDecomposition)

	let browserContext: LimitedDepthBrowserContext
	$: {
		if (mainViewIdentifier) 
			browserContext = createLimitedDepthBrowserContext({
				root: mainViewIdentifier,
				parentMap,
				mostDiversePreviews: board.mostDiversePreviews,
				path: breadcrumbPath,
				...enhancedBoardDescription
			})
		else
			browserContext = null
	}
</script>

{#if mainViewIdentifier}
	<Board context={browserContext}></Board>
{:else}
	<h2>Module {board.moduleDescription.module}</h2>
	<p>This module has the following root views</p>
	<ul>
		{#each Array.from(board.roots) as root}
			<li><a href="{board.moduleDescription.module}/{root}">{root}</a></li>
		{/each}
	</ul>

	{#if overview && overview.length > 0}
	<SimpleTree data={overview[0]}></SimpleTree>
	{/if}
{/if}
