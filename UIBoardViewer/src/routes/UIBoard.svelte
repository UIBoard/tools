<svelte:head>
	<title>UIBoard</title>
</svelte:head>

<section class="UIBoard-container">
	<nav>Navigation bar</nav>
	<section class="ViewTree-container">
		<div class="ParentViews-container">Parents</div>
		<div class="MainComponent-container">
			<svg viewBox="0 0 200 400">
				<rect x="0" y="0" width="100%" height="100%" fill="white"></rect>
				<circle r=95 cx=100 cy=150></circle>
			</svg>
			<div class="show-code">Show code</div>
		</div>
		<div class="GenericChildren-container">Children</div>
	</section>
	<footer>
		<div>Footer</div>
		<div>Something else</div>
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
		margin: 0 1em;

		display: flex;
		flex-direction: column;
		justify-content: center;
	}

	.MainComponent-container svg {
		width: 20vw;
		height: 40vw;
	}

	.MainComponent-container .show-code {
		text-align: right;
	}

	.GenericChildren-container {
		flex-grow: 1;
	}

	/* debugging backgrounds */
	.UIBoard-container {
		background-color: orange;
	}

	nav, .ViewTree-container, footer, .ParentViews-container, .MainComponent-container, .GenericChildren-container {
		background-color: hsla(0, 0%, 100%, 20%);
	}
	
</style>