// Prime Number Finder in Swift

import Foundation

/// Checks if a number is prime.
func isPrime(_ num: Int) -> Bool {
    // Edge cases: numbers less than 2 are not prime
    guard num >= 2 else { return false }
    
    // Check divisibility up to the square root of the number
    let sqrtNum = Int(sqrt(Double(num)))
    for i in 2...sqrtNum {
        if num % i == 0 { return false }
    }
    
    return true
}

/// Finds prime numbers within a given range.
func findPrimes(inRange range: ClosedRange<Int>) -> [Int] {
    var primes: [Int] = []
    for num in range {
        if isPrime(num) {
            primes.append(num)
        }
    }
    return primes
}

// Example usage:
let lowerBound = 1
let upperBound = 100

if let primeNumbers = findPrimes(inRange: lowerBound...upperBound) {
    print("Prime numbers between \(lowerBound) and \(upperBound):")
    print(primeNumbers)
} else {
    print("No prime numbers found in the given range.")
}
