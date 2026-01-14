/*
    LibrePods - AirPods liberated from Apple's ecosystem
    Copyright (C) 2025 LibrePods contributors

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import SwiftUI

struct OnboardingScreen: View {
    
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to LibrePods",
            description: "Unlock the full potential of your AirPods on any device",
            icon: "airpodspro",
            color: .blue
        ),
        OnboardingPage(
            title: "Noise Control",
            description: "Easily switch between noise control modes without reaching for your AirPods",
            icon: "waveform",
            color: .purple
        ),
        OnboardingPage(
            title: "Battery Monitoring",
            description: "View accurate battery levels for your AirPods and case",
            icon: "battery.100",
            color: .green
        ),
        OnboardingPage(
            title: "Head Gestures",
            description: "Answer calls with a nod or decline with a shake",
            icon: "figure.walk",
            color: .orange
        ),
        OnboardingPage(
            title: "Hearing Aid",
            description: "Configure hearing aid features and customize transparency mode",
            icon: "ear.fill",
            color: .red
        )
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Continue button
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    completeOnboarding()
                }
            }) {
                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding()
            
            if currentPage > 0 {
                Button("Skip") {
                    completeOnboarding()
                }
                .foregroundColor(.secondary)
                .padding(.bottom)
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboarding_completed")
        showOnboarding = false
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundStyle(page.color.gradient)
            
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview
struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(showOnboarding: .constant(true))
    }
}
