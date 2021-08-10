<script>
	import { onMount } from 'svelte'
	import { flextree } from 'd3-flextree'

	let svgElement;

	const data = {
		name:"MovieSwift.root",
		children: [
			{
				name: "a",
				image: 'BoardDescriptions/Fruta/renders/RecipeList_Previews/0.jpeg',
				children: [
					{name: 'k'},{name: 'l'},{name: 'k'},{name: 'l'},{name: 'k'},{name: 'l'},
				]
			},
			{
				name: "b",
				image: 'BoardDescriptions/Fruta/renders/RecipeList_Previews/0.jpeg',
				children: [
					{name: 'm'},
					{name: 'n'}
				]
			},
			{
				name: "c",
				image: 'BoardDescriptions/Fruta/renders/RecipeList_Previews/0.jpeg',
				size: 60, hasSize: true, children: [
					{name: 'o'},
					{name: 'p'}
				]
			},
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

		const allNodes = nodes
			.append('circle')
			.attr('r', 5)

		const middleNodes = nodes
			.filter(node => node.parent == root)
			.append('image')
			.attr('href', node => node.data.image)
			.attr('width', 20)
			.attr('height', 20)
			.attr('x', -10)
			.attr('y', -10)
			// .attr('href', node => node.data.image)
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

	svg :global(.background) {
		fill: rgba(255, 166, 0, 0.26);
	}

	svg :global(.links) {
		fill: none;
		stroke: #aaa;
		stroke-width: 1.5;
	}

	svg :global(.nodes circle) {
		fill: rgba(0, 0, 0, 0.377);
	}

	/* svg :global(.nodes image) {
		width: 15;
		height: 15;
	} */
</style>