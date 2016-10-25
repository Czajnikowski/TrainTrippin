Train Trippin
=======

This is a quick solution (they asked me to do it in 4-5 hours - it took a bit more in fact) to the task given to me by some company
as a part of recruting process:

The user need to travel by train every morning and every evening between Broombridge to
Dalkey.

-	The focus of the application is code and we do not expect a perfect UI design, however
the app should demonstrate a reasonable understanding of your platforms UI design guidelines.
-	The Application should persist data to provide an offline mode using some storage
mechanism of your choice. (This means the application should still function if the network
is disconnected).
-	If possible, please provide simple unit tests for important classes. (It is not necessary
to test all elements of the application)
-	Feel free to employ any libraries you feel are useful for the development of the project.
Be able justify your choice in the document you deliver with the code

The app uses [Irish Rail Realtime API](http://api.irishrail.ie/realtime/) and my proposed
solution is to simply alow user to browse live departure times from one of the mentioned
stations towards destination (as there is no direct connection between them and building
something more sophisticated will take more time).


Downloading the Code
----------------

Make sure you have Xcode installed from 
the App Store or wherever. Then run the following two commands to install Xcode's
command line tools and `bundler`, if you don't have that yet.

```sh
[sudo] gem install bundler
xcode-select --install
```

The following commands will set up Train Trippin. 

```sh
git clone git@github.com:Czajnikowski/TrainTrippin.git
cd TrainTrippin
bundle install
bundle exec fastlane make
```

Getting Started
---------------

Now that we have the code [downloaded](#downloading-the-code), we can run the
app using [Xcode 8](https://developer.apple.com/xcode/download/). Make sure to
open the `TrainTrippin.xcworkspace` workspace, and not the `TrainTrippin.xcodeproj` project.

Design Decisions
----------------

Architectural design of the app relies on the
[MVVM pattern](http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/) which
is slightly better than a common MVC pattern.

To allow offline access I have implemented NSURLCache-based response caching mechanism with strategy return
from cache than load.

My main goals were to split responsibilities reasonably among view controllers, view-models,
models, networking and views while maintaining statelesness and immutability, declarative
syntax and clean separation of concerns, so:

- View controllers are fully separated from networking and processing data. They bind to
Observables/Drivers of view-model
- View-models doesnt know anything about view controllers or UIKit
- Networking is fully separated and handled by view-model
- Model is just a dumb struct

To achieve my goals I have used:
- [RxSwift](https://github.com/ReactiveX/RxSwift) (with RxCocoa and
[RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources))
 
Additionally I have used:
- [SWXMLHash](https://github.com/drmohundro/SWXMLHash) (convenient XML parser)
- [AFDateHelper](https://github.com/melvitax/DateHelper) (convenience methods to work with
Date instances)

Tradeoffs, areas to improve
----------------

First off the proposed solution is very poor, but I needed to stick to something very simple
to deliver on time.

**Current issues:**
- "Pull to refresh" `UIRefreshControl` doesnt hide properly, and it hides even if new data
comes straight from cache
- View controllers create their view-models in two other ways - it should be unified
- `refreshControl` might be refactored to use CocoaAction for more consistency with other
reactive things
- Add some CountdownManager to refresh cells in DeparturesViewController and RouteViewController
- XML parsing should be extracted out of DeparturesViewModel
- To allow easier testing we should maintain references by protocols between view controllers,
view-models, networking and so on
- Declarative binding code in view controllers might be split into functions like
`configureTableView`, `configureButton` and so on
- Obviously UI/UX
