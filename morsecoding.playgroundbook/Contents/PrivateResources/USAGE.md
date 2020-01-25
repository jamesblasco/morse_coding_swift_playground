#  Swift Playgrounds Author Template Extension #

### Introduction:

This is an extension of the Swift Playgrounds Author Template for Xcode 10 [released by Apple](https://developer.apple.com/download/more/?=Swift%20Playgrounds%20Author%20Template). It is based on the version released Nov 13, 2018.

This extended template allows you to create rich playground pages and chapters by using storyboards and view controllers that are placed in the book-level auxiliary sources. In this way, you can use syntax highlighting, code completion, and other editor features, and take advantage of the Xcode Interface Builder capabilities (like creating auto-layout constraints visually). You can also run the LiveViewTestApp on the Xcode Simulator (or on a real device) to test these views/storyboards, just like you would do in a regular iOS/macOS app. With this workflow, you minimize the code that will live inside the Chapters/Pages structure that's hard to test and debug.

### Usage:

1. Read the `README.md` file in this project to understand the basic structure of this project. In short, this project separates the chapters/pages of the playground book from the book-level auxiliary source files. You can work on these auxiliary sources as you would in any other Xcode project with full editor features and build your views with Interface Builder. This project also includes an iOS app that uses the same auxiliary sources to present these views for testing/debugging.

2. Replace `yourCoverImage.png` with your Playground book cover image in `PublicResources` (400x300 pixels, png).

3. Close the Xcode project and go to `PlaygroundBook/Chapters/Chapter1.playgroundchapter/Pages`. **In the Finder**, create copies of the `PlaygroundPage2.playgroundpage` folder. Name them accordingly for page 3, 4, 5, etc of your book.

4. Open the project again, and open `Chapters/Chapter1/Manifest.plist`. Go to the Pages group where you will see key `Item X` with value `PlaygroundPageX.playgroundpage`. Add Items for any new pages that you added in the previous step.

![alt text](usage_images/addpages.png "Add an item for every page in Manifest.plist")

5. Repeat steps 3-4 for adding Chapters (if you need more than one Chapter). The process for adding chapters is identical, just do it one level up in the project hierarchy. [More info](https://developer.apple.com/documentation/swift_playgrounds/structuring_content_for_swift_playgrounds) on Playground book structure.

6. Once you have all the chapters/pages that you need, duplicate (⇧⌘S) one of the `LiveView-x-y.storyboard` files so that you have one storyboard for each page. Keep them all in the same location, and remember to add LiveViewTestApp target membership. Name them like the included examples `LiveView-CHAPTER#-PAGE#.storyboard`.

![alt text](usage_images/duplicateStoryboards.png "Press ⇧⌘S to duplicate the storyboard files")

7. Go to the `LiveView.swift` file for each of your pages for each chapter. Make sure that the `instantiateLiveView(chapter:page:)` function is being called with the right chapter and page arguments. For example, the `LiveView.Swift` file in Chapter 3, page 2, should call `instantiateLiveView(chapter: 3, page: 2)` and then the `LiveView-3-2.storyboard` will be sent to the playground page.

8. Similarly, duplicate `LiveViewController_x_y.swift` so that you have one ViewController for every page of each chapter. Change the name of the class inside the `LiveViewController_x_y.swift` file accordingly (`public class LiveViewController_X_Y: LiveViewController {...}`) and then select your new Custom Class in the corresponding storyboard's View Controller's Identity Inspector. When you do it, the Module `Book_Sources` should appear automatically below the Class name.

![alt text](usage_images/viewControllerClass.png "Connect your storyboards with the corresponding custom View Controller classes.")

Now you can create your views in these storyboards and write content for each page. 

### Suggested workflow: 

+ While you're creating your views, use the LiveViewTestApp for testing. Use the simulator or a real iPad to see the results of your code. In order to select which view will be shown, go to `/LiveViewTestApp/AppDelegate.swift` and change the chapter and page in the line `return Book_Sources.instantiateLiveView(chapter: X, page: Y)`. You can also change `return .fullScreen` to `.sideBySide` to simulate the live view shown next to or above the source code editor. Select LiveViewTestApp in the Scheme selector and click Run.

![alt text](usage_images/buildLiveView.png "Select the App build scheme to test while creating views")

+ When you're happy with the way the views are working, add content, explanations, instructions etc in the `Contents.swift` file of each page. At the end, select the build scheme for the playgroundbook (the one with the lego icon) and press Cmd-B to build.

![alt text](usage_images/buildBook.png "Select the Playground book build scheme to test the book on an iPad")

+ In the Project Navigator, right click the `Playgrounds Author Template Extension.playgroundbook` in the `Products` group and select "Show in Finder". Now you can Airdrop this book to an iPad for further testing. This is also how you create the final, shareable Playground book.

![alt text](usage_images/viewBook.png "Show the Playground book in Finder and AirDrop to an iPad to test")

### Tips:
+ ⇧⌘K (Clean Build Folder) often.

+ If you use `@previous` and `@next` links in your playground pages, you don't need to allow navigation from one storyboard to another. The navigation should be through the chapters and pages of the book, otherwise the user might get confused.