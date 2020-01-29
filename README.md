# Eko_Assignment
Github user list

## Application is built using MVVM architecture. Used NSUserDefaults to persist the favorite and unfavorite.

1. User(Model) - consists the properties related to User fetched from API.
2. UserListViewController(View) - consists the actions and loading of UI objects on the view consisting of User List.
3. GithubWebViewController(View) - consists the loading of the git home page of user selected.
4. UserListViewModel(ViewModel) - consists of the business logic where the network call is made for fetching and loading the user list data to tableview.
5. UserListViewCell - consists the cell which is getting loaded depending on the user list details.


## Network Layer is seperate with generic methods for reading the files using URLSession. It consists of 

1. NetworkManager - Consisting of the genric protocol based methods for fetching and decoding JSONs.
2. Reachability - To check the connectivity to internet.
3. UserListGetRequest/UserListGetManager - Creation and triggering of the URL request for fetching the user list from the json.
4. CacheManager - Handles the caching of the images downloaded from the API


## Utils classes are also present which give generic functionality which can be used throughout the applications

1. Extensions - Extensions written for classes(i.e UIViewController, DateFormatter) for adding alerts, activity indicator, convert date from string etc.
2. AppConstants - Application constants used throughout the app. Strings, Enums, Errors etc.
3. Utils - Functions related to the saving to NSUserDefaults for persistent storage of favorites


## Unit and UI XCTestCases with coverage of 92.8%(screenshot added).

1. UserListViewTests - Testing the user list tableview with and without data.
2. GithubWebViewTests - Testing the load of webview.
3. NetworkTests - Testing the NetworkManager methods
4. Eko_AssignmentUITests - Testing the app flow, scroll down to load data, pull to refresh and UIApplication background and foreground .

