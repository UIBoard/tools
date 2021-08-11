<script context="module">
	export async function load({page, fetch, session, context}) {
		const frutaDescriptionUrl = '/BoardDescriptions/Fruta/index.json'
		const frutaDescription = await fetch(frutaDescriptionUrl)
		if (frutaDescription.ok) {
			console.log(frutaDescription)
			return {
				props: {
					description: await frutaDescription.json()
				}
			}
		} else {
			console.log(frutaDescription.ok, frutaDescription)
		}

		return {
			status: frutaDescription.status,
			error: new Error(`Could not load ${frutaDescriptionUrl}`)
		}
	}
</script>


<script lang="ts">
	import type { UIBoard } from '$lib/model/BoardDescription'
	export let description: UIBoard.Description

	console.log(description)

	const recipeListPreviewProvider = description.visualDecomposition[22]

	function regionsIn(preview) {
		var regions = []
		collect(preview.info.tags)
		return regions

		function collect(tag) {
			for (const child of tag.children) {
				regions.push(child.visibleArea)
				collect(child.collector)
			}
		}
	}
</script>

<h1>{recipeListPreviewProvider.identifier}</h1>
<div class="flexbox">
	{#each recipeListPreviewProvider.previews as preview}
	<svg viewBox="{preview.info.viewport.flat().join(' ')}" width={preview.info.viewport[1][0]} height={preview.info.viewport[1][1]}>
		<image
			href="BoardDescriptions/Fruta/{preview.render}"
			x={preview.info.viewport[0][0]}
			width={preview.info.viewport[1][0]}
			height={preview.info.viewport[1][1]}>
		</image>
		{#each regionsIn(preview) as region}
			<rect
				x={region[0][0]} y={region[0][1]} width={region[1][0]} height={region[1][1]}
				fill=none
				stroke=red
				rx=10>
			</rect>
		{/each}
	</svg>
	{/each}
</div>

<style>
	div {
		display: flex;
		justify-content: space-evenly;
	}
</style>