import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            Counter()
        }
    }
}

struct Counter: View {
    @State var view_model: ViewModel;
    
    public init() {
        self.view_model = ViewModel()
    }

    var body: some View {
        HStack {
            Button(action: {
                self.view_model.action(action: .decrement)
            }) {
                Text("-")
                    .font(.largeTitle)
                    .frame(width: 50, height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text("\(self.view_model.count)")
                .font(.largeTitle)
                .frame(width: 50, height: 50)

            Button(action: {
                self.view_model.action(action: .increment)
            }) {
                Text("+")
                    .font(.largeTitle)
                    .frame(width: 50, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        Counter()
    }
}
