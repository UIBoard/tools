<script>
	import { flextree } from 'd3-flextree'
	import { hierarchy } from 'd3-hierarchy'
	import { linkHorizontal } from 'd3-shape'
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher();

	let svgElement;
	export let data

	const width = 800
	const nodeHeight = 10
	
	let root, topBound, bottomBound, height, nodeWidth
	$: {
		transformTree(data, node => {
			if (node.previewContext) {
				const originalSize = node.previewContext.preview.info.viewport[1]
				node.flexHeight = 80 / originalSize[0] * originalSize[1]
			} else {
				node.flexHeight = nodeHeight
			}
		})
		const hierarchicalData = hierarchy(data)
		nodeWidth = width / (hierarchicalData.height + 1)
		const layout = flextree({
			nodeSize(node) {
				return [node.data.flexHeight, nodeWidth]
			},
			spacing(left, right) { return left.parent == right.parent ? 5 : 10 }
		})
		const flexHData = layout.hierarchy(data)
		root = layout(flexHData)

		topBound = root.extents.left - 3
		bottomBound = root.extents.right + 3
		height = bottomBound - topBound
		root.x = (topBound + bottomBound)/2
	}
	
	function transformTree(node, transform) {
		transform(node)
		for (const child of node.children) {
			transformTree(child, transform)
		}
	}

	const createHorizontalSpline = linkHorizontal()
		.x(n => n.y)
		.y(n => n.x)		
</script>

<svg bind:this={svgElement} class="tree" viewBox="0 {topBound} {width} {height}">
	<g class=tree>
		<g class="links">
			{#each root.links() as link}
				<path d={createHorizontalSpline(link)}></path>
			{/each}
		</g>
		<g class="nodes">
			{#each root.descendants() as node}
				<g class=node transform="translate({node.y},{node.x})">
					<a href={node.data.href} on:mouseenter={event => dispatch('hoverView', {hover: true, view: node.data.fullName})} on:mouseleave={e=> dispatch('hoverView', {hover: false})}>
						<circle r=4 class={node.data.isVisibleInParent ? 'visible' : ''}></circle>
						{#if node.data.previewContext}
							<g class=text transform="translate(-10,3)" text-anchor=end>
								<text class=background>{node.data.title}</text>								
								<text>{node.data.title}</text>
							</g>
							<g transform="translate(10,{-node.data.flexHeight / 2})">
								<rect width=80 height={node.data.flexHeight} stroke=gray fill=none></rect>
								<image
									width=80
									height={node.data.flexHeight}
									href={node.data.previewContext.prefix+node.data.previewContext.preview.render}>
								</image>
							</g>
						{:else}
							<g class=text transform="translate(10,3)">
								<text class=background>{node.data.title}</text>								
								<text>{node.data.title}</text>
							</g>						
						{/if}
					</a>
				</g>
			{/each}
		</g>
	</g>
</svg>

<style>
	svg {
		position: absolute;
		width: 100%;
		height: 100%;
	}

	svg :global(.background) {
		fill: rgba(255, 166, 0, 0.26);
	}

	svg :global(.links) {
		fill: none;
		stroke: rgba(32, 32, 32, 0.274);
		stroke-width: 1.5;
	}

	svg :global(.nodes circle) {
		fill: rgb(173, 173, 173);
	}

	svg :global(.nodes circle.visible) {
		fill: green;
	}

	svg :global(.nodes) {
		font-size: 10px;
	}

	svg :global(.nodes text.background) {
		fill: transparent;
		stroke: white;
		stroke-width: 3;
		stroke-linejoin: round;
	}
</style>