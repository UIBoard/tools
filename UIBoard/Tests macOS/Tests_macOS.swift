//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Damiaan on 21/06/2021.
//

import XCTest
import SwiftUI

import Foundation

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testCollectPreviews() {
//		for snapshot in captureViews(in: ContentView_Previews.previews) {
//			let attachment = XCTAttachment(image: snapshot.image)
//			attachment.name = snapshot.info.type.description
//			attachment.lifetime = .keepAlways
//			add(attachment)
//		}
	}

	func testParseGenericType() {
		print(extractOwnModuleTypes(from: ContentView.Content.self))
		print(dump(ContentView()))
	}

	func extractOwnModuleTypes(from type: Any.Type) -> [String.SubSequence] {
		let typeString = String(reflecting: type)
		var types = [String.SubSequence]()
		let modulePrefix = "Tests_macOS."
		var cursor = typeString.startIndex
		let separators = Set<Character>([")", ",", ">", "<"])
		while cursor < typeString.endIndex, let prefixRange = typeString.range(of: modulePrefix, range: cursor..<typeString.endIndex) {
			let end = typeString[prefixRange.upperBound...].firstIndex { separators.contains($0) } ?? typeString.endIndex
			types.append(typeString[prefixRange.lowerBound..<end])
			cursor = typeString.index(after: end)
		}
		return types
	}

	func testCollector() {
		let viewCollector = ViewCollector()
		let view = ContentView().environment(\.viewCollector, viewCollector)
		let render = view.render()
		print(viewCollector.children)
		print(ContentView.Body.self)

		print(String(reflecting: ContentView.Content.self))

		let attachment = XCTAttachment(image: render)
		attachment.name = "content view"
		attachment.lifetime = .keepAlways
		add(attachment)
	}

	func testMultiplePreviews() {
		let _ = ContentView_Previews.previews.render()
	}

	struct BodyDeclaration {
		let location: SymbolGraph.Symbol.Location?
		let pathComponents: [String]
		let parentUSRs: [String]
		let parents: [String]

		var locationDescription: String {
			if let location = location {
				return """
				(
				 file: \(URL(string: location.uri)!.path.debugDescription),
				 position: (\(location.position.line + 1),\(location.position.character + 1))
				)
				"""
			} else {
				return "No location for: \(pathComponents)"
			}
		}
	}

	func testParseSymbolGraph() throws {
		/// To generate symbol graph in terminal:
		///  - Build source: `% xcodebuild -scheme "UIBoard (macOS)"`
		///  - Look for build path: `.../DerivedData/UIBoard-bdegdoemqxirnddplflnavwnqkbf/Build/Products/Debug/`
		///  - Extract symbol graph: `% swift symbolgraph-extract -minimum-access-level internal -skip-synthesized-members -pretty-print -module-name UIBoard -target x86_64-apple-macos11 -output-dir /tmp/HelloWorld -I /Users/damiaan/Library/Developer/Xcode/DerivedData/UIBoard-bdegdoemqxirnddplflnavwnqkbf/Build/Products/Debug -sdk /Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.0.sdk`
		let data = try Data(contentsOf: URL(fileURLWithPath: "/tmp/HelloWorld/Fruta.symbols.json"))

		let graph = try JSONDecoder().decode(SymbolGraph.self, from: data)
		XCTAssertEqual(graph.module.name, "Fruta")
		let viewIDs = Set(graph.relationships.lazy.filter { relation in
			relation.kind == .conformsTo &&
			relation.target == "s:7SwiftUI4ViewP"
		}.map(\.source))
		let views = graph.symbols.filter { symbol in
			symbol.kind == .struct &&
			viewIDs.contains(symbol.identifier.usr)
		}
		print(views.count, "SwiftUI views:", views.map {$0.names.title})

		let symbolTitles = Dictionary(graph.symbols.map{($0.identifier.usr, $0.names.title)}, uniquingKeysWith: {$1})
		let viewStructMembers = graph.relationships.lazy.filter { relation in
			relation.kind == .memberOf && views.contains { view in view.identifier.usr == relation.target }
		}
		let viewStructMemberUSRs = Dictionary(viewStructMembers.map{($0.source, [$0.target])}) { left, right in
			left + right
		}
		let directBodies = graph.symbols.filter { symbol in
			viewStructMemberUSRs.keys.contains(symbol.identifier.usr) && symbol.names.title == "body"
		}.map { declaration -> BodyDeclaration in
			let parentUSRs = viewStructMemberUSRs[declaration.identifier.usr]!
			return BodyDeclaration(
				location: declaration.location,
				pathComponents: declaration.pathComponents,
				parentUSRs: parentUSRs,
				parents: parentUSRs.map{symbolTitles[$0]!}
			)
		}
		print("View structs without body decl:", viewIDs.subtracting(directBodies.flatMap(\.parentUSRs)))
		print("\(directBodies.count) bodies:")
		print(directBodies.sorted{$0.location?.uri ?? "" < $1.location?.uri ?? ""}.map(\.locationDescription).joined(separator: ",\n"))

		print(graph.symbols.filter { symbol in
			viewStructMemberUSRs.keys.contains(symbol.identifier.usr) && symbol.names.title == "body"
		}.map(\.identifier.usr))

		let previewIDs = Set(graph.relationships.lazy.filter { relation in
			relation.kind == .conformsTo &&
			relation.target == "s:7SwiftUI15PreviewProviderP"
		}.map(\.source))
		let previews = graph.symbols.filter { symbol in
			symbol.kind == .struct &&
			previewIDs.contains(symbol.identifier.usr)
		}
		print(previews.count, "SwiftUI previews:", previews.map {$0.names.title + ".previews"}.joined(separator: ", "))
	}

	func testRenderSwiftUI() {
		let root = NavigationView {
			Text("dinge")
		}

		let viewController = NSHostingController(rootView: root)
		viewController.view.translatesAutoresizingMaskIntoConstraints = false

		print(viewController.view.intrinsicContentSize, viewController.sizeThatFits(in: CGSize(width: 200, height: 200)))
	}

	func testViewTypes() {
		let instance = ContainerA()
		print(instance.body)
		var cursor: ViewBoxProtocol = ViewBox(content: instance)
		print(cursor.viewType)
		while let body = cursor.body {
			cursor = body
			print(cursor.viewType)
		}
	}

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

protocol ViewBoxProtocol {
	var body: ViewBoxProtocol? {get}
	var viewType: Any.Type {get}
}

struct ViewBox<B: View>: ViewBoxProtocol {
	let content: B
	var body: ViewBoxProtocol? {
		guard B.Body.self != Never.self else { return nil }
		return ViewBox<B.Body>(content: content.body)
	}
	var viewType: Any.Type { type(of: content) }
}

struct ContainerA: View {
	var body: some View {
		HStack {
			Text("container")
			InnerA()
		}
	}

	struct InnerA: View {
		var body: some View {
			Text("Inner A")
		}
	}
}
