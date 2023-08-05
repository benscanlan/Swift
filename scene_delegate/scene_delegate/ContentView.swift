//
//  ContentView.swift
//  scene_delegate
//
//  Created by Ben Scanlan on 8/1/23.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Hello, World!")
//                    .font(.largeTitle)
//                    .padding()
//
//                NavigationLink(destination: SecondView()) {
//                    Text("Go to Second Page")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//            }
//        }
//    }
//}
//
//struct SecondView: View {
//    var body: some View {
//        VStack {
//            Text("Welcome to the Second Page!")
//                .font(.largeTitle)
//                .padding()
//
//            NavigationLink(destination: ThirdView()) {
//                Text("Go to Third Page")
//                    .foregroundColor(.blue)
//                    .padding()
//            }
//        }
//    }
//}
//
//struct ThirdView: View {
//    var body: some View {
//        VStack {
//            Text("Welcome to the Third Page!")
//                .font(.largeTitle)
//                .padding()
//
//            // Add more content for the third page if needed
//        }
//    }
//}



//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Hello, World!")
//                    .font(.largeTitle)
//                    .padding()
//
//                NavigationLink(destination: SecondView()) {
//                    Text("Go to Second Page")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//            }
//        }
//    }
//}
//
//struct SecondView: View {
//    var body: some View {
//        VStack {
//            Text("Welcome to the Second Page!")
//                .font(.largeTitle)
//                .padding()
//
//            NavigationLink(destination: ThirdView()) {
//                Text("Go to Third Page")
//                    .foregroundColor(.blue)
//                    .padding()
//            }
//        }
//    }
//}
//
//struct ThirdView: View {
//    var body: some View {
//        VStack {
//            Text("Welcome to the Third Page!")
//                .font(.largeTitle)
//                .padding()
//
//            // Add more content for the third page if needed
//        }
//    }
//}


//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Hello, World!")
//                    .font(.largeTitle)
//                    .padding()
//
//                NavigationLink(destination: SecondView()) {
//                    Text("Go to Second Page")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//
//                NavigationLink(destination: ThirdView()) {
//                    Text("Go to Third Page")
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//            }
//        }
//    }
//}


import SwiftUI

//struct LaunchScreenView: View {
//    var body: some View {
//        ZStack {
//            Color.red // Replace with your desired background color
//
//            Text("Hello, Launch Screen!")
//                .foregroundColor(.white)
//                .font(.largeTitle)
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: SecondView()) {
                    Text("Go to Second Page")
                        .foregroundColor(.blue)
                        .padding()
                }

                NavigationLink(destination: ThirdView()) {
                    Text("Go to Third Page")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("Hello, Second Page!")
            .font(.largeTitle)
            .padding()
    }
}

struct ThirdView: View {
    var body: some View {
        Text("Hello, Third Page!")
            .font(.largeTitle)
            .padding()
    }
}
