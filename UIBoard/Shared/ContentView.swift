//
//  ContentView.swift
//  Shared
//
//  Created by Damiaan on 01/07/2021.
//

import SwiftUI

struct ContentView: TaggedView {
	@State var selectedTab: Int = 1

	var content: some View {
		TabView(selection: $selectedTab) {
			ViewA()
				.tabItem { Label("Aardbei", systemImage: "a.circle") }
				.tag(1)

			ViewB()
				.tabItem { Label("Banaan", systemImage: "b.circle") }
				.tag(2)

		}.sheet(isPresented: .constant(false)) {Special()}
	}
}

struct Special: View {
	let body = EmptyView()
}

struct ViewX: TaggedView {
	var content: some View {
		Text("This is X")
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
		ContentView(selectedTab: 2).colorScheme(.dark)
		Text("Only text")
		ViewX().padding()
	}
}
