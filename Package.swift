import PackageDescription

let package = Package(
    name: "RxBluetoothKit",
    targets: [],
    dependencies: [
        .Package(url: "http://github.com/ReactiveX/RxSwift",
                 "3.0.0-rc.1"),
        .Package(url: "http://github.com/Quick/Quick",
                 "0.10.0")
    ]
)

