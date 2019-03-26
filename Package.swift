// swift-tools-version:4.2
// Generated automatically by Perfect Assistant Application
// Date: 2018-02-23 18:59:18 +0000
import PackageDescription
let package = Package(
	name: "PostgresStORM",
	products: [
		.library(name: "PostgresStORM", targets: ["PostgresStORM"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-PostgreSQL.git", from: "3.0.0"),
		.package(url: "https://github.com/SwiftORM/StORM.git", from: "3.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", from: "3.0.0"),
	],
	targets: [
		.target(name: "PostgresStORM", dependencies: ["PerfectPostgreSQL", "StORM", "PerfectLogger"])
	]
)
