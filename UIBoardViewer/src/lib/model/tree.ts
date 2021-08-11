import type {UIBoard} from './BoardDescription'
import { createPreviewProviderDictionary, createViewCompositionMap, PreviewComposition } from './previews'
import { getRoots } from './roots'

export function createOverview(description: UIBoard.Description) {
	const {roots, visualChildMap} = createCompactTreeTraversalMaps(description)
	return Array.from(roots, expandToNode)

	function expandToNode(view: string): Node {
		return {
			name: view,
			children: getLinksFrom({
				view,
				visibilityList: visualChildMap.get(view) ?? new Set(),
				parents: new Set(),
				visualChildMap,
				genericChildMap: description.genericDecomposition
			}),
			isVisibleInParent: false
		}
	}
}

type SubTreeCreationArguments = {
	root: string
	depthLimit: number
	visualChildMap: Map<string, Set<string>>
	genericChildMap: UIBoard.GenericComposition
}

export function createSubTreeFrom({root, depthLimit, visualChildMap, genericChildMap}: SubTreeCreationArguments) {
	return {
		name: root,
		children: getLinksFrom({
			view: root,
			visibilityList: visualChildMap.get(root) ?? new Set(),
			parents: new Set(),
			visualChildMap,
			genericChildMap: genericChildMap,
			depthLimit,
			currentDepth: 1
		}),
		isVisibleInParent: false
	}
}

export function createCompactTreeTraversalMaps(moduleDescription: UIBoard.Description) {
	const previewMap = createPreviewProviderDictionary(moduleDescription.visualDecomposition)
	const previewDecomposition = createViewCompositionMap(previewMap)
	const visualChildMap = new Map(Array.from(previewDecomposition.entries(), extractViewnames))
	const roots = getRoots(moduleDescription.genericDecomposition)
	return {previewMap, previewDecomposition, visualChildMap, roots}

	function extractViewnames([name, previewComposition]: [string, PreviewComposition]): [string, Set<string>] {
		return [name, previewComposition.viewNames]
	}
}

type LinkConstructionArguments = {
	view: string,
	visibilityList: Set<string>
	parents: Set<string>
	visualChildMap: Map<string, Set<string>>
	genericChildMap: UIBoard.GenericComposition
	currentDepth?: number
	depthLimit?: number
}

export function getLinksFrom({view, visibilityList, parents, visualChildMap, genericChildMap, currentDepth = 0, depthLimit = Infinity}: LinkConstructionArguments): Node[] {
	const result: Node[] = []

	const genericChildren = genericChildMap[view]
	if (currentDepth < depthLimit && genericChildren) {
		const visitedChildren = new Set<string>()
		const newParents = new Set(parents)
		newParents.add(view)
		for (const child of genericChildren) {
			if (newParents.has(child) || visitedChildren.has(child)) continue;
			visitedChildren.add(child)
			const linkConstructionArguments = {view: child, parents: newParents, visualChildMap, genericChildMap, depthLimit, currentDepth: currentDepth+1}
			if (visibilityList.has(child)) {
				const links = getLinksFrom({visibilityList, ...linkConstructionArguments})
				result.push({name: child, children: links, isVisibleInParent: true})
			} else {
				const links = getLinksFrom({visibilityList: visualChildMap.get(child) ?? new Set(), ...linkConstructionArguments})
				result.push({name: child, children: links, isVisibleInParent: false})
			}
		}
	}

	return result
}

interface Node {
	name: string //TODO rename identifier
	children: Node[]	
	isVisibleInParent: boolean
}