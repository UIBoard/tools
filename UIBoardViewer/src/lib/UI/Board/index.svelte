<script lang=ts>
	import type { UIBoard } from '$lib/model/BoardDescription';
	import {browser} from '$app/env'

	import type { LimitedDepthBrowserContext } from '$lib/model/browserContext';

	import SimpleTree from '$lib/UI/SimpleTree/index.svelte'
	import { onMount } from 'svelte';
	
	export let context: LimitedDepthBrowserContext

	let mainComponentAspect = 0.2, viewBox: string, mainPreviewInfo: UIBoard.PreviewInfo
	$: {
		mainPreviewInfo = context.mainPreview.info
		mainComponentAspect = mainPreviewInfo.viewport[1][0] / mainPreviewInfo.viewport[1][1]
		viewBox = mainPreviewInfo.viewport[0]
			.map(coordinate => coordinate - 1)
			.concat(mainPreviewInfo.viewport[1].map(size => size + 2) )
			.join(' ')
	}

	let regions: ClickableCollectedView[]
	$: {
		if (context && context.mainPreview) regions = regionsIn(context.mainPreview)
	}

	const doc = (browser ? document : {createElement(): HTMLElement {return {} as HTMLElement}})
	const highlightStyleContainer = doc.createElement('style')
	onMount(addHighlightStyleContainer)

	function regionsIn(preview: UIBoard.Preview) {
		var regions: ClickableCollectedView[] = []
		collect(preview.info.tags, [])
		return regions

		function collect(tag: UIBoard.ViewCollector, path: string[]) {
			for (const child of tag.children) {
				const newPath = path.concat(child.type)
				regions.push({...child, href: newPath.join('/')})
				collect(child.collector, newPath)
			}
		}
	}

	type ClickableCollectedView = UIBoard.CollectedView & {href: string}

	function highlightRegionsOfType(view: string) {
		highlightStyleContainer.innerHTML = `
			svg rect.view-type-${view.replace('.', '\\.')} {
				stroke-width: 4;
				stroke: green;
			}
		`
	}

	function removeHighlight() {
		highlightStyleContainer.innerHTML = ''
	}

	function highlightViewsOfType(view: string) {
		const className = '.view-type-' + view.replace('.', '\\.')
		highlightStyleContainer.innerHTML = `
			footer a${className} img {
				box-shadow: 0 0 10px green;
			}

			footer a${className} {
				color: green;
			}
		`
	}

	function addHighlightStyleContainer() {
		document.head.appendChild(highlightStyleContainer)

		return removeStyle // called when unmounted
		function removeStyle() {
			document.head.removeChild(highlightStyleContainer)
		}
	}
</script>

<section class="UIBoard-container">
	<nav>
		<div><img src="/house.fill.png" alt="home"></div>
		<div>
			<img src="/chevron.left.png" alt="back">
			<img src="/chevron.right.png" alt="forward">
		</div>
		<ol>
			{#each context.breadcrumbPath as crumb}
				<li><a href={crumb.href}>{crumb.title}</a></li>
			{/each}
		</ol>
	</nav>
	<section class="ViewTree-container">
		<div class="ParentViews-container">
			{#each context.incomingReferences as parent}
				<a href={parent.href}>
					<img src={parent.image ?? '/NoPreview.png'} alt="{parent.title}">
					<span>{parent.title}</span>
				</a>
			{/each}
		</div>
		<div class="MainComponent-container">
			<svg viewBox={viewBox} style="width: {20}vw; height: {20 / mainComponentAspect}vw" on:mouseleave={event => removeHighlight()}>
				<image
				  href={`/BoardDescriptions/${context.moduleName}/${context.mainPreview.render}`}
					width={ mainPreviewInfo.viewport[1][0]}
					height={mainPreviewInfo.viewport[1][1]}
					x={mainPreviewInfo.viewport[0][0]}
					y={mainPreviewInfo.viewport[0][1]}>
				</image>
				{#each regions as region}
					<a href={region.href}>
						<rect
							class='region view-type-{region.type}'
							x={region.visibleArea[0][0]} y={region.visibleArea[0][1]} width={region.visibleArea[1][0]} height={region.visibleArea[1][1]}
							fill=none
							rx=10
							on:mouseenter={event => highlightViewsOfType(region.type)}>
						</rect>
					</a>
				{/each}
			</svg>
			<div class="show-code">Show code</div>
		</div>
		<div class="GenericChildren-container">
			<SimpleTree data={context.subtree}></SimpleTree>
		</div>
	</section>
	<footer>
		<div>{context.visibleViewReferences.length == 0 ? "No visible subcomponents" : "Visible subcomponents"}</div>
		<div class="VisibleSubcomponents-scrolling-container" on:mouseleave={event => removeHighlight()}>
			{#each context.visibleViewReferences as child}
				<a href={child.href} class="view-type-{child.view}" on:mouseenter={event => highlightRegionsOfType(child.view)}>
					<img src={child.image ?? '/NoPreview.png'} alt="{child.title}">
					<span>{child.title}</span>
				</a>
			{/each}
		</div>
	</footer>
</section>

<style>
	/* Reset default browser margins */
	:global(html, body) {
		margin: 0;
		padding: 0;
	}

	.UIBoard-container {
		height: 100vh;
		width: 100vw;
		display: flex;
		padding: 1em;
		box-sizing: border-box;
		flex-direction: column;
		font-family:'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
	}

	nav {
		display: flex;
	}

	nav > div {
		margin-right: 1em;
	}

	nav > ol {
		list-style: none;
		display: flex;
		margin: 0;
		padding: 0;
	}

	nav > ol > li:not(:last-child)::after {
		padding: 0 0.5em;
		content: '>';
	}

	nav, footer {
		flex-grow: 0;
	}

	.ViewTree-container {
		/* Flex child (of UIBoard-container) */
		flex-grow: 1;
		margin: 1em 0;

		/* Flex container */
		display: flex;
		flex-direction: row;
		overflow: scroll;
	}

	.ParentViews-container {
		flex-grow: 0;
	}

	.MainComponent-container {
		flex-grow: 0;
		margin-right: 1em;
		margin-left: 2em;

		display: flex;
		flex-direction: column;
		justify-content: center;
	}

	.MainComponent-container svg:hover rect.region {
		fill: rgba(0, 255, 0, 0.001);
		stroke: rgba(0, 128, 0, 0.5);
		stroke-width: 1;
	}

	.MainComponent-container svg:hover rect.region:hover {
		stroke-width: 2;
		stroke: green;
	}

	.MainComponent-container svg {
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.459);
		border-radius: 10px;
	}

	.MainComponent-container .show-code {
		text-align: right;
	}

	.GenericChildren-container {
		flex-grow: 1;
		position: relative;
	}

	.ParentViews-container > a > img, .VisibleSubcomponents-scrolling-container > a > img {
		border: 1px solid;
		border-radius: 5px;
	}

	.ParentViews-container > a, .VisibleSubcomponents-scrolling-container > a {
		text-decoration: none;
		color: black;
		font-size: 10px;
	}

	.ParentViews-container > a span, .VisibleSubcomponents-scrolling-container > a span {
		text-overflow: ellipsis;
		overflow: hidden;
		max-height: 3em;
	}

	.VisibleSubcomponents-scrolling-container {
		display: flex;
		padding-top: 0.5em;
		overflow-x: scroll;
	}
	.VisibleSubcomponents-scrolling-container > a {
		flex-shrink: 0;
		margin-left: 1em;

		display: flex;
		flex-direction: column;
		justify-content: flex-end;
		align-items: center;
	}
	.VisibleSubcomponents-scrolling-container > a > img {
		max-height: 100px;
		max-width: 150px;
		border-color: green;
	}
	.VisibleSubcomponents-scrolling-container > a > span {
		margin-top: 0.5em;
		max-width: 150px;
	}
	.VisibleSubcomponents-scrolling-container > a:first-child {
		margin-left: 0;
	}

	.ParentViews-container {
		display: flex;
		flex-direction: column;
		justify-content: center;
		overflow-y: scroll;
	}
	.ParentViews-container > a {
		flex-shrink: 0;
		margin-top: 1em;

		display: flex;
		flex-direction: column;
		justify-content: flex-end;
		align-items: center;
	}

	.ParentViews-container > a > img {
		max-height: 100px;
		max-width: 70px;
		border-color: rgb(167, 167, 167);
	}
	.ParentViews-container > a > span {
		margin-top: 0.5em;
		max-width: 70px;
	}

	.ParentViews-container > a:first-child {
		margin-top: 0;
	}

	/* debugging backgrounds */
	/* .UIBoard-container {
		background-color: orange;
	}

	nav, .ViewTree-container, footer, .ParentViews-container, .MainComponent-container, .GenericChildren-container {
		background-color: hsla(0, 0%, 100%, 20%);
	} */
	
</style>