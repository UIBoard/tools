//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Damiaan on 06/07/2021.
//

import XCTest
@testable import UIBoard
import SwiftUI

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
		for snapshot in captureViews(in: ContentView_Previews.previews) {
			let attachment = XCTAttachment(image: snapshot.image)
			attachment.name = snapshot.info.children.first?.type.description
			attachment.lifetime = .keepAlways
			add(attachment)
		}
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
