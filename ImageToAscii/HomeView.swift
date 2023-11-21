//
//  HomeView.swift
//  ImageToAscii
//
//  Created by Kadek Edwin on 20/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var asciiArt: String = ""
    @State private var imageWidth: CGFloat = 1.0
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Text(asciiArt)
                .font(.custom("Courier", size: screenWidth/imageWidth))
                .padding()

            Button("Generate ASCII Art") {
                generateASCIIArt()
            }
        }
    }

    func generateASCIIArt() {
        guard let image = UIImage(named: "test") else {
            print("Error loading image.")
            return
        }

        let asciiArt = convertToASCII(image: image)
        self.asciiArt = asciiArt
    }

    func convertToASCII(image: UIImage) -> String {
        guard let cgImage = image.cgImage else {
            return "Error converting image to grayscale."
        }

        // Image dimensions
        let width = cgImage.width
        let height = cgImage.height
        
        imageWidth = CGFloat(width/4)
        
        print(screenWidth)
        print(imageWidth)
        
        var asciiArt = ""

        // ASCII characters arranged by intensity
        let asciiChars = "@%#*+=-:. "

        // Iterate over each pixel and convert to ASCII
        for y in stride(from: 0, to: height, by: 6) {
            for x in stride(from: 0, to: width, by: 4) {
                let pixel = cgImage.colorAt(x: x, y: y)
                let intensity = pixel?.grayscaleIntensity ?? 0.0

                // Map intensity to ASCII character
                let charIndex = Int(intensity * Double(asciiChars.count - 1))
                let asciiChar = String(asciiChars[asciiChars.index(asciiChars.startIndex, offsetBy: charIndex)])

                asciiArt.append(asciiChar)
            }
            asciiArt.append("\n")
        }

        return asciiArt
    }
}

extension CGImage {
    func colorAt(x: Int, y: Int) -> UIColor? {
        guard let dataProvider = dataProvider else { return nil }
        guard let data = dataProvider.data else { return nil }

        let pixelData = CFDataGetBytePtr(data)

        let bytesPerPixel = bitsPerPixel / 8
        let pixelIndex = y * bytesPerRow + x * bytesPerPixel

        let red = CGFloat(pixelData![pixelIndex]) / 255.0
        let green = CGFloat(pixelData![pixelIndex + 1]) / 255.0
        let blue = CGFloat(pixelData![pixelIndex + 2]) / 255.0
        let alpha = CGFloat(pixelData![pixelIndex + 3]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    var grayscaleIntensity: Double {
        var white: CGFloat = 0.0
        getWhite(&white, alpha: nil)
        return Double(white)
    }
}

#Preview {
    HomeView()
}
