//
//  FancySegmentControl.swift
//  Movie
//
//  Created by Apple on 24/04/26.
//

import SwiftUI

struct FancySegmentControl: View {
    let tabs = ["Now playing", "Upcoming", "Top rated", "Popular"]

    @Binding var selectedTab: String
    @Namespace private var underline

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tabs, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 10) {
                        Text(tab)
                            .font(.system(size: 15, weight: selectedTab == tab ? .semibold : .medium, design: .rounded))
                            .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.7))
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                            .frame(maxWidth: .infinity)

                        ZStack {
                            if selectedTab == tab {
                                Capsule()
                                    .fill(Color.white.opacity(0.22))
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "underline", in: underline)
                            } else {
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 4)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    TabBackground {
        FancySegmentControl(selectedTab: .constant("Now playing"))
            .padding()
    }
}
