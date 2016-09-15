title: javascript-class-instance
date: 2016-09-02 21:33:32
category:
tags:
---

```javascript
// original classes
function Animal(name, numLegs) {
    this.name = name;
    this.numLegs = numLegs;
    this.isAlive = true;
}
function Penguin(name) {
    this.name = name;
    this.numLegs = 2;
}
function Emperor(name) {
    this.name = name;
    this.saying = "Waddle waddle";
}

// set up the prototype chain
Penguin.prototype = new Animal();
Emperor.prototype = new Penguin();

var myEmperor = new Emperor("Jules");

console.log( myEmperor.saying ); // should print "Waddle waddle"
console.log( myEmperor.numLegs ); // should print 2
console.log( myEmperor.isAlive ); // should print true
```

Remember how the prototype chain works: if a property is not defined for a class, this class's prototype chain will be traversed upwards until one is found (or not) in a parent (higher) class.

function Person(first,last,age) {
   this.firstname = first;
   this.lastname = last;
   this.age = age;
   var bankBalance = 7500;
}
The Person class has been modified to have a private variable called bankBalance. Notice that it looks just like a normal variable, but it is defined inside the constructor for Person without using this, but instead using var. This makes bankBalance a private variable.

Although we cannot directly access private variables from outside the class, there is a way to get around this. We can define a public method that returns the value of a private variable.

Methods can also be private within a class and inaccessible outside of the class. Changing this.returnBalance from the last exercise to var returnBalance makes this method private. If you run the program trying to access the method you get an undefined error this time.

function Person(first,last,age) {
   this.firstname = first;
   this.lastname = last;
   this.age = age;
   var bankBalance = 7500;
  
   var returnBalance = function() {
      return bankBalance;
   };
       
   // create the new function here
   this.askTeller = function() {
       return returnBalance;
   }
}

var john = new Person('John','Smith',30);
console.log(john.returnBalance);
var myBalanceMethod = john.askTeller();
var myBalance = myBalanceMethod();
console.log(myBalance);


Create a method called askTeller within the Person class that returns the returnBalance method. This means that it returns the method itself and NOT the result of calling that method. So you should NOT have parentheses after returnBalance.

Because askTeller returns a method, we need to call it to make it any use. This is what var myBalance = myBalanceMethod(); does.