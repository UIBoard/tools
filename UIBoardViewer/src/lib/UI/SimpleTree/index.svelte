<script>
	import { onMount } from 'svelte'
	import { flextree } from 'd3-flextree'

	let svgElement;
	export let data
	console.log(data)

	const width = 600
	const nodeHeight = 15
	const nodeWidth = width/8
	const layout = flextree({ nodeSize() { return [nodeHeight, nodeWidth] } })
	const root = layout.hierarchy(data)
	layout(root)

	let topBound = root.extents.left
	let bottomBound = root.extents.right
	const height = bottomBound - topBound
	console.log(topBound, bottomBound, height, root.extents)
	root.x = (topBound + bottomBound)/2
	
	onMount(drawTree);

	async function drawTree() {
		const d3 = await import('d3')

		const createHorizontalSpline = d3.linkHorizontal()
			.x(n => n.y)
			.y(n => n.x)

		const container = d3.select(svgElement)
			.attr('viewBox', [0,topBound, width, height])

		container
			.append('rect')
			.attr('class', 'background')
			.attr('y', topBound)
			.attr('width', width)
			.attr('height', height)

		const group = container
			.append('g')
			.attr("class", 'tree')

		const links = group
			.append('g')
			.attr('class', 'links')
			.selectAll("path")
			.data(root.links())
			.join('path')
			.attr('d', createHorizontalSpline)

		const nodes = group
			.append('g')
			.attr('class', 'nodes')
			.selectAll('g')
			.data(root.descendants())
			.join('g')
			.attr('transform', node => `translate(${node.y},${node.x})`)

		const circles = nodes
			.append('circle')
			.attr('r', 5)

		const text = nodes
			.append('text')
			.text(node => node.data.name.slice(6))
      .clone(true).lower()
      .attr("stroke", "white");
	}
</script>

<svg bind:this={svgElement} class="tree"></svg>

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

	svg :global(.nodes text) {
		font-size: 5px;
	}
</style>