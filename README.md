# weather-app
## Overview
A little weather forecast app.
It displays a weather forecast for the next 5 days.
- Currently supported cities: Paris

## Launch
1. Download .zip project
2. Unzip the files
3. Open **Weather.xcodeproj**
4. Refresh Swift Packages
5. Hit "Run"

## Technical details
- Supported iOS version: <17
- Supported devices: iPhone, iPad, Mac, Apple Vision
- Architecture: **MVVM with presenters and routers.**
The app is simple enough to use a basic MVVM pattern. To keep views clean, mappings to view states were separated into presenters.
- Dependencies: **SPM**, native solution to dependecy managment 
- RxSwift: Used across the app, from fetching the data from the API to passing the data to the view and binding the table view with the state.
