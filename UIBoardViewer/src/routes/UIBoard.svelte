<svelte:head>
	<title>UIBoard</title>
</svelte:head>

<script>
	import Chart from '$lib/Tree/index.svelte'
	
	const parents = 'abcdefgh'.split("")
	const visualChildren = 'abcdefghijklmn'.split("")
	const breadcrumbPath = ['Component A', 'Component B']
	const mainComponentAspect = 3/5
</script>

<section class="UIBoard-container">
	<nav>
		<div><img src="/house.fill.png" alt="home"></div>
		<div>
			<img src="/chevron.left.png" alt="back">
			<img src="/chevron.right.png" alt="forward">
		</div>
		<ol>
			{#each breadcrumbPath as crumb}
				<li>{crumb}</li>
			{/each}
		</ol>
	</nav>
	<section class="ViewTree-container">
		<div class="ParentViews-container">
			{#each parents as parent}
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
			<Chart></Chart>
		</div>
	</section>
	<footer>
		<div>Visible subcomponents</div>
		<div class="VisibleSubcomponents-scrolling-container">
			{#each visualChildren as child}
				<div>{child}</div>
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
	.VisibleSubcomponents-scrolling-container > div {
		width: 100px;
		height: 100px;
		flex-shrink: 0;
		background-color: green;
		margin-left: 1em;
	}
	.VisibleSubcomponents-scrolling-container > div:first-child {
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