//
//  BoardDescription.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 31/07/2021.
//

import struct CoreGraphics.CGRect
import struct CoreGraphics.CGFloat

struct BoardDescription: Codable {
	let visualDecomposition: [PreviewProvider]
	let genericDecomposition: [String : [String]]

	struct PreviewProvider: Codable {
		/// The name of the PreviewProvider struct
		let identifier: String
		let previews: [Preview]

		struct Preview: Codable {
			let render: String
			let info: Info

			struct Info: Codable {
				let tags: ViewCollector
				let scale: CGFloat
				let viewport: CGRect

				struct ViewCollector: Codable {
					let children: [Child]

					struct Child: Codable {
						// The name of the rendered View struct
						let type: String
						let visibleArea: CGRect
						let collector: ViewCollector
					}
				}
			}
		}
	}
}
