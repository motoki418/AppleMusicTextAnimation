//
//  HomeView.swift
//  AppleMusicTextAnimation
//
//  Created by nakamura motoki on 2022/01/29.
//

import SwiftUI

struct HomeView: View {
    var body: some View{
        NavigationView{
            VStack(alignment: .leading, spacing: 22){
                GeometryReader{ proxy in
                    
                    let size = proxy.size
                    
                    // MARK: Sample Image
                    Image("Post")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(15)
                }//GeometryReader
                .frame(height: 220)
                .padding(.horizontal)
                
                Marquee(text: "Tech video games, failed cooking attempts, vlogs and more!", font: .systemFont(ofSize: 16, weight: .regular))
            }//VStack
            .padding(.vertical)
            .navigationTitle("Marquee Text")
        }//NavigationView
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: Marquee Text View
struct Marquee: View{
    
    @State var text: String
    // MARK: Customization Options
    var font: UIFont
    
    // Storying Text Size
    @State var storedSize: CGSize = .zero
    // MARK: Animation Offset
    @State var offset: CGFloat = 0
    
    // MARK: Animation Speed
    var animationSpeed: Double = 0.03
    var delayTime: Double = 0.5
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        // Since it scrolls horizontal using ScrollView
        ScrollView(.horizontal, showsIndicators: false){
            Text(text)
                .font(Font(font))
                .offset(x: offset)
                .padding(.horizontal, 15)
        }
        // MARK: Opacity Effect
        .overlay(content:{
            HStack{
                let color: Color = scheme == .dark ? .black : .white
                
                LinearGradient(colors: [color,color.opacity(0.5),color.opacity(0.3)],startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
                
                Spacer()
                
                LinearGradient(colors: [color,color.opacity(0.5),color.opacity(0.3)].reversed(), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
            }
        })
        // Disbaling Manual Scrolling
        .disabled(true)
        .onAppear{
            // Base Text
            let baseText = text
            
            // MARK: Continous Text Animation
            // Adding Spacing For Continous Text
            (1...15).forEach{ _ in
                text.append(" ")
            }
            // Stoping Animation exactly before the next text
            storedSize = textSize()
            text.append(baseText)
            
            // Calculating Total Secs based on Text width
            // Our Animation Speed for Each Character will be 0.02s
            let timing: Double = (animationSpeed * storedSize.width)
            
            // Delaying First Animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                withAnimation(.linear(duration: timing)){
                    offset = -storedSize.width
                }
            }
        }
        // MARK: Repeatin Marquee Effect with the help of Timer
        // Optional: If you want some delay for next animation
        .onReceive(Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime), on: .main, in: .default).autoconnect()){ _ in
            // Resetting offset to 0
            // thus ith look like its looping
            offset = 0
            withAnimation(.linear(duration:(animationSpeed * storedSize.width))){
                offset = -storedSize.width
            }
        }
    }
    // MARK: Fetching Text Size for Offset Animation
    func textSize() -> CGSize{
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}

