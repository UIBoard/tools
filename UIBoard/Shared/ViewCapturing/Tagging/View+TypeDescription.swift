//
//  View+TypeDescription.swift
//  UIBoard (iOS)
//
//  Created by Damiaan on 06/07/2021.
//

import SwiftUI

protocol TypeInfoProtocol: CustomStringConvertible {
	var id: ObjectIdentifier {get}
}

struct TypeInfo<T>: TypeInfoProtocol {
	let id: ObjectIdentifier
	init(type: T.Type) {
		id = ObjectIdentifier(type)
	}

	var description: String { String(describing: T.self) }
}

struct AnyTypeInfo: TypeInfoProtocol {
	private let storage: Any

	init<T>(type: T.Type) {
		storage = TypeInfo(type: T.self)
	}

	var content: TypeInfoProtocol { storage as! TypeInfoProtocol }
	var id: ObjectIdentifier { content.id }
	var description: String { content.description }
}

extension AnyTypeInfo: Hashable {
	static func == (lhs: AnyTypeInfo, rhs: AnyTypeInfo) -> Bool {
		lhs.content.id == rhs.content.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(content.id)
	}
}
