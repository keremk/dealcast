# Introduction

This is a sample iOS application that demonstrates the use of iBeacon and Twilio APIs. The application is divided into 2 sections: 

## Section 1:
This is the part that advertises a beacon with a deal. In a real world application, this will be a dedicated beacon device such as the ones from [Estimote](http://estimote.com/). This basically allows the user to pick a deal from the sample [deal server](https://github.com/keremk/deal-server). And once the deal is picked, the iPhone will need to kept open and it will advertise that deal using the iBeacon technology. That is basically all it does.

## Section 2:
In a real life application, this will be the consumer app for retail shoppers. In this scenario, the shopper is going through the aisles of a retailer (a big box retailer such as Best Buy etc.) and they can discover a deal for that aisle. The app constantly monitors for advertising beacons, and displays them in a table view. The deal details are retrieved from the deal server. When a deal is clicked, the shopper can read about the details and then optionally ask for help to call a salesperson to the aisle they are in. When they tap on call for help, the app calls the server to send an SMS using Twilio SMS APIs to the salespersons who are available. This is where in a real life scenario, the SMS is dispatched to the currently available salespersons on the floor. Also again using the Twilio APIs, the customer is automatically informed that help is coming via automated voice system. (In this case a simple TwiML application.)

# Setup

You need a combination of 2 iPhones(4s and up) or iPads(iPad 3 and up or iPad Mini). This application requires the use of Bluetooth 4, and it is only supported on those models. The application depends on the deal server, so that also needs to be running on a server that can be accessed outside of a firewall. [See the deal-server readme](https://github.com/keremk/deal-server)

* This project uses [cocoapods](http://cocoapods.org/) for external dependency management. Make sure you have cocoapods [installed and setup](http://cocoapods.org/) and then run pod install to install the external dependencies.
* Use the DealCast.xcworkspace to load the app in XCode 5. (Storyboard uses the XCode5, so it is required.)
* Open the settings.plist file and add your own API server URL there.
* The app will not run correctly in the simulator. So you need deploy the app to an iOS device. As indicated before, this requires 2 devices to run (one advertising beacon and other reading it.)
