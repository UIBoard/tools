//
//  CompactTree.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 04/08/2021.
//

import Foundation

extension BoardDescription {
	struct Node {
		let name: String
		let isVisibleInParent: Bool
		let children: [Self]
	}

	func getLinks(from view: String, visibilityList: Set<String>, parents: Set<String>, visualChildrenOf: (String)->Set<String> ) -> [Node] {
		var result = [Node]()
		if let genericChildren = genericDecomposition[view] {
			result.reserveCapacity(genericChildren.count)
			var visitedChildren = Set<String>()
			for child in genericChildren {
				guard !parents.contains(view) && !visitedChildren.contains(child) && child != view else { continue }
				visitedChildren.insert(child)
				let newParents = parents.union([view])
				if visibilityList.contains(child) {
					let links = getLinks(from: child, visibilityList: visibilityList, parents: newParents, visualChildrenOf: visualChildrenOf)
					result.append(.composed(name: child, children: links))
				} else {
					let links = getLinks(from: child, visibilityList: visualChildrenOf(child), parents: newParents, visualChildrenOf: visualChildrenOf)
					result.append(.linked(name: child, children: links))
				}
			}
		}
		return result
	}

	func createOverview() -> [Node] {
		let previewDictionary = createPreviewProviderDictionary()
		let compositionDictionary = createViewCompositionMap(from: previewDictionary)
		return getRoots().map { root in
			let links = getLinks(
				from: root,
				visibilityList: compositionDictionary[root]?.viewsNames ?? [],
				parents: [],
				visualChildrenOf: {view in compositionDictionary[view]?.viewsNames ?? []}
			)
			return .linked(name: root, children: links)
		}
	}
}

// Shortcuts for node creation
extension BoardDescription.Node {
	static func composed(name: String, children: [Self]) -> Self {
		Self(name: name, isVisibleInParent: true, children: children)
	}

	static func linked(name: String, children: [Self]) -> Self {
		Self(name: name, isVisibleInParent: false, children: children)
	}
}

extension BoardDescription.Node: CustomStringConvertible {
	var description: String { indentedDescription() }

	func indentedDescription(level: Int = 0) -> String {
		String(repeating: "\t", count: level) + (
			["\(name) (\(isVisibleInParent ? "vis child" : "link"))"] +
			children.map { $0.indentedDescription(level: level + 1) }
		).joined(separator: "\n")
	}
}
