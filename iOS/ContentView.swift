import SwiftUI
import TGKit

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            GameView()
                .padding()
            Spacer()
        }
    }
}
