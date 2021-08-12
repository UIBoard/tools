<script context="module">
	import {loadBoard} from './_loadBoard'

	export async function load({page, fetch, session, context}) {
		const viewPath = page.params.viewPath
		const viewPathComponents = viewPath.split('/')
		const mainViewIdentifier = (viewPath && viewPath.length > 0) ? viewPathComponents[viewPathComponents.length-1] : null
		console.log("page params", page.params)

		const boardResult = await loadBoard(page.params.module, fetch)
		const pageData = {}
		if (boardResult.ok) {
			pageData.props = {
				board: boardResult.board,
				mainViewIdentifier,
				mostDiversePreview: boardResult.board.mostDiversePreviews.get(mainViewIdentifier)
			}
		} else {
			pageData.status = boardResult.status
			pageData.error = boardResult.error
		}
		return pageData
	}
</script>

<script>
	import { createCompactTreeTraversalMaps, createOverview, createSubTreeFrom } from '$lib/model/tree';
	import SimpleTree from '$lib/UI/SimpleTree/index.svelte'

	export let board, mainViewIdentifier, mostDiversePreview
	// @ts-ignore
	const overview = createOverview(board.moduleDescription)

	function loadSmallTree(root) {
		console.log(root)
		const maps = createCompactTreeTraversalMaps(board.moduleDescription)
		const subtree = createSubTreeFrom({
			root,
			depthLimit: 4,
			visibleChildMap: maps.visibleChildMap,
			genericChildMap: board.moduleDescription.genericDecomposition
		})
		console.log(subtree)
		return subtree
	}
	// console.log('overview', overview)
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