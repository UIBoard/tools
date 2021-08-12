import type {UIBoard} from '../BoardDescription'

export function getRoots(composition: UIBoard.GenericComposition): Set<string> {
	const dictionary = new Map(Object.entries(composition))
	const roots = new Set(dictionary.keys())

	for (const [parent, children] of dictionary) {
		for (const child of children) {
			if (child != parent) {
				roots.delete(child)
			}
		}
	}

	return roots
}