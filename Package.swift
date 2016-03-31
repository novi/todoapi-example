import PackageDescription

let package = Package(
    name: "todoapi",
    dependencies: [
		    .Package(url: "https://github.com/novi/Kunugi.git", majorVersion: 0),
		    .Package(url: "https://github.com/nestproject/Nest.git", majorVersion: 0, minor: 2),
		    .Package(url: "https://github.com/nestproject/Inquiline.git", majorVersion: 0, minor: 2),
		    .Package(url: "https://github.com/takebayashi/http4swift.git", majorVersion: 0, minor: 0),
		    .Package(url: "https://github.com/novi/mysql-swift.git", majorVersion: 0),
		    .Package(url: "https://github.com/SwiftX/C7.git", majorVersion: 0),
		    .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0)
    ]
)