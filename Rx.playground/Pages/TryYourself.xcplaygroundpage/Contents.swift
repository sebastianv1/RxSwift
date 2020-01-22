/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxSwift-macOS** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 */
import RxSwift
/*:
 # Try Yourself
 
 It's time to play with Rx 🎉
 */
playgroundShouldContinueIndefinitely()

import Dispatch

let (signal, sink) = RxSignal<Int>.pipe()

signal.emitValues { (event) in
    switch event {
    case .next(let val):
        print(val)
    case .error(let e):
        print("Error: \(e)")
    case .completed:
        print("Completed")
    }
}

sink.onNext(3)
sink.onCompleted()

signal.emitValues { (event) in
    print(event)
}
