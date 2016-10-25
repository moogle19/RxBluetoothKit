import PackageDescription

let package = Package(
	name: "RxBluetoothKit",
	dependencies: [
		.Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 3, minor: 0),
	]
)
