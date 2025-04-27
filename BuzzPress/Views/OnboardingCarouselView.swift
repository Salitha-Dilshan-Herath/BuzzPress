//
//  OnboardingCarouselView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-27.
//

import SwiftUI

struct OnboardingCarouselView: View {
    
    @State private var currentPage = 0
    var onComplete: () -> Void

    let onboardingScreens = [
        OnboardingScreen(
            title: "Stay Informed, Stay Ahead",
            subtitle: "Your personalized news experience starts here",
            imageName: "ic-carousel-1"
        ),
        OnboardingScreen(
            title: "Customized for Your Interests",
            subtitle: "Select your favourite topics for a tailored feed",
            imageName: "ic-carousel-2"
        ),
        OnboardingScreen(
            title: "Offline Reading",
            subtitle: "Save articles to read later, even without Internet connection.",
            imageName: "ic-carousel-3"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Carousel with TabView
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingScreens.count, id: \.self) { index in
                        OnboardingCardView(screen: onboardingScreens[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea(.container, edges: .top)
                
                
                // Next/Get Started button
                HStack {
                    // Page indicators (moved to bottom left)
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingScreens.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                                .frame(width: 14, height: 14)
                        }
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    // Next/Get Started button (moved to bottom right)
                    if currentPage < onboardingScreens.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.trailing)
                    } else {
                        Button(action: {
                            onComplete() 
                        }) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingCardView: View {
    let screen: OnboardingScreen
    
    var body: some View {
        VStack(spacing: 0) {
            // Image (from assets)
            Image(screen.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height * 0.55)
                .clipped()
                
            
            // Text content
            VStack(alignment: .leading, spacing: 16) {
                Text(screen.title)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(8)
                
                Text(screen.subtitle)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }.padding(.top, 32)
             .padding(.horizontal, 5)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(.container, edges: .top)
    }
}



struct OnboardingScreen: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

// Preview
struct OnboardingCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCarouselView(onComplete: {})
            .preferredColorScheme(.light)
        
        OnboardingCarouselView(onComplete: {})
            .preferredColorScheme(.dark)
    }
}
