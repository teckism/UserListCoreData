# UserListCoreData


## About UserListCoreData App

UserListCoreData(StockList) is a sample code project for iOS. In this sample, the app fetches a list of user from server and maps the data into core data for offline availability. The Search is performed locally and the search text for which the results are not found is stored in coredata as blacklisted. Further any search query from the blacklisted text returns no data instead of performing entire search mechanism.

## Written in Swift

This sample is written in Swift. 


## Application Architecture

The sample project includes iOS app targets, iOS app extensions, and pods dependencies. Also it follows an architecture which is a modified form of Model-View-ViewModel (MVVM) design pattern and uses modern app development practices including Storyboards and Auto Layout. In the iOS version, the user can see list of people using a table view implemented in the UsersListViewController class.

###iOS Scenarios

The app handles various scenarios as follows

If you slide a particular row you wil get options to add or remove a particular entry. (It only has the UI Implemented)
Offline Handling for various scenarios has been implemented.
1 - First time launch of the app, the local db doesn't contain any data. If local db doesn't have any data and no internet connection, the user will see a illustrative screen for no internet connection with try again option.
2 - Launch of the app with no internet connection, the db has some data stored locally(cached), at this moment the api call won't be executed since user doesn't have net connection
User will be able to see the cached data, and a toast message is shown to the user for no net connection.
3 - API Call failure can be handled with no local data and without local data similarly having illustrative view with try again option and toast option

The app performs search only if the search text is not blacklisted in core data
A text is inserted in core data only if the text doesn't give any search result
Search is performed on the Display Name of the user.

## Swift Features

The sample leverages many features unique to Swift, including the following:

#### String Constants

Constants are defined using structs and static members to avoid keeping constants in the global namespace. One example is Alerts constants, which are typically defined as global string constants in Objective-C. Nested structures inside types allow for better organization of Alerts in Swift.

#### Extensions on Types at Different Layers of a Project

The Extensions file contains various extension methods to the existing class of swift. One such example is converting a Hex string into UIColor Object.

