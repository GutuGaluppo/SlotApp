//
//  ContentView.swift
//  SlotApp
//
//  Created by Gutu Galuppo on 21.08.20.
//  Copyright © 2020 Gutu Galuppo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var symbols = ["apple", "cherry", "star"]
    @State private var credits = 1000
    
    @State private var numbers = Array(repeating: 0, count: 9)
    // Without the Method (Array(repoating: _, count:_)
    //@State private var numbers = [0,0,0,0,0,0,0,0,0]
    
    @State private var backgrounds = Array(repeating: Color.white, count: 9)
    // Without the Method
    // @State private var backgrounds = [
    // Color.white, Color.white, Color.white,
    // Color.white, Color.white, Color.white,
    // Color.white, Color.white, Color.white ]
    
    private var betAmount = 5
    
    //    @State private var pointStatus = ""
    //    private var won = "You won: "
    //    private var lose = "You lose: "
    //    @State private var points = 0
    
    @State var isActive: Bool = false
    
    var body: some View {
        
        ZStack{
            // Background
            Rectangle()
                .foregroundColor(Color(
                    red:200/255, green:143/255, blue: 32/255))
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .foregroundColor(Color(
                    red:228/255, green:195/255, blue: 76/255))
                .rotationEffect(Angle(degrees: 45))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Spacer()
                // Title
                HStack{
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("SwiftUI Slots")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }.scaleEffect(2)
                
                Spacer()
                
                // Credits counter
                Text("Credits: " + String(credits))
                    .foregroundColor(.black)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                
                //                Text("\(String(pointStatus)) \(Int(points))")
                //                .foregroundColor(.white)
                //                .bold()
                //                .font(.headline)
                
                Spacer()
                VStack {
                    HStack{
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[0]], background: $backgrounds[0])
                        CardView(symbol: $symbols[numbers[1]], background: $backgrounds[1])
                        CardView(symbol: $symbols[numbers[2]], background: $backgrounds[2])
                        
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[3]], background: $backgrounds[3])
                        CardView(symbol: $symbols[numbers[4]], background: $backgrounds[4])
                        CardView(symbol: $symbols[numbers[5]], background: $backgrounds[5])
                        
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[6]], background: $backgrounds[6])
                        CardView(symbol: $symbols[numbers[7]], background: $backgrounds[7])
                        CardView(symbol: $symbols[numbers[8]], background: $backgrounds[8])
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                HStack ( spacing: 40){
                    // Single spin button
                    VStack {
                        Button(action: {
                            // Process a sigle spin
                            self.processResult()
                        }) {
                            HStack {
                                Text("1 Row")
                                    .fontWeight(.bold)
                                    .font(.body)
                            }
                        }
                        .buttonStyle(GradientBackgroundStyle())
                        Text("\(betAmount) credits").padding(.top, 10).font(.footnote)
                    }
                    // Max spin button
                    VStack {
                        Button(action: {
                            // Process Max Spin
                            self.processResult(true)
                        }) {
                            HStack {
                                Text("Spin All")
                                    .fontWeight(.bold)
                                    .font(.body)
                            }
                        }
                        .buttonStyle(GradientBackgroundStyle())
                        Text("\(betAmount * 5)  credits").padding(.top, 10).font(.footnote)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    func processResult(_ isMax:Bool = false) {
        // Set background back to white
        self.backgrounds = self.backgrounds.map({
            _ in Color.white
        })
        if isMax {
            // Spin all cards
            self.numbers = self.numbers.map({
                _ in Int.random(in: 0...self.symbols.count - 1)
            })
        }
        else {
            // Spin the middle row
            // Change the images
            self.numbers[3] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[4] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[5] = Int.random(in: 0...self.symbols.count - 1)
        }
        
        // Check winnings
        processingWin(isMax)
        
    }
    
    func processingWin(_ isMax:Bool = false){
        
        var matches = 0
        
        if !isMax {
            // Processing for single row
            if isMatch(3, 4, 5){ matches += 1 }
        }
        else {
            // Top row
            if isMatch(0, 1, 2){ matches += 1 }
            
            // Middle row
            if isMatch(3, 4, 5){ matches += 1 }
            
            // Bottom row
            if isMatch(6, 7, 8){ matches += 1 }
            
            // Right column
            if isMatch(0, 3, 6){ matches += 1}
            
            // Middle column
            if isMatch(1, 4, 7){ matches += 1}
            
            // Left column
            if isMatch(2, 5, 8){ matches += 1}
            
            // Diagonal Top Left to Bottom Right
            if isMatch(0, 4, 8){ matches += 1 }
            
            // Diagonal Top Right to Bottom Left
            if isMatch(2, 4, 6){ matches += 1 }
        }
        
        // Check matches and distribute credits
        if matches > 0 {
            // At least 1 win
            self.credits += matches * betAmount * 2
        }
        else if !isMax{
            // 0 wins, single spin
            self.credits -= betAmount
        }
        else {
            // 0 wins, max spin
            self.credits -= betAmount * 5
        }
    }
    
    func isMatch(_ index1:Int, _ index2:Int, _ index3:Int) ->
        
        Bool {
            
            if self.numbers[index1] == self.numbers[index2] &&
                self.numbers[index2] == self.numbers[index3]{
                
                self.backgrounds[index1] = Color.green
                self.backgrounds[index2] = Color.green
                self.backgrounds[index3] = Color.green
                
                return true
            }
            else {
                return false
            }
        }
}

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.all, 10)
            .padding([.leading, .trailing], 30)
            .foregroundColor(.white)
            .background(Color.pink)
            .cornerRadius(20)
            .offset(x: 0, y: configuration.isPressed ? 2 : 0)
            .shadow(color: Color.black, radius: 2, x: 0, y: configuration.isPressed ? 2 : 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
