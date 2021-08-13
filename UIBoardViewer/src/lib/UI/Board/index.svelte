<script lang=ts>
	import type { LimitedDepthBrowserContext } from '$lib/model/browserContext';

	import SimpleTree from '$lib/UI/SimpleTree/index.svelte'
	
	export let context: LimitedDepthBrowserContext

	let mainComponentAspect = 1
	$: mainComponentAspect = context.mainPreview.info.viewport[1][0] / context.mainPreview.info.viewport[1][1]
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
				<div>{parent}</div>
			{/each}
		</div>
		<div class="MainComponent-container">
			<svg viewBox="0 0 300 500" style="width: {20}vw; height: {20 / mainComponentAspect}vw">
				<rect x="0" y="0" width="100%" height="100%" fill="gray"></rect>
				<circle r=145 cx=150 cy=200></circle>
			</svg>
			<div class="show-code">Show code</div>
		</div>
		<div class="GenericChildren-container">
			<SimpleTree data={context.subtree}></SimpleTree>
		</div>
	</section>
	<footer>
		<div>Visible subcomponents</div>
		<div class="VisibleSubcomponents-scrolling-container">
			{#each context.visibleViewReferences as child}
				<a href={child.href}>
					<img src="/BoardDescriptions/{child.image}" alt="{child.title}">
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

	.MainComponent-container .show-code {
		text-align: right;
	}

	.GenericChildren-container {
		flex-grow: 1;
		position: relative;
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
		overflow-y: scroll;
	}
	.ParentViews-container > div {
		width: 100px;
		height: 100px;
		flex-shrink: 0;
		background-color: green;
		margin-top: 1em;
	}
	.ParentViews-container > div:first-child {
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