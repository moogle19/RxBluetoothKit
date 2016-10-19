import PackageDescription

let package = Package(
    name: "RxBluetoothKit",
    dependencies: [
        .Package(url: "https://github.com/ReactiveX/RxSwift.git", "3.0.0-rc.1")
    ]
)
