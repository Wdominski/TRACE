//
//  EventHandler.swift
//  TRACE
//
//  Created by William Dominski on 10/30/20.
//

import SwiftUI

struct EventHandler: View {
@State var data = ["CS506", "Second item", "Third Item", "Complete iteration 1 we got this", "fix index oob error"]
@Binding var eventMode: Bool
@State var index = 0
@State var amountDragged = CGSize.zero

var body : some View {
    let drag = DragGesture()
        .onChanged {
            self.amountDragged = $0.translation
        }
        .onEnded {
            if $0.translation.height < -100 {
                withAnimation {
                    if data.count > 0 {
                        self.data.remove(at: self.index)
                        if self.index >= self.data.count {
                            self.index = self.data.count - 1
                        }
                        print("After remove, size is \(self.data.count)")
                    }
                    self.amountDragged = .zero
                }
            } else {
                self.amountDragged = .zero
                
            }
        }
    
    GeometryReader { geo in
        ZStack {
            Color(rgb: [0, 0, 0], alpha: 0.3)
                .ignoresSafeArea(.all)
            
            // Vertical structure
            VStack {
                Text("Tap the Circle to edit\nSwipe up to delete.")
                    .font(Font.custom("Comfortaa-Regular", size: 18))
                    .foregroundColor(Color(rgb: WHITE))
                    .multilineTextAlignment(.center)
                    .offset(y: 30)
                
                if self.data.count > 0 {
                    // Events List
                    TabView(selection: self.$index) {
                        ForEach(0..<data.count, id: \.self) {item in
                            InfoView(index: self.index, mockData: self.data[item])
                                .padding(.horizontal, 5)
                                .scaleEffect(self.index == item ? 1.0 : 0.3)
                                .offset(y: amountDragged.height < 0 ? 10 + amountDragged.height : 10)
                                .disabled(amountDragged.height < -30 ? true : false)
                                .tag(self.index)
                                .gesture(drag)
                            }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    //.offset(y: -70)
                    .animation(.easeOut)
                    .frame(height: UIScreen.main.bounds.height - 240)
                } else {
                    Spacer()
                    Text("No scheduled events yet.\nMake one by using the + button on the homepage!")
                        .font(Font.custom("Comfortaa-Regular", size: 22))
                        .foregroundColor(Color(rgb: WHITE))
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width / 1.3)

                    Spacer()
                }
                // Exit Edit Mode
                Button(action: {
                        withAnimation{self.eventMode.toggle() }}) {
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
            } // End of VStack
        } // End of ZStack
    }
}
}

struct EventView : View {
let index: Int
let mockData: String  // replace with data element from database

init(index: Int, mockData: String) {
    self.index = index
    self.mockData = mockData
    UIScrollView.appearance().bounces = false
}


var body : some View {
    VStack {
        // Circle Subject Matter
        
        // Button to go to "AddView" (in edit mode)
        Button(action: {print("\(mockData) INDEX: \(index)")}) {
            ZStack {
                Circle()
                    .foregroundColor(index % 2 == 0 ? Color(rgb: ORANGE) : Color(rgb: RED))
                    .frame(width: UIScreen.main.bounds.width / 1.4, height: UIScreen.main.bounds.width / 1.4)
                    .shadow(color: index % 2 == 0 ? Color(rgb: ORANGE) : Color(rgb: RED), radius: 6)
                Text("\(mockData)")
                    .font(Font.custom("Comfortaa-Light", size: 40))
                    .padding()
                    .foregroundColor(Color(rgb: DARK_GREY))
                    .frame(width: UIScreen.main.bounds.size.width - 145, height: UIScreen.main.bounds.size.width - 160, alignment: .center)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                    .offset(y: 5)
            }
            
        }
        .padding(.bottom, 70)
        
        
        // Event Date & Time
        ZStack {
            RoundedRectangle(cornerRadius: 15.0)
                .foregroundColor(index % 2 == 0 ? Color(rgb: ORANGE) : Color(rgb: RED))
                .frame(width: UIScreen.main.bounds.size.width * 0.70, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(color: index % 2 == 0 ? Color(rgb: ORANGE) : Color(rgb: RED), radius: 3)
            Text("10/30/31\n8:20pm-10:05pm")
                .font(Font.custom("Comfortaa-Light", size: 24))
                .foregroundColor(Color(rgb: DARK_GREY, alpha: 0.9))
                .multilineTextAlignment(.center)
                //.offset(y: 5)
        }
        
    }
    
}
}
struct EventHandler_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
