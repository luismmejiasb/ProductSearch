## ProductSearch

Application that uses [Mercado Libre's API](https://developers.mercadolibre.com.ar/es_ar/items-y-busquedas)  web services to have a look at how API REST services can be consumed with VIPER architecture using the Swift programming language. The dependencies are managed with Swift Package Manger. The Application is capable to handle landscape and portrait screen positions.

![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)
![Platforms](https://img.shields.io/badge/platform-iOS14.5-blue.svg)
![Swift version](https://img.shields.io/badge/swift-5-blue.svg)


## 1. Getting started

### Prerequisites
* Swift 5
* Xcode 12+
* iOS 14+

## 2. Versioning

[SemVer](http://semver.org/) 

## 2. Implementations

### a) Viper Architecture

### Module Components

Each module consists of the following parts:

- View (View, ViewController) 
- Interactor (Business Logic, Use Cases) 
- Presenter (Prepare Business logic for presentation in the View)
- Entity (Model) 
- Wireframe (Assemble each module and Take control of Routing)
- Repository & DataSources (LocalSource and or CloudSource) get API responses and CRUD in local DB information.


### Dependency Graph

The dependence graph is unidirectional, which means:

**View** knows about **Presenter**
**Presenter** Is the heart of VIPER, it knows about **Router**, **View** and **Interactor** . It gets the user interactions from the UI, create requests to the Interactor and then retrieve back and display the information in the View and also order Router to present another module or UI component.
**Interactor** communicates with Repository (Database/REST) and retrieve to the presenter. 
**Router** knows about **View** and display new modules or UI components like UIAlertView in the Controller.

Note: Viper is like an onion. The outer layers are dependent on the closest inner layer. And the inner layers have no knowledge of the outer layers. 

### b) Unit Testing

Testing main VIPER layer:
- Presenter
- Interactor
- Repository
- Factory


### c) Delegation

Delegation is a simple and powerful pattern in which one object in a program acts on behalf of, or in coordination with, another object. Due to that is a pattern created and largely used by apple, we can see it in all the UI components that uses it, like:
- SearchResultRouterDelegate
- UITableViewDelegate
- UISearchBarDelegate

### d) Singleton

Singleton is a design pattern that ensures that only one object of its type exists and provides a single point of access to it for any other code. We can find this implementation in:
- UILoadingIndicator.startLoadingIndicatorIn(view, position: .top)

### e) Combine

Making use of the Apple's reactive framework for the Data layer

### f) Repository Pattern

Used to better separate the data layer logic and responsibilities
