# Ruby OOP Essentials - Focused Learning Guide

> **Philosophy:** Learn through carefully chosen examples that build understanding, not through volume.

---

## Table of Contents
1. [Objects & Classes](#1-objects--classes)
2. [Encapsulation](#2-encapsulation)
3. [Inheritance](#3-inheritance)
4. [Polymorphism](#4-polymorphism)
5. [Abstraction](#5-abstraction)
6. [Composition](#6-composition)
7. [Putting It Together](#7-putting-it-together)

---

# 1. Objects & Classes

**Core Idea:** Objects bundle data (state) and behavior (methods) together.

### The Basics

```ruby
class Dog
  def initialize(name, breed)
    @name = name      # @ = instance variable (this dog's data)
    @breed = breed
  end
  
  def bark
    puts "#{@name} says woof!"
  end
  
  def info
    "#{@name} is a #{@breed}"
  end
end

buddy = Dog.new("Buddy", "Golden Retriever")
buddy.bark  # Buddy says woof!
puts buddy.info  # Buddy is a Golden Retriever
```

**Key:** Each object has its own `@name` and `@breed` - they don't share data.

### Accessing Instance Variables

```ruby
class Car
  # attr_reader: read only
  # attr_writer: write only  
  # attr_accessor: read and write
  attr_accessor :make, :model
  attr_reader :year
  
  def initialize(make, model, year)
    @make = make
    @model = model
    @year = year
  end
end

car = Car.new("Toyota", "Camry", 2020)
puts car.make       # ✅ Toyota
car.make = "Honda"  # ✅ Can change
car.year = 2021     # ❌ Error - read only
```

### Class Methods vs Instance Methods

```ruby
class Calculator
  # Class method - no object needed
  def self.add(a, b)
    a + b
  end
  
  # Instance method - needs an object
  def initialize(start_value)
    @value = start_value
  end
  
  def add(n)
    @value += n
  end
end

# Class method - called on the class
puts Calculator.add(5, 3)  # 8

# Instance method - called on an object
calc = Calculator.new(10)
calc.add(5)
puts calc.value  # Would need attr_reader :value
```

**When to use which:**
- Class methods: Utilities that don't need object state (like `Math.sqrt`)
- Instance methods: Actions on specific object data

---

# 2. Encapsulation

**Core Idea:** Hide internal details, expose only what's necessary. Protect data from invalid changes.

### Why It Matters

```ruby
# ❌ BAD: Direct access allows invalid state
class BankAccount
  attr_accessor :balance
  
  def initialize(balance)
    @balance = balance
  end
end

account = BankAccount.new(100)
account.balance = -500  # Nothing stops this!

# ✅ GOOD: Controlled access prevents invalid state
class BankAccount
  attr_reader :balance  # Can read, but not directly write
  
  def initialize(balance)
    @balance = balance
  end
  
  def withdraw(amount)
    return "Insufficient funds" if amount > @balance
    return "Invalid amount" if amount <= 0
    
    @balance -= amount
    "Withdrew $#{amount}. Balance: $#{@balance}"
  end
  
  def deposit(amount)
    return "Invalid amount" if amount <= 0
    
    @balance += amount
    "Deposited $#{amount}. Balance: $#{@balance}"
  end
end

account = BankAccount.new(100)
puts account.withdraw(150)  # Insufficient funds
puts account.deposit(50)    # Deposited $50. Balance: $150
```

### Private Methods

```ruby
class User
  def initialize(email, password)
    @email = email
    @password_hash = encrypt(password)  # ✅ Can call private method internally
  end
  
  def login(password)
    encrypt(password) == @password_hash
  end
  
  private  # Everything below is private
  
  def encrypt(password)
    # Simplified encryption
    password.reverse.upcase
  end
end

user = User.new("alice@example.com", "secret123")
puts user.login("secret123")  # true
# user.encrypt("test")  # ❌ Error - private method
```

**Key:** `private` methods are internal helpers. They can't be called from outside the class.

### Custom Getters/Setters for Validation

```ruby
class Temperature
  def initialize(celsius)
    self.celsius = celsius  # Use setter for validation
  end
  
  def celsius
    @celsius
  end
  
  def celsius=(value)
    raise "Can't be below absolute zero!" if value < -273.15
    @celsius = value
  end
  
  def fahrenheit
    (@celsius * 9.0 / 5.0) + 32
  end
end

temp = Temperature.new(25)
puts temp.fahrenheit  # 77.0
temp.celsius = 100    # ✅ OK
# temp.celsius = -300  # ❌ Raises error
```

---

# 3. Inheritance

**Core Idea:** Share common behavior across related classes. Models "IS-A" relationships.

### Basic Inheritance

```ruby
class Animal
  def initialize(name)
    @name = name
  end
  
  def sleep
    "#{@name} is sleeping"
  end
end

class Dog < Animal  # Dog IS-A Animal
  def bark
    "#{@name} says woof!"
  end
end

class Cat < Animal  # Cat IS-A Animal
  def meow
    "#{@name} says meow!"
  end
end

dog = Dog.new("Buddy")
puts dog.sleep  # Buddy is sleeping (inherited)
puts dog.bark   # Buddy says woof! (Dog's own)
```

### Method Override & Super

```ruby
class Employee
  def initialize(name, id)
    @name = name
    @id = id
  end
  
  def work
    "#{@name} is working"
  end
end

class Manager < Employee
  def initialize(name, id, department)
    super(name, id)  # Call parent's initialize
    @department = department
  end
  
  def work
    super + " in the #{@department} department"  # Extend parent's method
  end
  
  def hold_meeting
    "#{@name} is holding a meeting"
  end
end

manager = Manager.new("Alice", 101, "Engineering")
puts manager.work  # Alice is working in the Engineering department
```

**Key:** `super` calls the parent class's version of the method.

### When NOT to Use Inheritance

```ruby
# ❌ BAD: Robot isn't really an Animal
class Robot < Animal
  def eat
    raise "Robots don't eat!"  # Violates parent's contract
  end
end

# ✅ GOOD: Use inheritance only for true IS-A relationships
# Use composition (modules) for CAN-DO relationships (see section 6)
```

**Rule of thumb:** If you find yourself overriding methods with errors or empty implementations, inheritance is wrong. Use composition instead.

---

# 4. Polymorphism

**Core Idea:** Same interface, different implementations. "If it quacks like a duck, treat it as a duck."

### The Power of Polymorphism

```ruby
class Dog
  def speak
    "Woof!"
  end
end

class Cat
  def speak
    "Meow!"
  end
end

class Duck
  def speak
    "Quack!"
  end
end

# One method works with all types
def make_it_speak(animal)
  puts animal.speak
end

animals = [Dog.new, Cat.new, Duck.new]
animals.each { |animal| make_it_speak(animal) }
# Woof!
# Meow!
# Quack!
```

**Key:** We don't check types. If an object has `speak`, it works.

### Real-World Example: Payment Processing

```ruby
class StripePayment
  def process(amount)
    puts "Processing $#{amount} via Stripe..."
    { success: true, id: "stripe_#{rand(1000)}" }
  end
end

class PayPalPayment
  def process(amount)
    puts "Processing $#{amount} via PayPal..."
    { success: true, id: "paypal_#{rand(1000)}" }
  end
end

class BitcoinPayment
  def process(amount)
    puts "Processing $#{amount} via Bitcoin..."
    { success: true, id: "btc_#{rand(1000)}" }
  end
end

class Checkout
  def complete_purchase(payment_method, amount)
    result = payment_method.process(amount)
    puts "Order confirmed! Transaction: #{result[:id]}" if result[:success]
  end
end

# Same checkout code works with ANY payment method
checkout = Checkout.new
checkout.complete_purchase(StripePayment.new, 99.99)
checkout.complete_purchase(PayPalPayment.new, 49.99)
checkout.complete_purchase(BitcoinPayment.new, 199.99)
```

**Key Benefit:** Add new payment methods without changing `Checkout` class.

### Duck Typing with respond_to?

```ruby
def make_it_fly(thing)
  if thing.respond_to?(:fly)
    puts thing.fly
  else
    puts "This can't fly!"
  end
end

class Bird
  def fly
    "Flying with wings!"
  end
end

class Plane
  def fly
    "Flying with engines!"
  end
end

make_it_fly(Bird.new)   # Flying with wings!
make_it_fly(Plane.new)  # Flying with engines!
make_it_fly("String")   # This can't fly!
```

---

# 5. Abstraction

**Core Idea:** Hide complexity behind simple interfaces. Show "what", hide "how".

### Abstract Base Classes

```ruby
class PaymentGateway
  def process_payment(amount)
    validate(amount)
    connect      # Subclass implements
    charge(amount)  # Subclass implements
    send_receipt
  end
  
  def connect
    raise NotImplementedError, "Subclass must implement 'connect'"
  end
  
  def charge(amount)
    raise NotImplementedError, "Subclass must implement 'charge'"
  end
  
  private
  
  def validate(amount)
    raise "Invalid amount" if amount <= 0
    puts "Amount validated"
  end
  
  def send_receipt
    puts "Receipt sent"
  end
end

class StripeGateway < PaymentGateway
  def connect
    puts "Connecting to Stripe..."
  end
  
  def charge(amount)
    puts "Charging $#{amount} via Stripe"
  end
end

class PayPalGateway < PaymentGateway
  def connect
    puts "Connecting to PayPal..."
  end
  
  def charge(amount)
    puts "Charging $#{amount} via PayPal"
  end
end

# User sees simple interface, complexity hidden
stripe = StripeGateway.new
stripe.process_payment(99.99)
```

**Key:** Parent defines workflow, children implement specific steps.

### Hiding Complexity

```ruby
class EmailService
  # Simple public interface
  def send_welcome_email(user)
    send_email(user.email, "Welcome!", generate_welcome_body(user))
  end
  
  def send_password_reset(user, token)
    send_email(user.email, "Password Reset", generate_reset_body(user, token))
  end
  
  private
  
  # Complex implementation hidden
  def send_email(to, subject, body)
    # SMTP connection, authentication, headers, error handling...
    puts "Sending email to #{to}: #{subject}"
  end
  
  def generate_welcome_body(user)
    "Hi #{user.name}, welcome to our service!"
  end
  
  def generate_reset_body(user, token)
    "Click here to reset: https://example.com/reset?token=#{token}"
  end
end

# User doesn't need to know email internals
email_service = EmailService.new
email_service.send_welcome_email(user)
```

---

# 6. Composition

**Core Idea:** Build objects by combining smaller pieces. Models "HAS-A" and "CAN-DO" relationships.

### Modules for Shared Behavior

```ruby
module Swimmable
  def swim
    "#{@name} is swimming"
  end
end

module Flyable
  def fly
    "#{@name} is flying"
  end
end

module Walkable
  def walk
    "#{@name} is walking"
  end
end

class Duck
  include Swimmable
  include Flyable
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class Fish
  include Swimmable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class Dog
  include Swimmable
  include Walkable
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

# Mix and match capabilities!
duck = Duck.new("Donald")
puts duck.swim  # Donald is swimming
puts duck.fly   # Donald is flying

fish = Fish.new("Nemo")
puts fish.swim  # Nemo is swimming
# fish.fly  # ❌ Error - Fish can't fly
```

**Key:** Composition is more flexible than inheritance. Duck can swim/fly/walk without a complex inheritance hierarchy.

### include vs extend

```ruby
module Greetings
  def hello
    "Hello!"
  end
end

class Person
  include Greetings  # Adds as INSTANCE methods
end

class Robot
  extend Greetings   # Adds as CLASS methods
end

person = Person.new
puts person.hello  # ✅ Hello!

puts Robot.hello   # ✅ Hello!
# Robot.new.hello  # ❌ Error
```

### Composition Over Inheritance

```ruby
# Instead of deep inheritance for combinations:
# FlyingSwimmingAnimal, FlyingWalkingAnimal, etc.

# Use modules to compose behaviors:
class Animal
  attr_reader :name
  def initialize(name); @name = name; end
end

class Penguin < Animal
  include Swimmable
  include Walkable
  # No flying - perfect!
end

class Seagull < Animal
  include Flyable
  include Swimmable
  include Walkable
end

# Easy to create any combination without inheritance explosion
```

---

# 7. Putting It Together

### Design Principles

**1. Single Responsibility**
Each class should have ONE reason to change.

```ruby
# ❌ BAD: User does too much
class User
  def initialize(email, password)
    @email = email
    @password = password
  end
  
  def save_to_database
    # Database logic
  end
  
  def send_welcome_email
    # Email logic
  end
  
  def validate
    # Validation logic
  end
end

# ✅ GOOD: Separate concerns
class User
  attr_reader :email
  def initialize(email, password)
    @email = email
    @password = password
  end
end

class UserRepository
  def save(user)
    # Database logic
  end
end

class EmailService
  def send_welcome(user)
    # Email logic
  end
end
```

**2. Favor Composition Over Inheritance**
Use inheritance for IS-A, modules for CAN-DO.

**3. Depend on Abstractions**
Code should work with interfaces, not specific implementations.

```ruby
# ✅ Good - works with any object that has #process
class PaymentProcessor
  def initialize(gateway)
    @gateway = gateway
  end
  
  def process(amount)
    @gateway.process(amount)
  end
end
```

### Complete Example: Library System

```ruby
class Book
  attr_reader :isbn, :title, :author
  attr_accessor :available
  
  def initialize(isbn, title, author)
    @isbn = isbn
    @title = title
    @author = author
    @available = true
  end
end

class Member
  attr_reader :id, :name, :borrowed_books
  
  def initialize(id, name)
    @id = id
    @name = name
    @borrowed_books = []
  end
  
  def can_borrow?
    @borrowed_books.size < 3
  end
  
  def borrow(book)
    @borrowed_books << book
  end
  
  def return_book(book)
    @borrowed_books.delete(book)
  end
end

class Library
  def initialize
    @books = []
    @members = []
  end
  
  def add_book(book)
    @books << book
  end
  
  def register_member(member)
    @members << member
  end
  
  def checkout(member_id, isbn)
    member = @members.find { |m| m.id == member_id }
    book = @books.find { |b| b.isbn == isbn }
    
    return "Member not found" unless member
    return "Book not found" unless book
    return "Book unavailable" unless book.available
    return "Too many books borrowed" unless member.can_borrow?
    
    book.available = false
    member.borrow(book)
    "Checkout successful"
  end
  
  def return_book(member_id, isbn)
    member = @members.find { |m| m.id == member_id }
    book = @books.find { |b| b.isbn == isbn }
    
    return "Member not found" unless member
    return "Book not found" unless book
    
    book.available = true
    member.return_book(book)
    "Return successful"
  end
end

# Usage
library = Library.new
library.add_book(Book.new("123", "1984", "Orwell"))
library.register_member(Member.new(1, "Alice"))
puts library.checkout(1, "123")
```

---

## Quick Reference

```ruby
# Class basics
class MyClass
  attr_accessor :name  # read + write
  attr_reader :id      # read only
  attr_writer :secret  # write only
  
  def initialize(name)
    @name = name  # instance variable
  end
  
  def instance_method
    # uses @name
  end
  
  def self.class_method
    # called on class
  end
  
  private
  def helper_method
    # only callable internally
  end
end

# Inheritance
class Child < Parent
  def method
    super  # call parent's version
  end
end

# Modules
module MyModule
  def shared_method; end
end

class MyClass
  include MyModule  # instance methods
end
```

---

## Key Takeaways

1. **Objects bundle data and behavior** - they model real-world entities
2. **Encapsulation protects data** - control access, validate changes
3. **Inheritance shares behavior** - but only for true IS-A relationships
4. **Polymorphism enables flexibility** - same interface, different implementations
5. **Abstraction hides complexity** - simple public interface, complex private implementation
6. **Composition is powerful** - mix behaviors with modules instead of deep inheritance trees

**Remember:** OOP is about organizing code around objects that represent things in your problem domain. Think about responsibilities, relationships, and interfaces before you code.

---

**Next Steps:** Build small projects using these principles. Start with simple domains (library, shopping cart, task list) before tackling complex systems.