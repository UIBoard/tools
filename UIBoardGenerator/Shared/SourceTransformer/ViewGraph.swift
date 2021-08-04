//
//  ModuleTransformer.swift
//  UIBoard (iOS)
//
//  Created by Damiaan on 06/07/2021.
//

import Foundation

struct ViewGraph {
	let graph: SymbolGraph

	init(symbolgraphURL: URL) throws {
		let data = try Data(contentsOf: symbolgraphURL)
		graph = try JSONDecoder().decode(SymbolGraph.self, from: data)
	}

	private (set) lazy var viewIDs = Set(graph.relationships.lazy.filter { relation in
		relation.kind == .conformsTo &&
		relation.target == "s:7SwiftUI4ViewP"
	}.map(\.source))

	private (set) lazy var views = graph.symbols.filter { symbol in
		viewIDs.contains(symbol.identifier.usr)
	}

	private (set) lazy var nonGenericViewStructs = views.lazy.filter { symbol in
		symbol.kind == .struct && symbol.swiftGenerics?.parameters?.isEmpty ?? true
	}

	private (set) lazy var viewMembers: LazyFilterSequence<LazySequence<[SymbolGraph.Edge]>.Elements> = {
		let views = self.views
		return graph.relationships.lazy.filter { relation in
			relation.kind == .memberOf && views.contains { view in view.identifier.usr == relation.target }
		}
	}()

	private (set) lazy var viewStructMemberUSRs = Dictionary(
		viewMembers.map { ($0.source, [$0.target])}) { $0 + $1 }

	private (set) lazy var symbolTitles = Dictionary(graph.symbols.map{($0.identifier.usr, $0.names.title)}) {$1}

	private (set) lazy var viewBodies = graph.symbols.filter { symbol in
		viewStructMemberUSRs.keys.contains(symbol.identifier.usr) && symbol.names.title == "body" && symbol.kind == .instanceProperty
	}.compactMap { declaration -> BodyDeclaration? in
		let parentUSRs = viewStructMemberUSRs[declaration.identifier.usr]!
		guard let location = declaration.location else {
			print("no location for", declaration.identifier)
			return nil
		}
		return BodyDeclaration(
			uri: location.uri,
			info: BodyDeclaration.DeclarationInfo(
				position: location.position,
				pathComponents: declaration.pathComponents,
				parentUSRs: parentUSRs,
				parents: parentUSRs.map{symbolTitles[$0]!}
			)
		)
	}.sorted {
		$0.uri < $1.uri
	}

	private (set) lazy var previewIDs = Set(
		graph.relationships.lazy.filter { relation in
			relation.kind == .conformsTo &&
			relation.target == "s:7SwiftUI15PreviewProviderP"
		}.map(\.source)
	)

	private (set) lazy var previews = graph.symbols.filter { symbol in
		symbol.kind == .struct &&
		previewIDs.contains(symbol.identifier.usr)
	}
}

struct BodyDeclaration {
	let uri: String
	let info: DeclarationInfo

	struct DeclarationInfo {
		let position: Position
		let pathComponents: [String]
		let parentUSRs: [String]
		let parents: [String]
	}
}
