import ProjectDescription

let projectName = "Miso"
let orginazationIden = ".junseopark"

let project = Project(
    name: projectName,
    organizationName: nil,
    packages: [
        .remote(
            url: "https://github.com/hackiftekhar/IQKeyboardManager.git",
            requirement: .upToNextMajor(from: "6.5.0")
        ),
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.0.1")
        ),
        .remote(
            url: "https://github.com/Moya/Moya.git",
            requirement: .upToNextMajor(from: "15.0.0")
        ),
        .remote(
            url: "https://github.com/RxSwiftCommunity/RxKeyboard.git",
            requirement: .upToNextMajor(from: "2.0.1")
        ),
        .remote(
            url: "https://github.com/devxoul/Then",
            requirement: .upToNextMajor(from: "2")
        ),
        .remote(
            url: "https://github.com/ReactorKit/ReactorKit.git",
            requirement: .upToNextMajor(from: "3.0.0")
        ),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.6.0")),
        .package(
            url: "https://github.com/uuuunseo/AEOTPTextField.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/RxSwiftCommunity/RxFlow.git",
            .upToNextMajor(from: "2.10.0")
        ),
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            .upToNextMajor(from: "7.10.0")
        ),
        .package(
            url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
            .upToNextMajor(from: "5.0.0")
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .exact("10.4.0")
        )
    ],
    settings: nil,
    targets: [
        Target(
            name: projectName,
            platform: .iOS,
            product: .app,
            bundleId: "\(orginazationIden).\(projectName)",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
            infoPlist: .file(path: Path("\(projectName)/Support/Info.plist")),
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            dependencies: [
                .package(product: "RxFlow"),
                .package(product: "RxSwift"),
                .package(product: "RxCocoa"),
                .package(product: "RxKeyboard"),
                .package(product: "IQKeyboardManagerSwift"),
                .package(product: "SnapKit"),
                .package(product: "Moya"),
                .package(product: "RxMoya"),
                .package(product: "Then"),
                .package(product: "AEOTPTextField"),
                .package(product: "ReactorKit"),
                .package(product: "Kingfisher"),
                .package(product: "RxDataSources"),
                .package(product: "FirebaseMessaging")
            ]
        ),
    ],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: .default
)
