//
//  OnboardingCompleteView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct OnboardingCompleteView: View {
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // App Logo Text
            Text("BUZZPRESS")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color.blue)

            // Congratulations Text
            Text("Congratulations!")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.black.opacity(0.8))

            Text("Your account is ready to use")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            // Go to Homepage Button
            Button(action: {
                print("Navigate to Homepage")
                // Navigation code goes here
            }) {
                Text("Go to Homepage")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

#Preview {
    OnboardingCompleteView()
}
