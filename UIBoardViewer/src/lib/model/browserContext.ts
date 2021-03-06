import {createSubTreeFrom} from './trees/views'
import type {Node} from './trees/views'
import type {UIBoard} from './BoardDescription'
import type {PreviewDecomposition} from './previewMaps'

type LimitedDepthBrowserCreationArguments = {
	root: string
	visibleChildMap: Map<string, Set<string>>
	genericDecomposition: UIBoard.GenericComposition
	parentMap: Map<string, Set<string>>
	mostDiversePreviews: PreviewDecomposition
	moduleName: string,
	path: string[],
	moduleRoots: string[]
}

export type LimitedDepthBrowserContext = {
	moduleName: string
	moduleRoots: string[]
	subtree: CompactImageTree;
	mainPreview?: UIBoard.Preview;
	visibleViewReferences: BrowserReference[]
	incomingReferences: BrowserReference[]
	breadcrumbPath: BrowserReference[]
}

type BrowserReference = {
	view: string
	title: string
	href: string
	image?: string
}

export function createLimitedDepthBrowserContext({root, moduleName, path, visibleChildMap, genericDecomposition, parentMap, mostDiversePreviews, moduleRoots}: LimitedDepthBrowserCreationArguments): LimitedDepthBrowserContext {
	const modulePrefix = moduleName + '.'

	const subtree = createSubTreeFrom({depthLimit: 3, root, visibleChildMap, genericDecomposition})
	const previewProvider = mostDiversePreviews.get(root)
	let visibleViews = []
	if (previewProvider) {
		visibleViews = Array.from(previewProvider.viewNames)
			.filter(name => name != root) // TODO: Remove this because root should not be in this list
			.map(createOutgoingReference)
	}
	const treeWithImages = createCompactImageTree(subtree, mostDiversePreviews, modulePrefix)
	const incomingReferences = Array.from(parentMap.get(root) ?? [], createIncomingReference)

	return {
		subtree: treeWithImages,
		mainPreview: previewProvider?.context.preview,
		visibleViewReferences: visibleViews,
		breadcrumbPath: path.map((nodeName, index, path) => createBreadcrumbReference(nodeName, path.slice(0,index+1))),
		incomingReferences,
		moduleName,
		moduleRoots
	}

	function pathToPreviewImage(preview?: UIBoard.Preview) {
		if (preview)
			return '/BoardDescriptions/' + moduleName + '/' + preview.render
	}
	function createIncomingReference(nodeName: string): BrowserReference {
		return {
			title: nodeName.replace(modulePrefix, ''),
			href: `/browser/${moduleName}/${nodeName}`, // Todo add better path
			image: pathToPreviewImage(mostDiversePreviews.get(nodeName)?.context.preview),
			view: nodeName
		}
	}
	function createOutgoingReference(nodeName: string): BrowserReference {
		return {
			title: nodeName.replace(modulePrefix, ''),
			href: `${root}/${nodeName}`, // Todo add better path
			image: pathToPreviewImage(mostDiversePreviews.get(nodeName)?.context.preview),
			view: nodeName
		}
	}
	function createBreadcrumbReference(nodeName: string, path: string[]): BrowserReference {
		return {
			title: nodeName.replace(modulePrefix, ''),
			href: ['','browser', moduleName].concat(path).join('/'), // Todo add better path
			image: pathToPreviewImage(mostDiversePreviews.get(nodeName)?.context.preview),
			view: nodeName
		}
	}
}

function createCompactImageTree(rootNode: Node, mostDiversePreviews: PreviewDecomposition, modulePrefix: string): CompactImageTree {
	const firstChildren = rootNode.children.map( node => {
		const preview = mostDiversePreviews.get(node.name)
		return {
			title: node.name.replace(modulePrefix, ''),
			fullName: node.name,
			href: rootNode.name + '/' + node.name,
			children: node.children.map(child => convertNode(child, [rootNode.name, node.name])),
			isVisibleInParent: node.isVisibleInParent,
			previewContext: preview ? {
				prefix: '/BoardDescriptions/' + modulePrefix.replace('.', '/'),
				preview: preview.context.preview,
				scale: 1/rootNode.children.length
			} : undefined
		}
	})

	return {
		title: '',
		fullName: rootNode.name,
		children: firstChildren,
		href: rootNode.name,
		isVisibleInParent: false
	}

	function convertNode(node: Node, path: string[]): NavigatableNode {
		return {
			title: node.name.replace(modulePrefix, ''),
			fullName: node.name,
			href: path.concat(node.name).join('/'),
			children: node.children.map(child => convertNode(child, path.concat(node.name))),
			isVisibleInParent: node.isVisibleInParent
		}
	}
}

export type CompactImageTree = NavigatableNode & {
	children: PreviewableNode[],
}

type PreviewableNode = NavigatableNode & {
	previewContext?: {
		preview: UIBoard.Preview,
		scale: number
	}
}

type NavigatableNode = {
	title: string
	fullName: string
	href: string
	children: NavigatableNode[],
	isVisibleInParent: boolean
}

// Maps a child to its parents
export function createGenericParentMap(genericChilds: UIBoard.GenericComposition): Map<string, Set<string>> {
	const parentMap = new Map<string, Set<string>>()
	const childMap = new Map(Array.from(Object.entries(genericChilds), ([parent, children]) => [parent, new Set(children)]))

	for (const [parent, children] of childMap) {
		for (const child of children) {
			if (child != parent) {
				if (parentMap.has(child)) {
					parentMap.get(child).add(parent)
				} else {
					parentMap.set(child, new Set([parent]))
				}
			}
		}
	}

	return parentMap
}