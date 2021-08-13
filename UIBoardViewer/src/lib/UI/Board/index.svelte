<script lang=ts>
	import type { UIBoard } from '$lib/model/BoardDescription';

	import type { LimitedDepthBrowserContext } from '$lib/model/browserContext';

	import SimpleTree from '$lib/UI/SimpleTree/index.svelte'
	
	export let context: LimitedDepthBrowserContext

	let mainComponentAspect = 1, viewBox: string, mainPreviewInfo: UIBoard.PreviewInfo
	$: {
		mainPreviewInfo = context.mainPreview.info
		mainComponentAspect = mainPreviewInfo.viewport[1][0] / mainPreviewInfo.viewport[1][1]
		viewBox = mainPreviewInfo.viewport[0]
			.map(coordinate => coordinate - 1)
			.concat(mainPreviewInfo.viewport[1].map(size => size + 2) )
			.join(' ')
	}

	function regionsIn(preview: UIBoard.Preview) {
		var regions = []
		collect(preview.info.tags)
		return regions

		function collect(tag: UIBoard.ViewCollector) {
			for (const child of tag.children) {
				regions.push(child.visibleArea)
				collect(child.collector)
			}
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
			<svg viewBox={viewBox} style="width: {20}vw; height: {20 / mainComponentAspect}vw">
				<image
				  href={`/BoardDescriptions/${context.moduleName}/${context.mainPreview.render}`}
					width={ mainPreviewInfo.viewport[1][0]}
					height={mainPreviewInfo.viewport[1][1]}
					x={mainPreviewInfo.viewport[0][0]}
					y={mainPreviewInfo.viewport[0][1]}>
				</image>
				{#each regionsIn(context.mainPreview) as region}
					<rect
						class=region
						x={region[0][0]} y={region[0][1]} width={region[1][0]} height={region[1][1]}
						fill=none
						rx=10>
					</rect>
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
		<div class="VisibleSubcomponents-scrolling-container">
			{#each context.visibleViewReferences as child}
				<a href={child.href}>
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

	.MainComponent-container:hover rect.region {
		fill: rgba(0, 255, 0, 0.001);
		stroke: green;
		stroke-width: 1;
	}

	.MainComponent-container rect.region:hover {
		stroke-width: 2;
	}

	.MainComponent-container svg {
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.459);
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
		font-size: 10px;
	}

	.ParentViews-container > a > img {
		max-height: 100px;
		max-width: 70px;
		border-color: rgb(87, 140, 255);
	}
	.ParentViews-container > a > span {
		margin-top: 0.5em;
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