# Swift Server - Let's get started

a FrenchKit 2019 classroom to help people discover swift on the server using the vapor framework.

## Requirements

* a mac running xcode 11.x
* or
  * a mac running xcode 10.2.x or even the text editor of your choice
  * or any pc running linux where swift is officially supported (a raspberry pi is one of those)
  * swift tools
    * by installing xcode command line tools
    * or following the https://swift.org/getting-started/ steps for linux
* [optional] docker tools installed (takes time!)

## Steps

1. [Build a simple CRUD service using REST routing on top of a SQLite storage](#build-a-simple-crud-service)
2. [share the model with your app](#share-your-model-with-your-app)
3. [Write unit tests for it](#unit-testing-your-vapor-server)
4. [Testing it on linux using a docker image](#testing-on-linux-using-docker)
5. [Add a Speaker relation](#add-a-speaker-relation)

### How to build and run

* If you're using xcode 11
  * simply open `Package.swift`, it will fetch the dependencies for you 🥰.
  * then build & run the 'Run' scheme on `My Mac`
* If you're using xcode 10.x
  * open the Terminal and run `swift package generate-xcodeproj`
  * then open the generated `fk-swift-server.xcodeproj`
  * then build & run the 'Run' scheme on `My Mac`
* If you're using linux
  * open the Terminal and run `swift package update` to fetch the dependencies
  * edit the source using your favorite text editor
  * build by typing `swift build`
  * test by typing `swift test`
  * run by typing `swift run`

### How to test your routes

Your browser will help you only for simple GET routes so prefer using a REST client of your choice.

If you don't have any yet, I suggest you to get [Postman](https://www.getpostman.com) which is free.

## Build a simple CRUD service

* Open App/EventApp.xcworkspace and build&run the app to see the app for which you're going to build the backend
* Then open the server app located in Server regarding your [configuration](#how-to-build-and-run)
  * These are the route already implemented:
    * [x] `GET /v1/talks` Gets all
    * [x] `POST /v1/talks` Add a create route
    * [x] `DELETE /v1/talks/:id` Delete by id route

### Try it now

* [ ] `GET /v1/talks/:id` Add a get by id route
* [ ] `PUT /v1/talks/:id` Add an update route

## Share your model with your app

* Clone the new repo <git package repo url> which contains the basics for your new library
  * a `Package.swift` file for Swift Package Manager (to use on the server)
  * a `Podspec` file for CocoaPods (to user with iOS)

### It's your turn

* [ ] Integrate the library server-side
* [ ] Integrate the library on iOS
* [ ] Activate network calls on iOS

## Unit testing your vapor server

Unit testing requires a few helpers that I've already included for you on the testing target. You may have to write some others.

### Please complete the test coverage

Now please add unit tests to test the routes you've added earlier.

## Testing on linux using docker

`Foundation` you use on macOS is not the same source code than the one you use on linux. Your server will certainly runs on linux so you need to test on it!

Docker permits that by using a Dockerfile to run `swift test` on a linux container.

`XCTest` is implemented on linux but needs extra code since it won't use the Objective-C runtime to list all testing methods.

## Going further

* [ ] Add a Speaker relation to the Talk (and adapt the iOS app)
* [ ] Add a Event entity which contains Talks and Speakers, a Speaker can be a part of several Events (and adapt the iOS app)
