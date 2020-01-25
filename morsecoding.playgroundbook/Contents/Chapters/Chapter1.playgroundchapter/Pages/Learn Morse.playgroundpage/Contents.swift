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

/*:
 * callout(Watch out!):
 let air = ".- .. .-."
 
 [Next Page](@next)*/



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

//var solution = ". . .   - - -   . . ."
// Completion of user-entered code:
//Use //#-code-completion syntax to allow only specified code to be entered by the user. (info here: https://developer.apple.com/documentation/swift_playgrounds/customizing_the_completions_in_the_shortcut_bar)
//
PlaygroundPage.current.assessmentStatus = .fail( hints: [
    "Each signal should be separated **one space** from the one before",
    "In morse code **S**  is `. . .`  and **O** is `- - -`",
    "Each letter should be separated **three** spaces from the one before"],
 solution: "**SOS** in morse code is  **. . .   - - -   . . .**")

func show(letter: Letter) {
    sendValue(.string(letter.rawValue))
}
// >  Be careful with the spaces between signals and letters
//show(letter: /*#-editable-code*/<#T##Letter##Letter#>/*#-end-editable-code*/)
//#-end-hidden-code
/*:
**Challenge**: Code our first morse message
 
In the side view you are able to navigate through the different letters and learn which code signals are associated with them. Now let's try to create our own message
 
## SOS: The best known morse signal
 
The use of **SOS** was introduced at the beginning of the 20th century and it's the standard signal used in case of emergency.
 
Let's try to learn how it is written in morse.
 
 1. Check the needed letters in the side view
 
 2. Write inside the quotation marks using dots **.** and dashes **-**
 
 3. Run the code
 

*/
//#-code-completion(everything, hide)
//#-code-completion(description, show, ".", "-", " ")
let sos = "/*#-editable-code*/<#T##Morse code##String#>/*#-end-editable-code*/"
//#-hidden-code

if sos.cleared == ". . .   - - -   . . ." {
//    PlaygroundPage.current.assessmentStatus = .pass(message: "Great job!")
    PlaygroundPage.current.assessmentStatus = .pass(message: "### Congrats! \n You encoded your first morse message. Let's try to send it now in the **[next Page](@next)**")
}

//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, show, sos)
//#-code-completion(description, hide, show(letter: Letter))

//#-end-hidden-code
//: >  Be careful with the spaces between signals and letters
