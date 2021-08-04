//
//  Roots.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 31/07/2021.
//

extension BoardDescription {
	func getRoots() -> Set<String> {
		var roots = Set(genericDecomposition.keys)
		for (parent, children) in genericDecomposition {
			roots.subtract(children.filter{ $0 != parent })
		}
		return roots
	}
}
