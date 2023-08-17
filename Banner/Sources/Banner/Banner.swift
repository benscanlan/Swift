// The Swift Programming Language
// https://docs.swift.org/swift-book
//import SPMUtility
//import ArgumentParser
//@main
//
//struct MyApp {
//
//    static func main() throws {
//        print("Hello")
//
//    }
//}
import ArgumentParser

struct MyTool: ParsableCommand {
    @Argument(help: "A sample argument")
    var sampleArgument: String

    func run() throws {
        print("Sample argument value: \(sampleArgument)")
    }
}

@main
struct Main {
    static func main() {
        MyTool.main()
    }
}



