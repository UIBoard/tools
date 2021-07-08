//
//  TypeLookupTable.swift
//  SourceTransformer
//
//  Created by Damiaan on 07/07/2021.
//

import Foundation
func createTypeTable(viewGraph graph: inout ViewGraph) -> String {
	let views = graph.nonGenericViews
	let viewIdentifiers = views.map { $0.pathComponents.joined(separator: ".") }
	let viewReferences = viewIdentifiers.map { "ViewTypeInfo<\($0)>.self" }

	return """
		let viewTypeDictionary: [String: ViewTypeInfoProtocol.Type] = {
			let types: [ViewTypeInfoProtocol.Type] = [\(Set(viewReferences).joined(separator: ", "))]
			return Dictionary(uniqueKeysWithValues: types.map{($0.type.debugDescription, $0)})
		}()
		"""
}
