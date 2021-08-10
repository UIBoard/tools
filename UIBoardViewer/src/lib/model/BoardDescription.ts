export module UIBoard {
	export interface Description {
		module: string
		visualDecomposition: PreviewProvider[]
		genericDecomposition: GenericComposition
	}

	export type GenericComposition = {[identifier: string]: string[]}

	export interface PreviewProvider {
		identifier: string
		previews: Preview[]
	}

	export interface Preview {
		render: string
		info: PreviewInfo
	}

	export interface PreviewInfo {
		tags: ViewCollector
		scale: number
		viewport: CGRect
	}

	export interface ViewCollector {
		children: [CollectedView]
	}

	export interface CollectedView {
		type: string
		visibleArea: CGRect
		collector: ViewCollector
	}

	export type CGRect = [CGPoint, CGSize]

	/**
	 * (x y) tuple 
	 */
	 export type CGPoint = [number, number]
	/**
	 * (width height) tuple
	 */
	 export type CGSize = [number, number]
}