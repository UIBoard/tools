//
//  main.swift
//  SourceTransformer
//
//  Created by Damiaan on 06/07/2021.
//

import Foundation

var graph = try ViewGraph(
	symbolgraphURL:.init(fileURLWithPath: "/tmp/HelloWorld/MovieSwift-skip-synthesised-members.symbols.json")
)
try wrapViews(of: &graph)

//print( createTypeTable(viewGraph: &graph) )
//
//print("")
//print("//ignored generic views:", graph.views.lazy.filter { symbol in
//	symbol.kind == .struct && (symbol.swiftGenerics?.parameters?.isEmpty ?? true) == false
//}.map(\.names.title).joined(separator: ", "))
//print("")

//print(graph.previews.map(\.names.title).map{"PreviewContainer<\($0)>.self"}.joined(separator: ", "))
