//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tien Bui on 18/5/2023.
//

import SwiftUI

struct ImportantText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.primary)
            .bold()
    }
}

extension View {
    func importantText() -> some View {
        modifier(ImportantText())
    }
}

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(radius: 5)
         
    }
    
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var questionCounter = 1
    
    @State private var selectedFlag = -1
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]

    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.7, blue: 0.5), location: 0.3),
                .init(color: Color(red: 0.7, green: 0.6, blue: 0.4), location: 0.3)
            ], center: .top, startRadius: 100, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the flag")
                    .importantText()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.title)
                    }

                    VStack(spacing: 20) {
                        ForEach(0 ..< 3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                Image(countries[number])
                                    .modifier(FlagImage())
                                    .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                                    .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                    .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75 )
                                    .animation(.default, value: selectedFlag)
                                    .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()

                Text("Score: \(score)/\(questionCounter)")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
            .alert("Game over!", isPresented: $showingResult) {
                Button("Play again", action: resetGame)
            } message: {
                Text("Your final score is \(score)")
            }
            .padding()
        }
    }



    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            let needsThe = ["UK", "US"]
            if needsThe.contains(countries[number]) {
                scoreTitle = "Wrong! That's the flag of the \(countries[number])"
            } else {
                scoreTitle = "Wrong! That's the flag of \(countries[number])"
            }
        }
        showingScore = true
        if questionCounter == 8 {
            showingResult = true
        }
            
    }

    func askQuestion() {
        if !showingResult {
            countries.remove(at: correctAnswer)
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            questionCounter += 1
            selectedFlag = -1
        }
    }

    func resetGame() {
        score = 0
        questionCounter = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
