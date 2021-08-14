import type {UIBoard} from '../BoardDescription'
import { createPreviewProviderDictionary, createViewCompositionMap, PreviewComposition } from '../previewMaps'
import { getRoots } from './roots'

export function createOverview({roots, visibleChildMap, genericDecomposition, moduleName}: {roots: Set<string>, visibleChildMap: Map<string, Set<string>>, genericDecomposition: UIBoard.GenericComposition, moduleName: string}) {
	return Array.from(roots, expandToNode)

	function expandToNode(view: string): Node {
		const tree = reduceTree({
			name: view,
			children: getLinksFrom({
				view,
				visibilityList: visibleChildMap.get(view) ?? new Set(),
				parents: new Set(),
				visibleChildMap,
				genericDecomposition
			}),
			isVisibleInParent: false
		})
		const modulePrefix = moduleName + '.'
		const graphicalTree = convertNode(tree, [])
		graphicalTree.href = [moduleName, tree.name].join('/')
		return graphicalTree

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
}

export type SubTreeCreationArguments = {
	root: string
	depthLimit: number
	visibleChildMap: Map<string, Set<string>>
	genericDecomposition: UIBoard.GenericComposition
}

export function createSubTreeFrom({root, depthLimit, visibleChildMap, genericDecomposition}: SubTreeCreationArguments): Node {
	return trim(reduceTree( {
		name: root,
		children: getLinksFrom({
			view: root,
			visibilityList: visibleChildMap.get(root) ?? new Set(),
			parents: new Set(),
			visibleChildMap,
			genericDecomposition,
			depthLimit: depthLimit + 5,
			currentDepth: 1
		}),
		isVisibleInParent: false
	}), depthLimit)
}

function trim(tree: Node, depth: number): Node {
	if (depth < 2) {
		tree.children = []
	} else {
		for (const child of tree.children) {
			trim(child, depth - 1)
		}
	}
	return tree
}

function reduceTree(tree: Node): Node {
	const optimisation1 = removeVisibleLeafNodes(tree)
	const optimisation2 = removeOnlyVisibleChildNodes(optimisation1)
	return optimisation2
}

export function createCompactTreeTraversalMaps(moduleDescription: UIBoard.Description) {
	const previewMap = createPreviewProviderDictionary(moduleDescription.visualDecomposition)
	const previewDecomposition = createViewCompositionMap(previewMap)
	const visibleChildMap = new Map(Array.from(previewDecomposition.entries(), extractViewnames))
	const roots = getRoots(moduleDescription.genericDecomposition)
	return {previewMap, previewDecomposition, visibleChildMap, roots}

	function extractViewnames([name, previewComposition]: [string, PreviewComposition]): [string, Set<string>] {
		return [name, previewComposition.viewNames]
	}
}

type LinkConstructionArguments = {
	view: string,
	visibilityList: Set<string>
	parents: Set<string>
	visibleChildMap: Map<string, Set<string>>
	genericDecomposition: UIBoard.GenericComposition
	currentDepth?: number
	depthLimit?: number
}

export function getLinksFrom({view, visibilityList, parents, visibleChildMap, genericDecomposition, currentDepth = 0, depthLimit = Infinity}: LinkConstructionArguments): Node[] {
	const result: Node[] = []

	const genericChildren = genericDecomposition[view]
	if (currentDepth < depthLimit && genericChildren) {
		const visitedChildren = new Set<string>()
		const newParents = new Set(parents)
		newParents.add(view)
		for (const child of genericChildren) {
			if (newParents.has(child) || visitedChildren.has(child)) continue;
			visitedChildren.add(child)
			const linkConstructionArguments = {view: child, parents: newParents, visibleChildMap, genericDecomposition, depthLimit, currentDepth: currentDepth+1}
			if (visibilityList.has(child)) {
				const links = getLinksFrom({visibilityList, ...linkConstructionArguments})
				result.push({name: child, children: links, isVisibleInParent: true})
			} else {
				const links = getLinksFrom({visibilityList: visibleChildMap.get(child) ?? new Set(), ...linkConstructionArguments})
				result.push({name: child, children: links, isVisibleInParent: false})
			}
		}
	}

	return result
}

export interface Node {
	name: string //TODO rename identifier
	children: Node[]	
	isVisibleInParent: boolean
}

function removeOnlyVisibleChildNodes(tree: Node) {
	const pathsToVisit: number[][] = [[]]
	const optimizedTree: Node = {name: tree.name, isVisibleInParent: tree.isVisibleInParent, children: tree.children}
	let path = pathsToVisit.pop()
	while (path) {
		// Remove composition nodes that have no siblings
		const cursor = getElementAtPath({root: optimizedTree, path})
		let children = cursor.children
		while (children.length == 1 && children[0].isVisibleInParent) {
			children = children[0].children
			cursor.children = children
		}

		// visit children
		const pathsToChildren = children.map((_, index) => path.concat(index))
		pathsToVisit.push(...pathsToChildren)

		// visit rest
		path = pathsToVisit.pop()
	}
	return optimizedTree
}

function removeVisibleLeafNodes(tree: Node) {
	const pathsToVisit: number[][] = [[]]
	const optimizedTree: Node = {name: tree.name, isVisibleInParent: tree.isVisibleInParent, children: tree.children}
	
	for (let path = pathsToVisit.pop(); path; path = pathsToVisit.pop()) {
		// Remove composition nodes that have no siblings
		const node = getElementAtPath({root: optimizedTree, path})
		if (node.children.length == 0) {
			// Remove leaves that are visible in their parent
			let cursor = path
			while (cursor.length != 0) {
				const leaf = getElementAtPath({root: optimizedTree, path: cursor})
				if (!leaf.isVisibleInParent || leaf.children.length != 0) break;
				const indexToRemove = cursor.pop()
				getElementAtPath({root: optimizedTree, path: cursor}).children.splice(indexToRemove, 1)
			}
		} else {
			// Visit children
			let pathsToChildren = node.children.map((_, index) => path.concat(index))
			pathsToVisit.push(...pathsToChildren)
		}

	}
	return optimizedTree
}


interface Parent<Child> {
	children: Child[]
}

function getElementAtPath<Element extends Parent<Element>>({root, path}: {root: Element, path: number[]}): Element {
	if (path.length == 0) {return root}
	const retreiveChild = (cursor: Element, index: number) => cursor.children[index]
	return path.reduce(retreiveChild, root)
}