<script>
	import { onMount } from 'svelte';

	let svgElement;

	onMount(drawTree);

	async function drawTree() {
		const d3 = await import('d3')
	
		const data = {
			name:"MovieSwift.root",
			children: [
				{name: "a", children: [{name: 'k'},{name: 'l'},{name: 'k'},{name: 'l'},{name: 'k'},{name: 'l'},]},
				{name: "b", children: [{name: 'm'},{name: 'n'}]},
				{name: "c", children: [{name: 'o'},{name: 'p'}]},
			]
		}

		const root = d3.hierarchy(data)
		const width = 600
		root.nodeHeight = 15
		root.nodeWidth = 200
		const layout = d3.tree().nodeSize([root.nodeHeight, root.nodeWidth])
		layout(root)

		let topBound = Infinity
		let bottomBound = -Infinity
		root.each(node => {
			if (node.x < topBound) topBound = node.x
			if (node.x > bottomBound) bottomBound = node.x
		})

		const container = d3.select(svgElement)
			.attr('viewBox', [0,0, width, bottomBound - topBound + root.nodeHeight * 2])

		const group = container
			.append('g')
			.attr("font-size", 12)
			.attr("transform", `translate(${root.nodeWidth / 3},${0})`)

		const links = group
			.append('g')
			.attr('fill', 'none')
			.attr('stroke', '#aaa')
			.attr('stroke-width', 1.5)
			.selectAll("path")
			.data(root.links())
			.join('path')
			.attr(
				'd',
				d3.linkHorizontal()
					.x(n => n.y)
					.y(n => n.x)
			)
	}
</script>

<svg bind:this={svgElement} class="tree">
	<rect></rect>
</svg>

<style>
	svg {
		position: absolute;
		width: 100%;
		height: 100%;
	}
</style>