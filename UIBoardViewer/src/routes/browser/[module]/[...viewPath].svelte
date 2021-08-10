<script context="module">
	import {getRoots} from '$lib/model/tree'
	export async function load({page, fetch, session, context}) {
		const viewPath = page.params.viewPath
		const viewPathComponents = viewPath.split('/')
		console.log(`viewPath: '${viewPath}'`)

		const descriptionUrl = `/BoardDescriptions/${page.params.module}/index.json`
		const descriptionResult = await fetch(descriptionUrl)
		if (descriptionResult.ok) {
			const description = await descriptionResult.json()
			const roots = getRoots(description.genericDecomposition)
			const mainViewIdentifier = (viewPath && viewPath.length > 0) ? viewPathComponents[viewPathComponents.length-1] : null
			return {
				props: {
					description,
					roots,
					mainViewIdentifier
				}
			}
		} else {
			// console.log('not OK', descriptionResult)
		}

		return {
			status: descriptionResult.status,
			error: new Error(`Could not load ${descriptionUrl}`)
		}
	}
</script>

<script>
	export let description, roots, mainViewIdentifier
	// console.log(mainViewIdentifier)
</script>

<h1>Browser</h1>
{#if mainViewIdentifier}
	<h2>{mainViewIdentifier}</h2>
	<ul>
		{#each description.genericDecomposition[mainViewIdentifier] as relatedView}
			<li><a href="{mainViewIdentifier}/{relatedView}">{relatedView}</a></li>
		{/each}
	</ul>
{:else}
	<h2>Module {description.module}</h2>
	<p>This module has the following root views</p>
	<ul>
		{#each Array.from(roots) as root}
			<li><a href="{description.module}/{root}">{root}</a></li>
		{/each}
	</ul>
{/if}