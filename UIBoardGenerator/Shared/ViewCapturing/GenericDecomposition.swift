//
//  GenericDecomposition.swift
//  UIBoard
//
//  Created by Damiaan on 07/07/2021.
//

import SwiftUI

func decompose(viewTypeDictionary: [String: ViewTypeInfoProtocol.Type]) -> [AnyViewTypeInfo: [ViewTypeInfoProtocol.Type]] {
	var genericCompositionRelations = [AnyViewTypeInfo: [ViewTypeInfoProtocol.Type]]()
	for viewInfo in viewTypeDictionary.values {
		visit(viewInfo)
	}

	func visit(_ viewInfo: ViewTypeInfoProtocol.Type) {
		let erasedType = AnyViewTypeInfo(content: viewInfo)
		guard !genericCompositionRelations.keys.contains(erasedType) else { return }
		for parameter in viewInfo.extractContainedTypesOf(module: "Fruta") {
			guard let subType = viewTypeDictionary[String(parameter)] else { continue }
			add(type: subType, to: erasedType)
			visit(subType)
		}
	}

	func add(type: ViewTypeInfoProtocol.Type, to parent: AnyViewTypeInfo) {
		if genericCompositionRelations.keys.contains(parent) {
			genericCompositionRelations[parent]!.append(type)
		} else {
			genericCompositionRelations[parent] = [type]
		}
	}

	for (parent, children) in genericCompositionRelations {
		print(parent.content.type.debugDescription + ":")
		print("\t" + children.map { $0.type.debugDescription } .joined(separator: ", ") )
	}

	return genericCompositionRelations
}

enum ViewTypeInfo<ViewType: View>: ViewTypeInfoProtocol {
	typealias Content = ViewType
	static var type: AnyTypeInfo { AnyTypeInfo(type: ViewType.self) }
	static var bodyType: AnyTypeInfo { AnyTypeInfo(type: ViewType.Body.self) }

	static func extractContainedTypesOf(module: String) -> [String.SubSequence] {
		extractGenericParametersOf(module: module, from: ViewType.Body.self)
	}
}

func extractGenericParametersOf(module moduleName: String, from type: Any.Type) -> [String.SubSequence] {
	let modulePrefix = moduleName + "."
	let typeString = String(reflecting: type)
	var types = [String.SubSequence]()
	var cursor = typeString.startIndex
	let separators = Set<Character>([")", ",", ">", "<"])
	while cursor < typeString.endIndex, let prefixRange = typeString.range(of: modulePrefix, range: cursor..<typeString.endIndex) {
		guard let end = typeString[prefixRange.upperBound...].firstIndex(where: { separators.contains($0) }) else {
			types.append(typeString[prefixRange.lowerBound ..< typeString.endIndex])
			break
		}
		types.append(typeString[prefixRange.lowerBound ..< end])
		cursor = typeString.index(after: end)
	}
	return types
}

protocol ViewTypeInfoProtocol {
	static var type: AnyTypeInfo {get}
	static var bodyType: AnyTypeInfo { get }

	static func extractContainedTypesOf(module: String) -> [String.SubSequence]
}

struct AnyViewTypeInfo: Hashable {
	let content: ViewTypeInfoProtocol.Type

	static func == (lhs: AnyViewTypeInfo, rhs: AnyViewTypeInfo) -> Bool {
		lhs.content.type == rhs.content.type
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(content.type)
	}
}

extension AnyViewTypeInfo: Encodable {
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(content.type)
	}
}
