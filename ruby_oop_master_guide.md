# 📚 Complete Ruby OOP Master Guide: Detailed Examples

This guide provides an in-depth explanation of the core Object-Oriented Programming (OOP) concepts in Ruby, complete with detailed, project-based examples for better understanding.

---

## 1. Encapsulation: Data Protection and Control

Encapsulation Analogy:
Think of a vending machine. You interact with it through buttons and a coin slot — that’s the public interface. Inside, the machine contains complex circuits and inventory data — that’s the private state and logic. You can’t reach in and directly alter what’s inside; you must go through its defined interface.

Concept:
Encapsulation in programming means binding data and methods together and restricting direct access to an object’s internal state. It enforces control over how data is modified, increases maintainability, and lets you change internal logic without breaking external code.

```ruby

class BankAccount
  attr_reader :balance # Public getter


  def initialize(owner, balance)
    @owner = owner
    @balance = balance
  end


  # ✅ Public method: can be called from anywhere
  def deposit(amount)
    @balance += amount
    puts "💰 Deposited $#{amount}. New balance: $#{@balance}"
  end


  # ✅ Public method: can be called from anywhere
  def withdraw(amount)
    if sufficient_funds?(amount) # Calls private method
      @balance -= amount
      puts "💵 Withdrew $#{amount}. New balance: $#{@balance}"
    else
      puts "❌ Insufficient funds."
    end
  end


  # 🔒 Private method: can only be called within this instance
  private
  def sufficient_funds?(amount)
    @balance >= amount
  end


  # 🛡️ Protected method: can be called by this instance or other instances of the same class
  protected
  def owner
    @owner
  end


  # Public method using protected method internally
  public
  def transfer(amount, other_account)
    if sufficient_funds?(amount)
      @balance -= amount
      other_account.receive_transfer(amount, self)
      puts "🔄 Transferred $#{amount} to #{other_account.owner_name}"
    else
      puts "❌ Transfer failed: insufficient funds."
    end
  end


  # Protected helper: can only be called by other instances of same class
  protected
  def receive_transfer(amount, from_account)
    @balance += amount
    puts "📥 Received $#{amount} from #{from_account.owner}"
  end


  # Public method to reveal owner for external use safely
  public
  def owner_name
    owner # Calls protected method internally
  end
end


# Usage
account1 = BankAccount.new("Alice", 1000)
account2 = BankAccount.new("Bob", 500)


account1.deposit(200) # ✅ Public method
account1.withdraw(150) # ✅ Public method
account1.transfer(300, account2) # ✅ Uses public and protected internally


# account1.sufficient_funds?(50) # ❌ Error, private method
# account1.owner # ❌ Error, protected method
```

---

## 2. Inheritance: The "IS-A" Relationship

**🧠 Analogy:** Inheritance is like a family tree. A Dog (subclass) is a type of Animal (superclass), so it automatically gets all the common traits of an animal.

**Concept:** Inheritance allows specialized classes (subclasses) to inherit common methods and attributes from a base class (superclass), promoting code reuse and establishing a hierarchical "IS-A" relationship.

### Mini Project 4: Bank Account System (Overriding with `super`)

```ruby
class BankAccount
  attr_reader :balance
  
  def initialize(initial_balance)
    @balance = initial_balance
  end
  
  def withdraw(amount)
    if amount <= @balance
      @balance -= amount
      puts "💵 Withdrew $#{amount}. New balance: $#{@balance}"
      true
    else
      puts "❌ Insufficient funds in BankAccount."
      false
    end
  end
end

class SavingsAccount < BankAccount
  MIN_BALANCE = 100
  
  def withdraw(amount)
    if @balance - amount < MIN_BALANCE
      puts "❌ Must maintain minimum balance of $#{MIN_BALANCE} in SavingsAccount."
      return false
    end
    super(amount)
  end
end

regular = BankAccount.new(200)
savings = SavingsAccount.new(200)

regular.withdraw(150)
savings.withdraw(50)
savings.withdraw(51)
```

---

## 3. Abstraction: Hiding Complexity

Analogy: Abstraction is like ordering food from a restaurant. You just pick “Burger” from the menu—you don’t need to see how the chef prepares the ingredients, cooks, and plates it.

Concept tie-in: The menu is the interface; the kitchen is the implementation.

Analogy: Abstraction is like using a weather API. You call getWeather("Chicago"), and it returns the data—you don’t need to know how it fetches satellite data, parses it, or formats the response.

Concept tie-in: APIs expose simple functions that hide deep internal logic.

### Section 5: Payment Processor Abstraction

```ruby
class PaymentProcessor
  def initialize(amount)
    @amount = amount
  end
  
  def process
    validate
    connect
    charge
    log_transaction
    send_receipt
    puts "--- Transaction Complete ---"
  end
  
  def validate
    puts "✅ Validating transaction for $#{@amount}..."
  end
  
  def log_transaction
    puts "📝 Logging transaction..."
  end
  
  def send_receipt
    puts "📧 Sending receipt."
  end
  
  def connect
    raise NotImplementedError, "Subclass must implement the 'connect' method."
  end
  
  def charge
    raise NotImplementedError, "Subclass must implement the 'charge' method."
  end
end

class CreditCardProcessor < PaymentProcessor
  def connect
    puts "🔗 Connecting securely to credit card gateway..."
  end
  
  def charge
    puts "💳 Processing credit card charge of $#{@amount}"
  end
end

cc = CreditCardProcessor.new(99.99)
cc.process
```

---

## 4. Polymorphism: Different Responses to the Same Message


Analogy: Plugging a charger into different devices—like a phone, laptop, or headphones—all trigger charging, but the voltage, current, and battery chemistry differ.

Concept tie-in: Each device defines its own version of the same action.

Analogy: Pressing “Start” on a car, motorcycle, or electric scooter all starts the vehicle—but how it starts differs.

    The car ignites fuel.

    The motorcycle revs up.

    The electric scooter powers a motor.

Concept tie-in: Same method name (start()), different underlying implementations.

### Universal `make_it_speak` System

```ruby
class Person
  def initialize(name); @name = name; end
  def speak(message)
    puts "🗣️ #{@name} says: #{message}"
  end
end

class Robot
  def initialize(id); @id = id; end
  def speak(message)
    puts "🤖 Robot-#{@id}: #{message.upcase.gsub(' ', '-') }"
  end
end

class Parrot
  def speak(message)
    puts "🦜 Squawk! #{message}! Squawk!"
  end
end

def make_everyone_speak(speakers, message)
  speakers.each do |speaker|
    speaker.speak(message) if speaker.respond_to?(:speak)
  end
end

entities = [
  Person.new("Alice"),
  Robot.new(7),
  Parrot.new
]

make_everyone_speak(entities, "The mission is a success")
```

---

## 5. Composition & Modules

🧩 Modules
Analogy:

Modules are like toolboxes — they hold tools (methods, constants) that can be used in many different places.
You don’t “build” the house with the toolbox; you bring it along wherever you need those tools.

Concept:

A module is a collection of reusable code that isn’t meant to stand alone like a class. You use it to organize and share behavior across multiple classes.
```
module Drivable
  def drive
    "Vroom!"
  end
end

class Car
  include Drivable
end
```
Now every Car can drive, because it “brought along” the tools from Drivable.


🧬 Mixins
Analogy:

Mixins are like adding traits to a character in a video game.
Your base character might be “Human,” but you can mix in traits like:

Flyable (now they can fly)

Swimmable (now they can swim)

Each mixin adds new powers or behaviors.

Concept:

A mixin is what happens when you include or extend a module in a class.
It’s how Ruby achieves multiple inheritance (getting behavior from more than one source) — something most languages restrict.
```module Flyable
  def fly
    "Flying high!"
  end
end

class Bird
  include Flyable
end```

Now Bird gains the fly ability without needing to inherit from another class.


⚙️ Composition
Analogy:

Composition is like building a robot out of interchangeable parts — a camera module, a motor, an AI chip.
You don’t make one huge “Robot” blueprint that knows everything.
You compose smaller, specialized components together to create complex behavior.

Concept:

Composition means creating complex objects by combining smaller, focused objects instead of relying solely on inheritance.
It’s the idea of “has-a” rather than “is-a.”
```
class Engine
  def start
    "Engine on!"
  end
end

class Car
  def initialize
    @engine = Engine.new
  end

  def drive
    @engine.start + " Driving!"
  end
end
```
Car has an engine — not is a type of engine.
---
## Key Takeaways

1. **Objects bundle data and behavior** - they model real-world entities
2. **Encapsulation protects data** - control access, validate changes
3. **Inheritance shares behavior** - but only for true IS-A relationships
4. **Polymorphism enables flexibility** - same interface, different implementations
5. **Abstraction hides complexity** - simple public interface, complex private implementation
6. **Composition is powerful** - mix behaviors with modules instead of deep inheritance trees

**Remember:** OOP is about organizing code around objects that represent things in your problem domain. Think about responsibilities, relationships, and interfaces before you code.

✅ **This guide is a complete, beginner-friendly masterclass in Ruby OOP, covering Encapsulation, Inheritance, Abstraction, Polymorphism, Composition, and Modules with real-world mini projects.**

