// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MyKMMFramework",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MyKMMFramework",
            targets: ["shared"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "shared",
            url: "https://github.com/edwinps/pokemonApp/releases/assets/242560956.zip",
            checksum: "3ed98867c128e28f63d1dba60efcabafdaafa398ee6126affcd07653d30c32c6"
        )
    ]
)
