//
//  CompactTree.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 04/08/2021.
//

import Foundation

extension BoardDescription {
	struct Node: Codable {
		let name: String
		let isVisibleInParent: Bool
		var children: [Self]
	}

	func createOverview() -> [Node] {
		let previewDictionary = createPreviewProviderDictionary()
		let compositionDictionary = createViewCompositionMap(from: previewDictionary)
		let visibleChildrenOf = {view in compositionDictionary[view]?.viewsNames ?? []}
		return getRoots().map { root in
			let links = getLinks(
				from: root,
				visibilityList: visibleChildrenOf(root),
				parents: [],
				visualChildrenOf: visibleChildrenOf
			)
			return summarise( .linked(name: root, children: links) )
		}
	}

	func getLinks(from view: String, visibilityList: Set<String>, parents: Set<String>, visualChildrenOf: (String)->Set<String> ) -> [Node] {
		var result = [Node]()
		if let genericChildren = genericDecomposition[view] {
			result.reserveCapacity(genericChildren.count)
			var visitedChildren = Set<String>()
			let newParents = parents.union([view])
			for child in genericChildren {
				guard !newParents.contains(child) && !visitedChildren.contains(child) else { continue }
				visitedChildren.insert(child)
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

	struct InvertedNode: Codable {
		let id: String
		let parentIds: Set<String>
	}
	
	static func invert(tree: [Node], using parents: inout [String: Set<String>], visited: inout Set<String>) {
		for node in tree {
			if !parents.keys.contains(node.name) {
				parents[node.name] = Set()
			}
			if !visited.contains(node.name) {
				visited.insert(node.name)
				for child in node.children {
					if parents.keys.contains(child.name) {
						parents[child.name]!.insert(node.name)
					} else {
						parents[child.name] = Set(CollectionOfOne(node.name))
					}
				}
				invert(tree: node.children, using: &parents, visited: &visited)
			}
		}
	}

	static func invert(tree: [Node]) -> [InvertedNode] {
		var dictionary = [String: Set<String>]()
		var visited = Set<String>()
		invert(tree: tree, using: &dictionary, visited: &visited)
		return dictionary.map(InvertedNode.init)
	}

	func summarise(_ tree: Node) -> Node {
		let optimisation1 = removeLeafCompositionNodes(from: tree)
		let optimisation2 = removeOnlyChildCompositionNodes(from: optimisation1)
		return optimisation2
	}

	func removeLeafCompositionNodes(from tree: Node) -> Node {
		var pathsToVisit: [[Int]] = [[]]
		var optimizedTree = tree
		while let path = pathsToVisit.popLast() {
			let node = optimizedTree[path]
			if node.children.isEmpty {
				// Remove leafs that are visible in their parent
				var cursor = path
				while !cursor.isEmpty, case let leaf = optimizedTree[cursor], leaf.isVisibleInParent && leaf.children.isEmpty {
					let indexToRemove = cursor.popLast()!
					optimizedTree[cursor].children.remove(at: indexToRemove)
				}
			} else {
				// Visit children
				let pathsToChildren = node.children.indices.map {index in path + [index]}
				pathsToVisit.append(contentsOf: pathsToChildren)
			}
		}
		return optimizedTree
	}

	func removeOnlyChildCompositionNodes(from tree: Node) -> Node {
		var pathsToVisit: [[Int]] = [[]]
		var optimizedTree = tree
		while let path = pathsToVisit.popLast() {
			// Remove composition nodes that have no siblings
			var children = optimizedTree[path].children
			while children.count == 1 && children[0].isVisibleInParent {
				children = children[0].children
				optimizedTree[path].children = children
			}

			// Visit children
			let pathsToChildren = children.indices.map {index in path + [index]}
			pathsToVisit.append(contentsOf: pathsToChildren)
		}
		return optimizedTree
	}
}

// MARK: - Node extensions

extension BoardDescription.Node {
	// MARK: Path resolver
	subscript<Path: Collection>(path: Path) -> Self where Path.Element == Int {
		get {
			guard let index = path.first else {return self}
			return children[index][path.dropFirst()]
		}
		set {
			if path.count > 1 {
				children[path.first!][path.dropFirst()] = newValue
			} else if path.count == 1 {
				children[path.first!] = newValue
			}
		}
	}

	// MARK: Initialisation shortcuts
	static func composed(name: String, children: [Self]) -> Self {
		Self(name: name, isVisibleInParent: true, children: children)
	}

	static func linked(name: String, children: [Self]) -> Self {
		Self(name: name, isVisibleInParent: false, children: children)
	}
}

// MARK: String representation for node trees
extension BoardDescription.Node: CustomStringConvertible {
	var description: String { indentedDescription() }

	func indentedDescription(level: Int = 0) -> String {
		String(repeating: "\t", count: level) + (
			["\(name) (\(isVisibleInParent ? "vis child" : "link"))"] +
			children.map { $0.indentedDescription(level: level + 1) }
		).joined(separator: "\n")
	}
}
