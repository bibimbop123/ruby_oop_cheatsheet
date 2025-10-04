Ruby notes


everything in ruby is an object. 

5.class      
"hello".class  
[1, 2, 3].class 
Classes are objects but they can also be understood as the blueprints for objects, 
in which they carry instructions to build other objects.
A function or method are the instructions of the blueprint of class. these are also a type of object. 

1. What is a Class?

class Airplane
end
jet = Airplane.new
puts jet.class

- Create a class instantiate it. Print the class of your object.

For example, And models and controllers are all classes which are objects too. 
not to be mistaken with html classes which are css identifiers

An instance is a specific object created from a class (the blueprint).
Think: a class is the plan, an instance is the actual thing built from it.

🏗️ Blueprint vs Building

	Class = the blueprint of a skyscraper. It defines how to build it (floors, windows, elevators).

	Object (instance) = the actual skyscraper standing in Chicago.

You can build multiple skyscrapers from the same blueprint, but each one is a separate object.

🏭 Factory vs Product

	Class = the machine design in a car factory (tells the factory how to build a car).

	Object = the car that rolls off the assembly line.

Many cars (objects) can be produced from the same machine design (class).



2. Defining a Class

class Airplane
	def fly
		puts "flying"
	end
end
airplane = Airplane.new
puts airplane.fly

Define a class Dog with a method bark that prints "woof!". Instantiate and call it.

3. Instance Variables & initialize

class Airplane
	def initialize(size, name)
		@size = size,
		@name = name
	end
	
	def info 
		"This #{name} is #{size}"
	end
end

airplane = Airplane.new("very big", "turbojet")

airplane.info

Make a class Book with instance variables title and author. Define info to print "Title by Author".

4. Getters and Setters

class Airplane
 	attr_reader :name, :size
	attr_writer :name, :size
	attr_accessor :name :size
	
	def initialize(name, size)
		@name = name
		@size = size
	end
end

airplane = Airplane.new("turbojet", "very big")
airplane.size = "very big"
airplane.name = "turbojet"

airplane = Airplane.new("turbojet", "very big")
airplane.name = spaceship
airplane.size = "very small"

airplane = instance of Airplane("spaceship", "very small")

Make a class Player with attr_accessor :score. Start with score = 0, then change it to 100.

5. Class Methods vs Instance Methods

class Airplane
	def self.flying_method
		"helicopter"
	end
end

puts Airplane.flying_method

Make a class MathHelper with a class method .square(n) that returns n*n.

6. Class Variables & Constants

🏗️ Analogy: Blueprint vs Houses

	Instance Method = something you do to a single house.

		Example: Open the door, turn on the lights, paint a wall.

		Each house (instance) can do it independently.

	Class Method = something you do to the blueprint itself.

		Example: Check how many houses have been built from this blueprint, or update the blueprint design.

		You don’t need a real house to use it.

class Airplane
	@@count = 2
	FLYING_METHOD = "gas engine"
	
	def initialize 
		@@count +=1
	end
	
	def self.count
		@@count
	end
end

Airplane.new
Airplane.new
puts Airplane.count # => 2
puts Airplane::FLYING_METHOD  # => gas engine

Make a class User with a class variable @@users counting how many instances are created. Add .count

7. Inheritance

class Airplane
	def flying
		“vroom”
	end
End

class Turbojet < Airplane
	def super_speed
		“vroom vroom”
	end
end

Megajet = Turbojet.new
Megajet.super_speed
Megajet.flying

Make a base class Animal with speak. Make subclass Cat that adds meow.

8. OverridingAndSuper

class Airplane 
	def flying 
		"vroom"
	end
end

class Turbojet < Airplane
	def flying
		super + " Wooooosh!"
	end
end

Override speak in Cat to call super and add "meow".

puts Turbojet.new.flying

9. Modules ( Mixins )

module Hyperspeedable
	def hyper_mode
		"hype hype hype"
	end
end
class Turbojet
	include Hyperspeedable
end
Airforceone = Turbojet.new
puts Airforceone.hyper_mode


Make a module Swimmable with swim. Include it in Dog.

10. Visibility: public, private, protected

could also go into this if time allows



🔑 Private Methods

Access: Can only be called within the same class, and not even by subclasses (in most languages).

Usage: Used for internal helper methods that should never be exposed or overridden directly.

class Example
	def public_method
	  private_method  # ✅ allowed (same class)
	end
  
	private
  
	def private_method
	  puts "I'm private"
	end
  end
  
  Example.new.public_method   # works
  Example.new.private_method  # 🚫 error

🛡 Protected Methods

Access: Can be called by:

1. The class itself

2. Any subclass

3. Other objects of the same class or subclass

Usage: Good for cases where subclasses or same-class objects should share behavior, but external objects shouldn’t.

class Example
	def compare(other)
	  self.secret == other.secret  # ✅ works with another object of same class
	end
  
	protected
  
	def secret
	  42
	end
  end
  
  a = Example.new
  b = Example.new
  
  puts a.compare(b)   # ✅ works
  puts a.secret       # 🚫 error


  Practice: Make a class BankAccount with: deposit (public) balance (protected) calculate_interest (private) this

  class BankAccount
	def initialize(balance = 0)
	  @balance = balance
	end
  
	# Public method - accessible anywhere
	def deposit(amount)
	  @balance += amount
	end
  
	# Public method that shows balance indirectly
	def show_balance
	  "Current balance: $#{balance}"
	end
  
	# Protected method - only accessible within the class or subclasses
	protected
	def balance
	  @balance
	end
  
	# Private method - only accessible within this class (not even subclasses directly)
	private
	def calculate_interest(rate)
	  @balance * rate
	end
  
	# Public method that uses the private method internally
	def add_interest(rate)
	  interest = calculate_interest(rate)
	  @balance += interest
	  "Interest added: $#{interest}, New balance: $#{@balance}"
	end
  end
  
  # --- Example usage ---
  account = BankAccount.new(100)
  puts account.deposit(50)         # => 150
  puts account.show_balance        # => Current balance: $150
  
  # puts account.balance            # 🚫 Error: protected method
  # puts account.calculate_interest # 🚫 Error: private method
  
  puts account.add_interest(0.1)   # => Interest added: $15.0, New balance: $165.0