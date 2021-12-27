//
//  ContentView.swift
//  Shared
//
//  Created by no145 on 2021/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var message = "welcome."
    @State private var imageDisp = UIImage(named: Config.targetAsset)
    
    private let mlProcess = MLProcess()
    
    var body: some View {
        VStack {
            Text(message)
                .bold()
                .font(.title)
            Image(uiImage: imageDisp ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .clipped()
            Spacer()
                .frame(height: 32)
            HStack {
                Button(action: convert) {
                    Text("Convert")
                        .padding(12)
                }
                    .background(Color.brown)
                    .foregroundColor(Color.white)
                    .cornerRadius(.infinity)
                Spacer()
                    .frame(width: 32)
                Button(action: reset) {
                    Text("reset")
                        .padding(12)
                }
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(.infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
    }
    
    private func convert() {
        guard let image = imageDisp else {
            fatalError("image from asset is nil")
        }
        let startTime = CFAbsoluteTimeGetCurrent()
        if let output = try? mlProcess.process(image: image) {
            imageDisp = output
            let stopTime = CFAbsoluteTimeGetCurrent() - startTime
            message = "\(round(stopTime * 100) / 100) sec"
        } else {
            fatalError("failed to do ml process")
        }
    }
    
    private func reset() {
        imageDisp = UIImage(named: Config.targetAsset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
