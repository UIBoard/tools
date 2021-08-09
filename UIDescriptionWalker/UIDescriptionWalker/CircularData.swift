//
//  CircularData.swift
//  UIDescriptionWalker
//
//  Created by Damiaan on 08/08/2021.
//

extension BoardDescription {
	static let circular = BoardDescription(
		visualDecomposition: [],
		genericDecomposition: [
			"A": ["B"],
			"B": ["A"],
			"R": ["A"]
		]
	)
}
