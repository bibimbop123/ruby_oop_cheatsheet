# Beginner-Friendly Ruby OOP Master Cheat Sheet
**Style:** Conversational, mentor-style guidance. Focused on helping beginners truly understand OOP concepts in Ruby. Includes mini challenges.

---

## Table of Contents
1. Thinking in Objects
2. Encapsulation
3. Inheritance
4. Polymorphism & Duck Typing
5. Abstraction
6. Composition & Modules
7. Design Thinking & Mini Projects

---

# 1. Thinking in Objects
**Concept:** Everything in Ruby is an object. Each object has **state** (data) and **behavior** (methods).

**Analogy:** A Dog has a `name` and can `bark`. You don't need to know *how* it barks to enjoy its sound.

### Example 1: Basic class and object
```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def bark
    puts "#{@name} says woof!"
  end
end

buddy = Dog.new("Buddy")
buddy.bark  # => Buddy says woof!
```

### Example 2: Multiple objects interacting
```ruby
class Ball
  def roll
    "The ball rolls away!"
  end
end

class Dog
  def play(ball)
    puts "Dog plays with the ball: #{ball.roll}"
  end
end

dog = Dog.new
ball = Ball.new
dog.play(ball)
```

**Mini Challenge:**  
> Create a `Cat` class that can `meow` and chase a `Mouse` object. Make sure your cat interacts with the mouse object properly.

---

# 2. Encapsulation — Protecting Your Data
**Concept:** Hide the internal state of objects and expose a controlled interface. This prevents misuse or accidental changes.

**Analogy:** You can use a vending machine, but you can’t reach inside and move the gears. You interact with buttons, which is the **public API**.

### Example 1: Private methods
```ruby
class BankAccount
  def initialize(balance)
    @balance = balance
  end

  def withdraw(amount)
    validate(amount)
    @balance -= amount
    puts "Withdrawn: #{amount}, Balance: #{@balance}"
  end

  private

  def validate(amount)
    raise "Insufficient funds" if amount > @balance
  end
end

account = BankAccount.new(100)
account.withdraw(30)  # Works
# account.validate(30) # ❌ Error: private method
```

### Example 2: Using attr_reader
```ruby
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

p = Person.new("Ada")
puts p.name  # Works
# p.name = "Eve" # ❌ Error: no writer method
```

**Mini Challenge:**  
> Make a `VendingMachine` class where the user can `buy(item)` but cannot directly change the `inventory`. Use private methods to enforce it.

---

# 3. Inheritance — Reusing & Extending Behavior
**Concept:** Use inheritance to share behavior between classes (`<` symbol). Use `super` to call parent methods.

**Analogy:** A Dog is an Animal. It inherits general behavior but can add its own.

### Example 1: Basic inheritance
```ruby
class Animal
  def speak
    "Some sound"
  end
end

class Dog < Animal
  def speak
    "Woof!"
  end
end

puts Dog.new.speak  # => Woof!
```

### Example 2: Using `super`
```ruby
class Person
  def greet
    "Hello"
  end
end

class EnthusiasticPerson < Person
  def greet
    super + ", nice to meet you!!!"
  end
end

puts EnthusiasticPerson.new.greet
```

**Mini Challenge:**  
> Create a `Vehicle` superclass with `move` method. Create `Car` and `Bicycle` subclasses. Add unique behavior to each and optionally call `super`.

---

# 4. Polymorphism & Duck Typing — Many Forms, One Message
**Concept:** Different objects respond to the same method. Focus on **behavior**, not type.

**Analogy:** Everyone answers the phone differently, but you can always `call` them.

### Example 1: Polymorphic shapes
```ruby
class Circle
  def area; 3.14 * 2 * 2; end
end

class Square
  def area; 2 * 2; end
end

[Circle.new, Square.new].each do |shape|
  puts "Area: #{shape.area}"
end
```

### Example 2: Duck Typing
```ruby
def make_it_speak(animal)
  puts animal.speak if animal.respond_to?(:speak)
end

class Cat
  def speak; "Meow"; end
end

make_it_speak(Cat.new)   # Meow
```

**Mini Challenge:**  
> Add a `Parrot` class with a `speak` method. Make it work with `make_it_speak` without changing the method.

---

# 5. Abstraction — Focusing on What, Not How
**Concept:** Provide a simple interface while hiding internal details.

**Analogy:** You drive a car without needing to understand the engine.

### Example 1: Payment Processor
```ruby
class PaymentProcessor
  def process(amount)
    raise NotImplementedError, "Implement in subclass"
  end
end

class StripePayment < PaymentProcessor
  def process(amount)
    puts "Processing $#{amount} with Stripe"
  end
end

StripePayment.new.process(50)
```

**Mini Challenge:**  
> Create `PayPalPayment` subclass. Then make a method that can process any payment processor object interchangeably.

---

# 6. Composition & Modules — Building with Lego Blocks
**Concept:** Include behavior from modules instead of inheriting everything.

**Analogy:** A Bird can Fly and Walk — but these are separate abilities.

### Example 1: Modules
```ruby
module Flyable
  def fly; puts "I'm flying!"; end
end

module Walkable
  def walk; puts "I'm walking!"; end
end

class Bird
  include Flyable
  include Walkable
end

Bird.new.fly
Bird.new.walk
```

**Mini Challenge:**  
> Make an `Animal` that can both `climb` and `swim` by including separate modules.

---

# 7. Design Thinking & Mini Projects
**Concept:** Plan relationships first. Think of classes as characters in a story.

**Mini Project Idea:** Build a **Library System**
- Classes: `Library`, `Book`, `Member`
- Relationships: Members borrow books, Library tracks inventory
- Encourage: Use encapsulation, inheritance if needed, and polymorphic behavior

**Mini Challenge:**  
> Build a mini RPG character system. Include `Player`, `Monster`, and `Weapon`. Use OOP principles learned so far.

---

## ✅ Final Notes
- Run every example in IRB or Ruby files.  
- Reflect after each mini challenge: *What object owns the behavior? Who should access what?*  
- OOP is about **thinking in terms of objects and interactions**, not just memorizing syntax.

---

**Mentor Tip:**  
> Always ask: "Does this class have a single responsibility?"  
> "Am I exposing only what other objects need to know?"  
> Thinking this way will save beginners from the most common pitfalls.

---

**Generated by:** ChatGPT — Beginner-Friendly Ruby OOP Master Cheat Sheet
