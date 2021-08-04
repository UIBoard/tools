//
//  main.swift
//  SourceTransformer
//
//  Created by Damiaan on 06/07/2021.
//

var graph = try ViewGraph(
	symbolgraphURL:.init(fileURLWithPath: "/tmp/HelloWorld/MovieSwift.symbols.json")
)
//wrapViews(of: graph)
print( createTypeTable(viewGraph: &graph) )
