# 📚 Complete Ruby OOP Master Guide: Detailed Examples

This guide provides an in-depth explanation of the core Object-Oriented Programming (OOP) concepts in Ruby, complete with detailed, project-based examples for better understanding.

---

## 1. Encapsulation: Data Protection and Control

**🧠 Analogy:** Encapsulation is like a **TV remote**. The buttons (public methods) are the only way to change the channel or volume. The internal circuitry (data/logic) is hidden from you and can only be changed by pressing those specific buttons.

**Concept:** Encapsulation ensures a class's internal state (its data) can only be modified through its own public methods, preventing invalid or uncontrolled changes. It binds the data and the methods that operate on that data into a single unit (the class).
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

**🧠 Analogy:** Abstraction is like using a coffee machine. You press one button ("Brew"), and the machine handles the complex steps of heating water, grinding beans, and filtering—all the complexity is hidden.

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

**🧠 Analogy:** Polymorphism is like a "Play" button. Pressing "Play" on different devices all results in media playback, but the underlying mechanism differs.

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

### 5A. Composition: The "HAS-A" Relationship

```ruby
class Printer
  def print_document(doc)
    puts "🖨️ Printing: #{doc}"
  end
end

class Scanner
  def scan_document
    puts "🔍 Scanning document..."
    "Scanned Content"
  end
end

class MultiFunctionDevice
  def initialize
    @printer = Printer.new
    @scanner = Scanner.new
  end
  
  def print_document(doc)
    @printer.print_document(doc)
  end
  
  def scan_document
    @scanner.scan_document
  end

  def copy_document
    puts "--- Initiating Copy ---"
    scanned = scan_document
    print_document(scanned)
  end
end

mfd = MultiFunctionDevice.new
mfd.copy_document
```

### 5B. Modules: The "CAN-DO" Relationship (Mixins)

```ruby
module Loggable
  def log(message)
    timestamp = Time.now.strftime("[%Y-%m-%d %H:%M:%S]")
    puts "#{timestamp} [LOG] #{self.class}: #{message}"
  end
end

class Server
  include Loggable
  def start_up
    log("Server is starting.")
  end
end

class Inventory
  include Loggable
  def add_item(item)
    log("Added item: #{item}")
  end
end

server = Server.new
inventory = Inventory.new

server.start_up
inventory.add_item("T-Shirt")
```

---

✅ **This guide is a complete, beginner-friendly masterclass in Ruby OOP, covering Encapsulation, Inheritance, Abstraction, Polymorphism, Composition, and Modules with real-world mini projects.**

