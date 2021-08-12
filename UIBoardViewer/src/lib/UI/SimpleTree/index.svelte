<script>
	import { onMount } from 'svelte'
	import { flextree } from 'd3-flextree'

	let svgElement;
	export let data

	const width = 600
	const nodeHeight = 15
	const nodeWidth = width/4
	
	let root, topBound, bottomBound, height
	$: {
		console.log('recalculating beast')
		const layout = flextree({ nodeSize() { return [nodeHeight, nodeWidth] } })
		const hier = layout.hierarchy(data)
		root = layout(hier)

		topBound = Infinity
		bottomBound = -Infinity
		root.each(node => {
			if (node.x < topBound) topBound = node.x
			if (node.x > bottomBound) bottomBound = node.x
		})	
		height = bottomBound - topBound
		console.log(topBound, bottomBound, height, root.extents)
		root.x = (topBound + bottomBound)/2

		redraw(root)
	}

	let d3, linksGroup, nodesGroup, createHorizontalSpline, container, group
	
	onMount(drawTree);

	async function drawTree() {
		d3 = await import('d3')

		createHorizontalSpline = d3.linkHorizontal()
			.x(n => n.y)
			.y(n => n.x)

		container = d3.select(svgElement)

		group = container
			.append('g')
			.attr("class", 'tree')

		linksGroup = group
			.append('g')
			.attr('class', 'links')

		nodesGroup = group
			.append('g')
			.attr('class', 'nodes')
		
		redraw(root)
	}

	function redraw(source) {
		if (d3) {
			const descendants = source.descendants()
			console.log('redraw', source.data.name, root)
			// console.log(descendants)
			container
				.attr('viewBox', [0,topBound, width, height])

			linksGroup
				.selectAll("path")
				.data(root.links())
				.join('path')
				.attr('d', createHorizontalSpline)

			const nodes = nodesGroup
				.selectAll('g')
				.data(descendants, node => node.data.name)

			const newNodes = nodes
				.enter()
				.append('g')

			newNodes
				.attr('transform', node => `translate(${node.y},${node.x})`)
			nodes
				.attr('transform', node => `translate(${node.y},${node.x})`)

			nodes.exit().remove()

			const circles = nodes.selectAll('circle')
			const newCircles = newNodes
				.append('circle')
				.attr('r', 5)
			updateCircle(circles, 'update')
			updateCircle(newCircles, 'new')
				
			const texts = nodes.selectAll('text')
			const newTexts = newNodes
				.append('text')
			updateText(texts)
			updateText(newTexts)
		}

		function updateCircle(circles, context) {
			circles.attr('class', node => {
				console.log(context, node.data.name, node.data.isVisibleInParent, node.root.data.name)
				return node.data.isVisibleInParent ? 'visible' : ''
			})
		}
		function updateText(texts) {
			texts.text(node => node.data.name.slice(6))
		}
	}
</script>

<svg bind:this={svgElement} class="tree"></svg>

<style>
	svg {
		width: 92vw;
		height: 23vw;
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
		fill: rgb(255, 62, 62);
	}

	svg :global(.nodes text) {
		font-size: 10px;
	}
</style>