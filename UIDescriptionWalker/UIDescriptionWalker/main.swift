//
//  main.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 31/07/2021.
//

import Foundation
import DequeModule

let decoder = JSONDecoder()
let prefix = "/Users/damiaan/Documents/Projecten/SwiftUI Storyboards/UIBoardViewer/static/BoardDescriptions/"
let frutaPath = prefix + "Fruta/index.json"
let frutaURL = URL(fileURLWithPath: frutaPath)
let moviePath = prefix + "MovieSwift/index.json"
let movieURL = URL(fileURLWithPath: moviePath)

import struct CoreGraphics.CGRect

try print(String(data: JSONEncoder().encode(CGRect(x: 0, y: 1, width: 10, height: 20)), encoding: .utf8)!)

//try walk(descriptionURL: movieURL)
//print(BoardDescription.invert(tree: BoardDescription.circular.createOverview()))

//let description = try decoder.decode(BoardDescription.self, from: Data(contentsOf: frutaURL))
//print(description.visualDecomposition)

func walk(descriptionURL: URL) throws {
	let description = try decoder.decode(BoardDescription.self, from: Data(contentsOf: descriptionURL))

	print("--- Grouping previews per view ---\nWarnings:")
	let previewsPerView = description.createPreviewProviderDictionary()
	print("----")

	for (view, previewContexts) in previewsPerView {
		print(view, "→")
		for context in previewContexts {
			print("\t\(context.preview.render) (\(context.preview.allContainedViews.count))")
		}
	}
	print("----\n")

	let roots = description.getRoots()
	print("Found roots:", roots)
//	for root in roots {
//		print("--- Walking", root, "---")
//
//		var queue: Deque = [Walk.view(root)]
//		var depth = 0
//		while let next = queue.popFirst() {
//			switch next {
//			case .view(let viewName):
//				print(String(repeating: "  ", count: depth), viewName, separator: "")
//				guard let children = description.genericDecomposition[viewName] else {continue}
//				for childView in Set(children).subtracting(CollectionOfOne(viewName)) {
//					queue.insert(.exit, at: 0)
//					queue.insert(.view(childView), at: 0)
//					queue.insert(.enter, at: 0)
//				}
//			case .enter: depth += 1
//			case .exit: depth -= 1
//			}
//		}
//	}

	print("----\n")

//	print("Overview tree")
//	let overview = description.createOverview()
//	print(overview)
	let encoder = JSONEncoder()
//	let overviewData = try encoder.encode(overview)
//	print(String(data: overviewData, encoding: .utf8)!)

	try print(String(data: encoder.encode(description.genericDecomposition.map{BoardDescription.Node.linked(name: $0, children: Set($1).map{.init(name: $0, isVisibleInParent: false, children: [])})}), encoding: .utf8)!)

//	try print(String(data: encoder.encode(BoardDescription.invert(tree: overview)), encoding: .utf8)!)
//	print(overview.description.components(separatedBy: .newlines).count)
}

enum Walk {
	case view(String)
	case exit
	case enter
}
