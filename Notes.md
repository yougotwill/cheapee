# ThinkNinjas Challenge

## Actions

- Scan an item and get its barcode https://developers.google.com/vision/ios/barcodes-overview
  - A. Capture data
  - B. if it exists update details
  - **Note**: we need to persist to the DB the captured data for the next time the app is used.
- Building up a list of items with vital stats that the user will evaluate with.
- Once the user has made a decision they can reset the list and start again.

```js
class Item() {
  constructor(barcode) {
    this.barcode = barcode; // unique to itself (Woolies beans = Checkers beans)
  }
}
```
### Extensions

- With a partner - leverage real-time database functionality. i.e. Firestore's snapshots + Flutter's Stream Builder

### Bonus

- Ability to specify the retailer that you are in and have the information per item, per retailer.
- Build up a history of prices per item.

## Notes

- UoM = Unit of Measurement
- [x] Form validation for inputted data?
  - https://flutter.dev/docs/cookbook/forms/validation
- [ ] Lookup tween animation

### Flutter/Dart Notes

- https://flutter.dev/docs/get-started/
- https://flutter.dev/docs/cookbook

- Widgets are immutable so you need a companion class if you want to change state.
- Stateful Widget = Widget stores information that can change, such as user input, or data from a feed.
- `_methods` are always made private by the Dart Compiler
- Cocapods can have problems if your ruby is outdated.
  - https://stackoverflow.com/questions/65197799/flutter-pod-install-problem-undefined-method-each-child-for-dir0x00007fa6

#### Constraints

**Constraints go down. Sizes go up. Parent sets position.**

- parents set constraint
- constraint is just a set of 4 doubles: a minimum and maximum width, and a minimum and maximum height.

https://flutter.dev/docs/development/ui/layout/constraints

#### Navigator

- Flutter has only one Navigator object. This widget manages Flutter’s screens (also called routes or pages) inside a `stack`.
- The screen at the top of the stack is the view that is currently displayed.
- Pushing a new screen to this stack switches the display to that new screen.
- Likewise, calling `pop()` on the Navigator returns to the previous screen.

#### Animation

- Take an existing Widget and extend it to an AnimatedWidget class.
- You can use an `AnimationController` to run any animation.
- `AnimatedBuilder` rebuilds the widget tree when the value of an Animation changes.
- Using a **Tween**, you can interpolate between almost any value, in this case, Color.

### Firebase

- https://www.freecodecamp.org/news/how-to-integrate-your-ios-flutter-app-with-firebase-on-macos-6ad08e2714f0/
- https://firebase.flutter.dev/docs/firestore/usage/

- Projects contain your apps (which could be on various platforms)
- Once apps are registered you can add various SDKs (Analytics, Cloud Firestore, etc.)
- Firebase falls under Google Cloud.

- FlutterFire are plugins that enable Flutter to use Firebase.
  - https://firebaseopensource.com/projects/firebaseextended/flutterfire/

#### Firestore

- [ ] When fetching data from Firestore and listening to changes it's more efficient to only fetch the data that has changed and not all of the data.

- https://www.youtube.com/watch?v=2Vf1D-rUMwE

- Document databse (tree structure)
- Documents are `<key,value>` pairs.
- `Collections` contain documents **nothing else**
- Data queries are **shallow**. You will only grab the document requested not the sub documents.
- Database root must be a collection.
- `firestore.collection1.doc('docName').collection2.doc('docName').collection3.doc('docName')` => `firestore.doc('collection1/docName')`
- `.set({ status: textToSave })` sets up document if it doesn't exist returns a `promise`
- `.get()` works in a similar fashion and returns a document snapshot.
- document snapshot => Object represents your document. Has ID and metadata, etc.
- get actual data from snapshot using `.data()`
- for realtime updates using `onSnapshot()`
```
Items
  ItemsData
    category
    name
    units
    UoM
    Price
    R per UoM
```

#### Firebase Flutter Codelab

- In the first stages of this dev, you can use test mode. Later though, you should write Firebase Security Rules to secure your database.
- The `provider` package separates the business from the display logic. Like React `Context` you can use it to make a centralized application state that is avaiable throughout the application tree. Has a `Provider` and `Consumer` logic.

##### Form Validation

- The way to validate a form involves accessing the form state behind the form, and for this you use a GlobalKey. https://www.youtube.com/watch?v=kn0EOS-ZiIc
- `TextFormField` is wrapped in an `Expanded` widget, this forces the `TextFormField` to take up any extra space in the row. https://flutter.dev/docs/development/ui/layout/constraints
- https://flutter.dev/docs/cookbook/forms/validation

- Dropdown https://dev.to/debbsefe/how-to-validate-a-dropdown-button-without-using-a-package-in-flutter-2cb9

##### Setting up security rules

- make sure a document has a `match` if you want access to it.
- control `allow read` and `allow write`
- Make sure to add validation rules to make sure that all expected fields are present in the request.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /guestbook/{entry} {
			allow read: if request.auth.uid != null;
      allow write:
      	if request.auth.uid == request.resource.data.userId
        	&& "name" in request.resource.data
          && "text" in request.resource.data
          && "timestamp" in request.resource.data;
    }
    match /attendees/{userId} {
    	allow read: if true;
      allow write: if (request.auth.uid == userId)
      	&& "attending" in request.resource.data;
    }
  }
}
```
