//
//  ContentView.swift
//  project_euler_1
//
//  Created by Ben Scanlan on 4/12/23.
//

import SwiftUI

struct ContentView: View {
//https://developer.apple.com/documentation/swiftui/state
    @State private var firstNumber = ""
    @State private var secondNumber = ""
    @State private var thirdNumber = ""
    @State private var result = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                Text("Project Euler Problem 1")
                .padding()
                Text("Example: Find the sum of all the multiples of 3 or 5 below 1000.")
            
            TextField("Enter the first number", text: $firstNumber)
                .padding()
                .keyboardType(.numberPad)
            
            TextField("Enter the second number", text: $secondNumber)
                .padding()
                .keyboardType(.numberPad)
            
            TextField("Enter the range", text: $thirdNumber)
                .padding()
                .keyboardType(.numberPad)
            
            Button("Find Sum of Multiples") {
                let number1 = Int(firstNumber) ?? 0
                let number2 = Int(secondNumber) ?? 0
                let range3 = Int(thirdNumber) ?? 0
                var multipliedValue = 0
                
                for i in 0...range3-1 {
                    if ( i % number1 == 0 || i % number2 == 0 ) {
                        multipliedValue = multipliedValue + i
                    }
                    
                }
            //https://www.s-anand.net/euler.html
                result = "\(multipliedValue)"
            }
            .padding()
            
            Text("Result: \(result)")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
