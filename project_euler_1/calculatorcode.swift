import SwiftUI

struct ContentView: View {
    @State private var firstNumber = ""
    @State private var secondNumber = ""
    @State private var result = ""
    
    var body: some View {
        VStack {
            TextField("Enter the first number", text: $firstNumber)
                .padding()
                .keyboardType(.numberPad)
            
            TextField("Enter the second number", text: $secondNumber)
                .padding()
                .keyboardType(.numberPad)
            
            Button("Multiply") {
                let number1 = Int(firstNumber) ?? 0
                let number2 = Int(secondNumber) ?? 0
                let multipliedValue = number1 * number2
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

