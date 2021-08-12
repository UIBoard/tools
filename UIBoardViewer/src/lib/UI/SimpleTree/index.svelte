<script>
	import { onMount } from 'svelte'
	import { flextree } from 'd3-flextree'
	import { hierarchy } from 'd3-hierarchy'
	import { linkHorizontal } from 'd3-shape'
	import { select } from 'd3-selection'

	let svgElement;
	export let data

	const width = 600
	const nodeHeight = 15
	
	let root, topBound, bottomBound, height, nodeWidth
	$: {
		console.log('recalculating beast')
		const hierarchicalData = hierarchy(data)
		nodeWidth = width / (hierarchicalData.height + 1)
		const layout = flextree({
			nodeSize() { return [nodeHeight, nodeWidth] },
			spacing(left, right) { return left.parent == right.parent ? 0 : 10 }
		})
		const flexHData = layout.hierarchy(data)
		root = layout(flexHData)

		topBound = root.extents.left
		bottomBound = root.extents.right
		height = bottomBound - topBound
		console.log(topBound, bottomBound, height, root.extents)
		root.x = (topBound + bottomBound)/2

		redraw(root)
	}

	let linksGroup, nodesGroup, container, group, back
	const createHorizontalSpline = linkHorizontal()
			.x(n => n.y)
			.y(n => n.x)
	
	onMount(drawTree);

	async function drawTree() {
		container = select(svgElement)

		// back = container
		// 	.append('rect')

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
		if (container) {
			// back
			// 	.attr('width', 600)
			// 	.attr('height', height)
			// 	.attr('y', topBound)
			// 	.attr('class', 'background')

			const descendants = source.descendants()
			container
				.attr('viewBox', [0,topBound, width, height])

			linksGroup
				.selectAll("path")
				.data(root.links())
				.join('path')
				.attr('d', createHorizontalSpline)

			const nodes = nodesGroup
				.selectAll('g')
				.data(descendants, node => node.ancestors().reverse().map(node => node.data.name).join("/"))

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
			circles.attr('class', node => node.data.isVisibleInParent ? 'visible' : '')
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