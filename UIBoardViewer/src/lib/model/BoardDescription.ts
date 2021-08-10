export module UIBoard {
	export interface Description {
		module: string
		visualDecomposition: PreviewProvider[]
		genericDecomposition: GenericComposition
	}

	export type GenericComposition = {[identifier: string]: string[]}

	export type PreviewProvider = {
		identifier: string
		previews: Preview[]
	}

	export type Preview = {
		render: string
		info: PreviewInfo
	}

	export type PreviewInfo = {
		tags: ViewCollector
		scale: number
		viewport: CGRect
	}

	export type ViewCollector = {
		children: CollectedView[]
	}

	export type CollectedView = {
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