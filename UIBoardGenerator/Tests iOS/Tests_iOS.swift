//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Damiaan on 06/07/2021.
//

import XCTest
@testable import UIBoard
import SwiftUI

import UniformTypeIdentifiers

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		for snapshot in captureViews(in: ContentView_Previews.previews) {
			try XCTContext.runActivity(named: snapshot.tags.children.first?.type.description ?? "no description") { preview in
				let attachment = XCTAttachment(image: snapshot.image)
				attachment.name = "View"
				attachment.lifetime = .keepAlways
				preview.add(attachment)

				let info = XCTAttachment(data: try encoder.encode(snapshot.info), uniformTypeIdentifier: UTType.json.identifier)
				info.name = "Info"
				info.lifetime = .keepAlways
				preview.add(info)
			}
		}
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
