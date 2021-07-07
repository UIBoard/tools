//
//  GenericDecomposition.swift
//  UIBoard
//
//  Created by Damiaan on 07/07/2021.
//

import SwiftUI

protocol PreviewContainerProtocol {
	static func capturePreviews() -> [PreviewSnapshot]
	static var type: AnyTypeInfo {get}
}

enum PreviewContainer<Provider: PreviewProvider>: PreviewContainerProtocol {
	static func capturePreviews() -> [PreviewSnapshot] { captureViews(in: Provider.previews, name: String(describing: Provider.self)) }
	static var type: AnyTypeInfo { AnyTypeInfo(type: Provider.self) }
}

protocol ViewTypeInfoProtocol {
	static var type: AnyTypeInfo {get}
	static var bodyType: AnyTypeInfo { get }

	static func extractContainedTypesOf(module: String) -> [String.SubSequence]
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

struct AnyViewTypeInfo: Hashable {
	let content: ViewTypeInfoProtocol.Type

	static func == (lhs: AnyViewTypeInfo, rhs: AnyViewTypeInfo) -> Bool {
		lhs.content.type == rhs.content.type
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(content.type)
	}
}
