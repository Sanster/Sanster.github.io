title: angularjs
date: 2016-08-28 11:01:23
category:
tags:
---

A module contains the different components of an AngularJS app
A controller manages the app's data
An expression displays values on the page
A filter formats the value of an expression

Congratulations! You built an AngularJS app from scratch. What can we generalize so far?

A user visits the AngularJS app.
The view presents the app's data through the use of expressions, filters, and directives. Directives bind new behavior HTML elements.
A user clicks an element in the view. If the element has a directive, AngularJS runs the function.
The function in the controller updates the state of the data.
The view automatically changes and displays the updated data. The page doesn't need to reload at any point.

Why is creating your own directives useful?

Readability. Directives let you write expressive HTML. Looking at index.html you can understand the app's behavior just by reading the HTML.
Reusability. Directives let you create self-contained units of functionality. We could easily plug in this directive into another AngularJS app and avoid writing a lot of repetitive HTML.


Why are services useful? Instead of filling the controller with code to fetch weather data from a server, it's better to move this independent logic into a service so that it can be reused by other parts of the app.

What can we generalize so far?

Directives are a way to make standalone UI components, like <app-info>
Services are a way to make standalone communication logic, like forecast which fetches weather data from a server

So far we've made AngularJS apps that display data in a single view index.html.

But what happens when the app grows and needs to display more information? Stuffing more code to a single view will quickly make things messy.

A better solution is to use multiple templates that display different pieces of data based on the URL that the user is visiting. We can do this with Angular's application routes.