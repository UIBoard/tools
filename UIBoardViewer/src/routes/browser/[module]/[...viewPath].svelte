<script context="module">
	import {loadBoard} from './_loadBoard'

	export async function load({page, fetch, session, context}) {
		const viewPath = page.params.viewPath
		const viewPathComponents = viewPath.split('/')
		const mainViewIdentifier = (viewPath && viewPath.length > 0) ? viewPathComponents[viewPathComponents.length-1] : null

		const boardResult = await loadBoard(page.params.module, fetch)
		const pageData = {}
		if (boardResult.ok) {
			pageData.props = {
				board: boardResult.board,
				mainViewIdentifier
			}
		} else {
			pageData.status = boardResult.status
			pageData.error = boardResult.error
		}
		return pageData
	}
</script>

<script>
	import { createOverview, createSubTreeFrom } from '$lib/model/trees/views';
	import SimpleTree from '$lib/UI/SimpleTree/index.svelte'
	import { createGenericParentMap } from '$lib/model/browserContext';

	export let board, mainViewIdentifier
	
	let mostDiversePreview, visibleChildMap, overview
	$: mostDiversePreview = board.mostDiversePreviews.get(mainViewIdentifier)
	$: visibleChildMap = new Map(Array.from(board.mostDiversePreviews.entries(), ([name, previewComposition])=>[name, previewComposition.viewNames]))

	// @ts-ignore
	$: overview = createOverview({roots: board.roots, genericDecomposition: board.moduleDescription.genericDecomposition, visibleChildMap})

	function loadSmallTree(root) {
		const subtree = createSubTreeFrom({
			root,
			depthLimit: 3,
			visibleChildMap,
			genericDecomposition: board.moduleDescription.genericDecomposition
		})
		return subtree
	}

	const parentMap = createGenericParentMap(board.moduleDescription.genericDecomposition)
	let myParents
	$: myParents = Array.from(parentMap.get(mainViewIdentifier) ?? new Set())
</script>

<h1>Browser</h1>
{#if mainViewIdentifier}
	<h2>{mainViewIdentifier}</h2>
	<SimpleTree data={loadSmallTree(mainViewIdentifier)}></SimpleTree>
	<ul>
		{#each board.moduleDescription.genericDecomposition[mainViewIdentifier] as relatedView}
			<li><a href="{mainViewIdentifier}/{relatedView}">{relatedView}</a></li>
		{/each}
	</ul>
	<p>Parents: {myParents.map(name => name.slice(name.indexOf('.') + 1)).join(', ')}</p>
	{#if mostDiversePreview}
		<p>Most diverse preview: {mostDiversePreview.context.provider}</p>
		<img src="/BoardDescriptions/{board.moduleDescription.module}/{mostDiversePreview.context.preview.render}" alt="{mostDiversePreview.context.provider}">
	{/if}
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

<style>
	img {
		max-height: 70vh;
		max-width: 80vw;
	}
</style>