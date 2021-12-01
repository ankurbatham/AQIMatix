# AQIMatix
This project description real time data about Air quality matrix. If a user clicks a particular city he is redirected to a graph page where se can see live data in animating forms.


# **Usage**

Xcode : 13+ SDK: iOS 15.0 Cocoapods : Yes Architecture: MVVM

# **Architecture** 

![download](https://user-images.githubusercontent.com/4144099/144232405-4c88fe52-1477-48ef-85dc-2a3440c25b95.png)

# **Feature**
Application is connecting to websocket in AppDelegate and update data to UI from delegate methods
CitiesAQIViewController shows cities data in list view that bind with CityAQIViewModel
If a user selects a city then he can see live data on a CityGraphViewController.

# **TODO's**
Unit tests for better code coverage.
UI tests for better UI experiance. 
