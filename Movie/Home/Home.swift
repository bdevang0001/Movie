//
//  Home.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

struct Home: View {
  @State var title: String = "Home"
 @State var arrImges: [String] = ["capsicum","chilli","tree"]
    @State var count:Int = 1
    var body: some View {
        TabBackground {
            ZStack {
                VStack {
                    Text("What do you want to watch?")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.top, 20)
                    HStack {
                    TextField("Search", text: $title)
                            .foregroundColor(.white)
                            .padding()
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                            .padding()
                        
                    }
                    .background(Color.gray)
                    .cornerRadius(20)
                    .padding()
                    .foregroundColor(Color.white)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(arrImges, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 250)
                                    .cornerRadius(30)
                                    .padding(4)
                            }
                        }
                        LazyHStack {
                            ForEach(arrImges, id: \.self) { imageName in
                                
                            }
                        }
                        .background(Color.clear)
                    }
                }
                
            }
        }
    }
}

#Preview {
    Home()
}
