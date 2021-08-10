<script context="module">
	import {getRoots} from '$lib/model/roots'
	import {createPreviewProviderDictionary, createViewCompositionMap} from '$lib/model/previews'

	const boardDescriptions = new Map()
	async function loadBoard(moduleName, fetch) {
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
					mostDiversePreviews: createViewCompositionMap(previewProviders)
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
	export let board, mainViewIdentifier, mostDiversePreview
	console.log(board)
	console.log(mostDiversePreview)
</script>

<h1>Browser</h1>
{#if mainViewIdentifier}
	<h2>{mainViewIdentifier}</h2>
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
{/if}

<style>
	img {
		max-height: 70vh;
		max-width: 80vw;
	}
</style>