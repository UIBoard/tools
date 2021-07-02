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
		let collector = ViewCollector()
		return content
			.environment(\.viewCollector, collector)
			.overlay(Tagger(type: Self.self, collector: collector))
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

final class ViewCollector: ObservableObject, EnvironmentKey, CustomStringConvertible {
	static let defaultValue = ViewCollector()

	fileprivate(set) var children = [Child]()

	public init() {}

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

	struct Child {
		let visibleArea: CGRect
		let type: AnyTypeInfo
		let collector: ViewCollector
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
				.init(visibleArea: frame, type: id, collector: collector)
			)
		}
		return Rectangle().opacity(0.01)
	}
}

extension EnvironmentValues {
	var viewCollector: ViewCollector {
		get { self[ViewCollector.self] }
		set { self[ViewCollector.self] = newValue }
	}
}

protocol TypeInfoProtocol: CustomStringConvertible {
	var id: ObjectIdentifier {get}
}

struct AnyTypeInfo: Hashable, TypeInfoProtocol {
	static func == (lhs: AnyTypeInfo, rhs: AnyTypeInfo) -> Bool {
		lhs.content.id == rhs.content.id
	}

	private let storage: Any

	init<T>(type: T.Type) {
		storage = TypeInfo(type: T.self)
	}

	var content: TypeInfoProtocol { storage as! TypeInfoProtocol }
	var id: ObjectIdentifier { content.id }
	var description: String { content.description }

	func hash(into hasher: inout Hasher) {
		hasher.combine(content.id)
	}
}

struct TypeInfo<T>: TypeInfoProtocol {
	let id: ObjectIdentifier
	init(type: T.Type) {
		id = ObjectIdentifier(type)
	}

	var description: String { String(describing: T.self) }
}


#if os(iOS)
typealias SystemImage = UIImage
typealias SystemHostingController = UIHostingController
#elseif os(macOS)
typealias SystemImage = NSImage
typealias SystemHostingController = NSHostingController
#endif

extension View {
	func render() -> SystemImage {
		let controller = SystemHostingController(rootView: self)
		#if os(macOS)
		let view = controller.view
		#else
		let view = controller.view!
		#endif
		let frame = CGRect(origin: .zero, size: view.intrinsicContentSize)
		view.frame = frame

		let image: SystemImage
		#if os(macOS)
		let repository = view.bitmapImageRepForCachingDisplay(in: frame)!
		view.cacheDisplay(in: frame, to: repository)
		image = NSImage(cgImage: repository.cgImage!, size: frame.size)
		#else
		let renderer = UIGraphicsImageRenderer(size: view.frame.size)
		image = renderer.image { ctx in
			view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
		}
		#endif

		return image
	}
}

struct OtherPreview: PreviewProvider {
	static var previews: some View {
		HStack {
			ContentView_Previews.previews
				.overlay(Ellipse().foregroundColor(.orange).opacity(0.2))
				.frame(maxWidth: 200, maxHeight: 200)
		}
	}
}
