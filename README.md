# Dummy Json Project for iOS
A basic application for fetching dummy user data from https://dummyjson.com/docs/users and deleting, editing or adding to that data. I used Alamofire for http requests, and Codable for parsing JSON.
## Motivation
The project was a part of a native mobile development course. The idea was to create a similar application for Android and iOS. Android was the main version for this project.
## Installation
Download one of the zip-files from the releases (ideally the latest one), extract the files from the zip, and use XCode to run the application.
## How to use?
Once the application launches you it automatically gets all users from the from the dummyjson-database. The buttons on the bottom of the screen allow you to add users, search for users or get all users. By pressing on the trash can icon you can delete an user.
### Adding users
After pressing the add-button, there are four fields (first name, last name, phone, email) you must fill. After all the fields are filled, press the add-button in the lower left. If you want to leave the "Add user"-sheet, you can press outside the sheet or press the cancel-button. After pressing "add" and waiting for the load, you should find your user at the end of the list. 
### Searching for users
After pressing the search-button, you can search for users based on name and email. After searching you can see every user that matches your search term. Added users are included and deleted users are excluded.
### Get all
Application gets all users when the application is started and after adding or deleting users. There is also the get all-button at the bottom right of the application, useful for getting all users after a search.
### Deleting users
You can delete users by pressing on the trash can icon on each users card.
## ScreenCast
https://www.youtube.com/watch?v=omet3phY7ak (Finnish)
## Final thoughts
I tried to keep this project similar in functionality with the Android version, without the editing functionality. I'm mostly happy with how the UI turned out, but I do think it looks worse than the Android version. XCode was generally easier to work with than Android Studio, but there were some stuff I wwasn't able to make look as nice as I would've liked, like the text on the usercards. Overall, I'm pretty happy with how it turned out.
