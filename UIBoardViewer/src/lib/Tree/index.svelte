<script>
	import { onMount } from 'svelte'
	import { flextree } from 'd3-flextree'

	let svgElement;

	const data = {
		name:"MovieSwift.root",
		children: [
			{name: "a", children: [{name: 'k'},{name: 'l'},{name: 'k'},{name: 'l'},{name: 'k'},{name: 'l'},]},
			{name: "b", children: [{name: 'm'},{name: 'n'}]},
			{name: "c", size: 60, hasSize: true, children: [{name: 'o'},{name: 'p'}]},
		]
	}

	const layout = flextree({
		nodeSize(node) {
			if (node.data.hasSize) return [node.data.size, 300]
			else return [nodeHeight, nodeWidth]
		}
	})
	const width = 600
	const nodeHeight = 15
	const nodeWidth = width/2
	const root = layout.hierarchy(data)
	layout(root)

	let topBound = Infinity
	let bottomBound = -Infinity
	root.each(node => {
		console.log(node)
		if (node.left < topBound) topBound = node.left
		if (node.right > bottomBound) bottomBound = node.right
	})
	const height = bottomBound - topBound
	console.log(topBound, bottomBound, height)
	
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
			.attr('y', topBound)
			.attr('width', width)
			.attr('height', height)
			.attr('fill', 'orange')
			.attr('opacity', 0.2)

		const group = container
			.append('g')
			.attr("font-size", 12)

		const links = group
			.append('g')
			.attr('fill', 'none')
			.attr('stroke', '#aaa')
			.attr('stroke-width', 1.5)
			.selectAll("path")
			.data(root.links())
			.join('path')
			.attr('d', createHorizontalSpline)

		const nodes = group
			.append('g')
			.selectAll('g')
			.data(root.descendants())
			.join('g')
			.append('circle')
			.attr('cx', node => node.y)
			.attr('cy', node => node.x)
			.attr('r', 5)
			.attr('fill', 'red')
	}
</script>

<svg bind:this={svgElement} class="tree">
	<circle r="7.5" cy="-97.5" cx=570></circle>
</svg>

<style>
	svg {
		position: absolute;
		width: 100%;
		height: 100%;
	}
</style>