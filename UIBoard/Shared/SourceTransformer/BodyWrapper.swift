//
//  BodyWrapper.swift
//  UIBoard
//
//  Created by Damiaan on 01/07/2021.
//

//import SwiftSyntax
//
//typealias FileTransformer = BodyWrapper.FileTransformer
//
//enum BodyWrapper {
//	class FileTransformer: SyntaxRewriter {
//		let locations: Set<Int>
//
//		init(locations: [Int]) {
//			self.locations = Set(locations)
//		}
//
//		override func visit(_ node: PatternBindingSyntax) -> Syntax {
//			guard let identifier = node.pattern.as(IdentifierPatternSyntax.self),
//				  locations.contains(identifier.positionAfterSkippingLeadingTrivia.utf8Offset) else { return Syntax(node) }
//
//			var newBinding = node
//			if let body = node.accessor {
//				let newAccessor: Syntax
//				switch body.as(SyntaxEnum.self) {
//				case .accessorBlock(let accessorBlock): // full blown accessor block
//					print("rewriting accessor block of `\(node.pattern)`")
//					newAccessor = AccessorTransformer().visit(accessorBlock)
//				case .codeBlock(let getterBlock): // shortened getter block
//					print("rewriting shortened getter block of `\(node.pattern)`")
//					newAccessor = Syntax(wrap(codeBlock: getterBlock))
//				default:
//					newAccessor = body
//				}
//				newBinding = newBinding.withAccessor(newAccessor)
//			}
//			if let body = node.initializer {
//				print("rewriting initializer of `\(node.pattern)`")
//				let newInitializer = body.withValue(wrap(expression: body.value))
//				newBinding = newBinding.withInitializer(newInitializer)
//			} else {
//				print("(no initializer)")
//			}
//			return Syntax(newBinding)
//		}
//
//		class AccessorTransformer: SyntaxRewriter {
//			override func visit(_ node: AccessorDeclSyntax) -> DeclSyntax {
//				guard node.accessorKind.text == "get", let getterBlock = node.body else { return DeclSyntax(node) }
//				let wrappedNode = node.withBody(wrap(codeBlock: getterBlock))
//				return DeclSyntax(wrappedNode)
//			}
//		}
//	}
//
//	static func taggerExpression() -> ExprSyntax {
//		let tagger = SyntaxFactory.makeIdentifier("tagVisibleAreaWithTagger")
//		let taggerIdExpression = SyntaxFactory.makeIdentifierExpr(identifier: tagger, declNameArguments: nil)
//		return ExprSyntax(taggerIdExpression).withTrailingTrivia(.spaces(1))
//	}
//
//	static func wrap(codeBlock: CodeBlockSyntax) -> CodeBlockSyntax {
//		let taggedBody = FunctionCallExprSyntax { functionBuilder in
//			functionBuilder.useCalledExpression(taggerExpression())
//			let closure = SyntaxFactory.makeClosureExpr(
//				leftBrace: SyntaxFactory.makeLeftBraceToken(),
//				signature: nil,
//				statements: codeBlock.statements,
//				rightBrace: SyntaxFactory.makeRightBraceToken(leadingTrivia: .newlines(1), trailingTrivia: .zero)
//			)
//			functionBuilder.useTrailingClosure(closure)
//		}
//
//		return CodeBlockSyntax { block in
//			block.useLeftBrace(SyntaxFactory.makeLeftBraceToken())
//			let newBody = SyntaxFactory
//				.makeCodeBlockItem(item: Syntax(taggedBody), semicolon: nil, errorTokens: nil)
//				.withLeadingTrivia(.spaces(1))
//			block.addStatement(newBody)
//			block.useRightBrace(SyntaxFactory.makeRightBraceToken())
//		}
//	}
//
//	static func wrap(expression: ExprSyntax) -> ExprSyntax {
//		let wrappedExpression = FunctionCallExprSyntax { builder in
//			builder.useCalledExpression(taggerExpression())
//			let closure = ClosureExprSyntax { closureBuilder in
//				closureBuilder.addStatement(SyntaxFactory.makeCodeBlockItem(item: Syntax(expression), semicolon: nil, errorTokens: nil))
//				closureBuilder.useLeftBrace(SyntaxFactory.makeLeftBraceToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
//				closureBuilder.useRightBrace(SyntaxFactory.makeRightBraceToken())
//			}
//			builder.useTrailingClosure(closure)
//		}
//		return ExprSyntax(wrappedExpression)
//	}
//
//}
