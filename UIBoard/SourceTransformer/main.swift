//
//  main.swift
//  SourceTransformer
//
//  Created by Damiaan on 06/07/2021.
//

var frutaGraph = try ViewGraph(
	symbolgraphURL:.init(fileURLWithPath: "/tmp/HelloWorld/Fruta.symbols.json")
)
//wrapViews(symbolgraphURL: URL(fileURLWithPath: "/tmp/HelloWorld/Fruta.symbols.json"))


//var uiBoardGraph = try ViewGraph(
//	symbolgraphURL: .init(fileURLWithPath: "/tmp/HelloWorld/UIBoard.symbols.json")
//)
print( createTypeTable(viewGraph: &frutaGraph) )
