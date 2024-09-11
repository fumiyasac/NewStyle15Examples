//
//  ContentView.swift
//  NewStyle15SwiftUIExample
//
//  Created by 酒井文也 on 2024/09/01.
//

import SwiftUI
import UIKit

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

struct HeartShape: Shape {
    let minX = 10
    let maxX = 100
    
    let minY = 10
    let maxY = 100

    let centerX = 55

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(
                to: CGPoint(x: centerX, y: maxY)
            )
            path.addQuadCurve(
                to: CGPoint(x: minX, y: 50),
                control: CGPoint(x: minX, y: 70)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX, y: 30),
                control: CGPoint(x: minX, y: minY)
            )
            path.addQuadCurve(
                to: CGPoint(x: maxX, y: 50),
                control: CGPoint(x: maxX, y: minY)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX, y: maxY),
                control: CGPoint(x: maxX, y: 70)
            )
            path.closeSubpath()
        }
    }
}

struct TrainingAppHeartView: View {
    @State var isAnimation = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HeartShape()
                .stroke(Color.red,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round))
                .frame(width: 110, height: 110)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 110/2, height: 110/2)
                .rotationEffect(Angle(degrees: isAnimation ? 360 : 0),
                                anchor: .topLeading)
                .onAppear() {
                    withAnimation(
                        Animation
                            .linear(duration: 2)
                            .repeatForever(autoreverses: false)) {
                                isAnimation.toggle()
                            }
                }
        }
    }
}

struct ContentView2: View {
    @State private var animationAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // パスの定義
            Path { path in
                path.move(to: CGPoint(x: 100, y: 300))
                path.addCurve(to: CGPoint(x: 300, y: 300),
                              control1: CGPoint(x: 200, y: 100),
                              control2: CGPoint(x: 200, y: 500))
            }
            .stroke(Color.blue, lineWidth: 2)
            
            // アニメーションするビュー
            Circle()
                .fill(Color.red)
                .frame(width: 20, height: 20)
                .offset(x: -10, y: -10)
                .modifier(FollowPath(pct: animationAmount))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                animationAmount = 1.0
            }
        }
    }
}

struct FollowPath: GeometryEffect {
    var pct: CGFloat
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let path = Path { path in
            path.move(to: CGPoint(x: 100, y: 300))
            path.addCurve(to: CGPoint(x: 300, y: 300),
                          control1: CGPoint(x: 200, y: 100),
                          control2: CGPoint(x: 200, y: 500))
        }
        
        let point = path.trimmedPath(from: 0, to: pct).currentPoint ?? .zero
        return ProjectionTransform(CGAffineTransform(translationX: point.x, y: point.y))
    }
}

struct ContentView: View {
    @State private var items = (1...5).map { Item(id: $0, title: "Item \($0)") }
    @State private var animatingItemId: Int?
    @State private var animationProgress: CGFloat = 0

    var body: some View {
        ZStack {
            VStack {
                List(items) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        Button(action: { toggleFavorite(item) }) {
                            Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(item.isFavorite ? .red : .gray)
                        }
                    }
                }
                TabView {
                    Text("")
                        .tabItem {
                            Label("Page1", systemImage: "1.circle")
                        }
                        .tag(1)
                    Text("")
                        .tabItem {
                            Label("Favorite", systemImage: "heart")
                        }
                        .tag(2)
                    Text("")
                        .tabItem {
                            Label("Page1", systemImage: "3.circle")
                        }
                        .tag(3)

                }
                .frame(height: 50)
                .background(Color.gray.opacity(0.2))
            }
            
            heartAnimation
            
            TrainingAppHeartView()

            ContentView2()
            
            HeartShape()
                .stroke(Color.red,
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round))
                //.frame(width: 110, height: 110)
        }
    }
    
    private var heartAnimation: some View {
        GeometryReader { geometry in
            if let id = animatingItemId {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .position(animationPosition(for: id, in: geometry))
                    .scaleEffect(1 - animationProgress)
                    .opacity(1 - animationProgress)
            }
        }
    }
    
    private func animationPosition(for id: Int, in geometry: GeometryProxy) -> CGPoint {
        let startY = CGFloat(id * 50)
        let endY = geometry.size.height * 2.5 - 25
        let x = animationProgress * (geometry.size.width / 2 - geometry.size.width + 50)
        let y = startY + (endY - startY) * animationProgress
        return CGPoint(x: geometry.size.width - 50 + x, y: y)
    }
    
    private func toggleFavorite(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isFavorite.toggle()
            if items[index].isFavorite {
                animatingItemId = item.id
                withAnimation(.easeInOut(duration: 1)) {
                    animationProgress = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    animatingItemId = nil
                    animationProgress = 0
                }
            }
        }
    }
}

struct Item: Identifiable {
    let id: Int
    let title: String
    var isFavorite = false
}

#Preview {
    ContentView()
}
