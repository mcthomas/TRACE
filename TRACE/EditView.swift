//
//  EditView.swift
//  TRACE
//
//  Created by stonecodecs on 10/27/20.
//

import SwiftUI

struct EditView : View {
    @Binding var editMode: Bool
    
    var body : some View {
        ZStack {
            Color(rgb: [0, 0, 0], alpha: 0.3)
                .ignoresSafeArea(.all)
            
            // Vertical structure
            VStack {
                Spacer()
                Text("Tap the Circle to edit\nSwipe up to delete.")
                    .font(Font.custom("Comfortaa-Regular", size: 18))
                    .foregroundColor(Color(rgb: WHITE))
                    .multilineTextAlignment(.center)
                    .offset(y: -40)
                Spacer()
                
                // Events List
                ZStack {
                    Circle()
                        .foregroundColor(Color(rgb: ORANGE))
                        .frame(width: UIScreen.main.bounds.width / 1.4, height: UIScreen.main.bounds.width / 1.4)
                    Text("CS 506")
                        .font(Font.custom("Comfortaa-Light", size: 40))
                        .padding()
                        .foregroundColor(Color(rgb: DARK_GREY))
                        .frame(width: UIScreen.main.bounds.size.width - 145, height: UIScreen.main.bounds.size.width - 160, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                        .offset(y: 5)
                }.offset(y: -70)
                Spacer()
                
                // Exit Edit Mode
                Button(action: {
                        withAnimation{self.editMode.toggle() }}) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color(rgb: WHITE), lineWidth: 3)
                            .background(Circle().foregroundColor(Color(rgb: RED)))
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
                        Image("close_icon")
                            .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                            .scaleEffect(1.8)
                    }
                }
                Spacer()
            } // End of VStack
        } // End of ZStack
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
