//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//


//Messaging from Page to Live View:
import Foundation
import PlaygroundSupport
//Use the call below to send a message with an object to the LiveView of this page. Import Foundation is required.
//





//Give hints and final solution:
//PlaygroundPage.current.assessmentStatus = .fail(
//hints: [
//"You could [...].",
//"Try also [...]."
//],
//solution:
//"Do [...]."
//)
//#-code-completion(identifier, show, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, Y, Z)
//show(letter: ./*#-editable-code*//*#-end-editable-code*/)


// Completion of user-entered code:
//Use //#-code-completion syntax to allow only specified code to be entered by the user. (info here: https://developer.apple.com/documentation/swift_playgrounds/customizing_the_completions_in_the_shortcut_bar)



func show(letter: Letter) {
    sendValue(.string(letter.rawValue))
}

class Telegraph {
    var codedMessage: [MorseLetter]?
    var speed: Int = 5
    func prepare() {}
}
//let telegraph = Telegraph()


//show(letter: /*#-editable-code*/<#T##Letter##Letter#>/*#-end-editable-code*/)
//#-end-hidden-code
/*:
 **Challenge**: Send a morse message
 
 In the past, morse code was a very important way of communication. The messages were sent through a device called **telegraph** that was in charge of converting the taps into electrical signals.
 
 ![Telegraph](telegraph_photo.jpg)
 It was the first system that allowed instant communication, regardless of geographical distance. It became the base of all subsequent evolution of telecommunications.
 
 ## Cutting to the chase
 
 Let's begin writing the message we want to send
 */
//#-code-completion(everything, hide)
let message = "/*#-editable-code*/I love morse code/*#-end-editable-code*/"
//#-hidden-code
//message = message.cleared
//#-end-hidden-code
/*:
 Now **run the code** an get ready for sending the message.
 
 * callout(Hint):
 You will have to tap the telegraph's button when a signal gets inside the highlighted area
 */
let telegraph = Telegraph()

// Convert message to morse code
telegraph.codedMessage = message.encodeToMorse()

// Change the speed to modify the difficulty
telegraph.speed = /*#-editable-code*/5/*#-end-editable-code*/ //Dots per sec

// Turn on the telegraph
telegraph.prepare()

//#-hidden-code
sendValue(.integer(telegraph.speed))
sendValue(.string(message.cleared))
PlaygroundPage.current.needsIndefiniteExecution = true


// PlaygroundPage.current.finishExecution()
//public func receive(_ message: PlaygroundSupport.PlaygroundValue) {
//    sendValue(.string("Hola Caracola"))
//}
//
calculateTime(message: message.cleared, timeRatio:  1.0/Double(max(1, telegraph.speed) )) {
    PlaygroundPage.current.assessmentStatus = .pass(message: "### Congrats! \n You send your first morse message. Now you can change the speed to make it more difficult")
    PlaygroundPage.current.finishExecution()
}
//#-end-hidden-code
