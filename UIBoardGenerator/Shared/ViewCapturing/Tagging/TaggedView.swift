//
//  TaggedView.swift
//  UIBoard
//
//  Created by Damiaan on 21/06/2021.
//

import SwiftUI

public protocol TaggedView: View {
	associatedtype Content: View

	@ViewBuilder var content: Content {get}
}

extension TaggedView {
	public var body: some View {
		tagVisibleAreaWithTagger { content }
	}
}

extension View {
	func tagVisibleAreaWithTagger<V: View>(@ViewBuilder content: () -> V) -> some View {
		let collector = ViewCollector()
		return content()
			.environment(\.viewCollector, collector)
			.overlay(Tagger(type: Self.self, collector: collector))
	}
}

struct Tagger<V: View>: View {
	@Environment(\.viewCollector) var parent

	let type: V.Type
	let collector: ViewCollector

	var body: some View {
		GeometryReader(content: read)
	}

	func read(proxy: GeometryProxy) -> some View {
		let id = AnyTypeInfo(type: type)
		let frame = proxy.frame(in: .global)
		if !frame.isEmpty {
			parent.children.append(
				.init(type: id, visibleArea: frame, collector: collector)
			)
		}
		return Color.clear
	}
}

final class ViewCollector: ObservableObject, EnvironmentKey, CustomStringConvertible, Encodable {
	static let defaultValue = ViewCollector()

	fileprivate(set) var children: [Child]

	public init(children: [Child] = []) {
		self.children = children
	}

	var isDefault: Bool { self === ViewCollector.defaultValue }

	var description: String {
		if children.isEmpty {
			return ""
		} else {
			return indentedDescription(level: 0)
		}
	}

	func indentedDescription(level: UInt8) -> String {
		let prefix = String(repeating: "\t", count: Int(level + 1))
		return "view collector(\(Unmanaged.passUnretained(self).toOpaque())) has \(children.count) children:\n" +
			children
			.map { prefix + $0.type.description + " \($0.visibleArea) with " + $0.collector.indentedDescription(level: level + 1) }
			.joined(separator: "\n")
	}

	struct Child: Encodable {
		let type: AnyTypeInfo
		let visibleArea: CGRect
		let collector: ViewCollector
	}
}

extension EnvironmentValues {
	var viewCollector: ViewCollector {
		get { self[ViewCollector.self] }
		set { self[ViewCollector.self] = newValue }
	}
}
