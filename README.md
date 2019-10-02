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

## Steps

1. [Build a simple CRUD service using REST routing on top of a SQLite storage](#build-a-simple-crud-service)
2. [Write unit tests for it](#unit-testing-your-vapor-server)
3. [Testing it on linux using a docker image](#testing-on-linux-using-docker)
4. [Deploying on docker (so basically everywhere)](#deploying-using-docker)
5. [(for speedrunners) share the model with the iOS client to display content](#share-your-model-with-other-clients-ios-example)
6. [(for really serious guys) build the web page displaying that content and helping creating a new one.](#build-a-web-page-to-manage-it)

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

## Build a simple CRUD service

## Share your model with your app

## Unit testing your vapor server

## Testing on linux using docker

## Deploying using docker
