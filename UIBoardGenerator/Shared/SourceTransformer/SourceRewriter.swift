//
//  WrapViews.swift
//  SourceTransformer
//
//  Created by Damiaan on 07/07/2021.
//

import SwiftSyntax
import Foundation

func wrapViews(of graph: inout ViewGraph) throws {
	let files = Dictionary(graph.viewBodies.map {($0.uri, [$0.info])}) { $0 + $1 }

	for (file, bodies) in files {
		print("Transforming file", file)
		let sourceURL = URL(string: file)!
		let sourceTree = try SyntaxParser.parse(sourceURL)
		print("\tbody declarations:", bodies.map { $0.pathComponents.joined(separator: "→") }.joined(separator: ", ") )
		let locationTransformer = SourceLocationConverter(file: file, tree: sourceTree)
		let sourceTransformer = FileTransformer(
			locations: bodies.map { declaration in
				locationTransformer.position(
					ofLine: declaration.position.line + 1,
					column: declaration.position.character + 1
				).utf8Offset
			}
		)
		let transformedSource = sourceTransformer.visit(sourceTree)
		try transformedSource.description.data(using: .utf8)!.write(to: sourceURL)
	}
}
