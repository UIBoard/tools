import {createSubTreeFrom} from './trees/views'
import type {SubTreeCreationArguments} from './trees/views'
import type {UIBoard} from './BoardDescription'

type LimitedDepthBrowserCreationArguments = SubTreeCreationArguments & {parentMap: Map<string, Set<string>>}

export function createLimitedDepthBrowserContext({}: LimitedDepthBrowserCreationArguments) {
	
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