//
//  ContentView.swift
//  scene_delegate
//
//  Created by Ben Scanlan on 8/1/23.
//

import SwiftUI

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
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Second Page!")
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: ThirdView()) {
                Text("Go to Third Page")
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
}

struct ThirdView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Third Page!")
                .font(.largeTitle)
                .padding()

            // Add more content for the third page if needed
        }
    }
}

