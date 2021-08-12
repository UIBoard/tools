import {createSubTreeFrom} from './trees/views'
import type {Node} from './trees/views'
import type {UIBoard} from './BoardDescription'
import { getAllContainedVisibleViewsFromPreview } from './previewMaps'
import type {PreviewDecomposition, PreviewComposition} from './previewMaps'

type LimitedDepthBrowserCreationArguments = {
	root: string
	visibleChildMap: Map<string, Set<string>>
	genericDecomposition: UIBoard.GenericComposition
	parentMap: Map<string, Set<string>>
	mostDiversePreviews: PreviewDecomposition
	moduleName: string
}

export type LimitedDepthBrowserContext = {
	subtree: CompactImageTree;
	previewProvider: PreviewComposition;
	preview: UIBoard.Preview;
	visibleViews: Set<string>;
	parentMap: Map<string, Set<string>>;
}

export function createLimitedDepthBrowserContext({root, moduleName, visibleChildMap, genericDecomposition, parentMap, mostDiversePreviews}: LimitedDepthBrowserCreationArguments): LimitedDepthBrowserContext {
	const subtree = createSubTreeFrom({depthLimit: 3, root, visibleChildMap, genericDecomposition})
	const previewProvider = mostDiversePreviews.get(root)
	const preview = previewProvider.context.preview
	const visibleViews = getAllContainedVisibleViewsFromPreview(preview)	
	const modulePrefix = moduleName + '.'

	const firstChildren = subtree.children.map( node => ({
		title: node.name.replace(modulePrefix, ''),
		fullName: node.name,
		href: subtree.name + '/' + node.name,
		children: node.children.map(child => convertNode(child, [subtree.name, node.name])),
		isVisibleInParent: node.isVisibleInParent,
		previewContext: {
			preview: mostDiversePreviews.get(root).context.preview,
			scale: 1/subtree.children.length
		}
	}))

	const enhancedSubtree: CompactImageTree = {
		title: '',
		fullName: subtree.name,
		children: firstChildren,
		href: root,
		isVisibleInParent: false
	}

	return {subtree: enhancedSubtree, previewProvider, preview, visibleViews, parentMap}

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

type CompactImageTree = NavigatableNode & {
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