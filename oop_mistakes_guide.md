# 🚨 Common OOP Mistakes (Beginner → Expert)

This guide covers **confusing Object-Oriented Programming (OOP) mistakes** that developers make as they progress from beginner to expert — with examples, explanations, and fixes.

---

## 🧩 Beginner-Level Mistakes

### 1. Forgetting to Use `self` (or `this` in other languages)
**Mistake:**
```ruby
class Dog
  def initialize(name)
    name = name  # ❌ does nothing, local variable only
  end
end
```
**Fix:**
```ruby
class Dog
  def initialize(name)
    @name = name  # ✅ use instance variable to store object state
  end
end
```
**Why It Happens:** Beginners often think writing `name = name` stores it, but it only creates a local variable.

---

### 2. Not Understanding Instance vs Class Variables
**Mistake:**
```ruby
class Cat
  @@count = 0
  def initialize
    @@count += 1
  end
end
```
All cats share one counter — even if you want per-object counts.

**Fix:**
```ruby
class Cat
  def initialize
    @count = 0  # ✅ instance variable — unique to each cat
  end
end
```
**Tip:** Use `@@` only for values shared across *all* instances.

---

### 3. Making Everything Public
**Mistake:**
```ruby
class BankAccount
  attr_accessor :balance  # ❌ dangerous
end
```
Now anyone can change `balance` directly.

**Fix:**
```ruby
class BankAccount
  attr_reader :balance
  def deposit(amount)
    @balance += amount
  end
  private :deposit  # ✅ encapsulate sensitive methods
end
```
**Lesson:** Protect object data — expose only what needs to be public.

---

### 4. Mixing Logic with Data (No Separation of Concerns)
**Mistake:**
```ruby
class Report
  def generate
    puts "Report generated!"
  end
end
```
This class both *creates* and *displays* data.

**Fix:**
```ruby
class Report
  def generate
    "Report generated!"
  end
end

puts Report.new.generate  # ✅ presentation handled outside
```
**Rule:** Keep data logic separate from output logic.

---

### 5. Not Using Constructors Properly
**Mistake:**
```ruby
user = User.new
user.name = "Brian"  # ❌ scattered initialization
```
**Fix:**
```ruby
user = User.new("Brian")  # ✅ constructor handles setup
```
**Why It Matters:** Centralizing setup avoids half-initialized objects.

---

### 🧠 Mini Challenges
- Refactor a class that prints and calculates data into two separate classes.
- Convert a function-based script into a small class using a constructor.
- Find where you’ve used `attr_accessor` and limit what’s truly needed.

---

## ⚙️ Intermediate-Level Mistakes

### 6. Inheritance Abuse ("Everything is a subclass!")
**Mistake:**
```ruby
class Bird; end
class Penguin < Bird; end
class RobotPenguin < Penguin; end  # ❌ doesn’t fit real hierarchy
```
**Fix:** Prefer **composition**:
```ruby
class Penguin
  def initialize
    @movement = WalkBehavior.new
  end
end
```
**Guideline:** Favor *has-a* relationships over *is-a* when possible.

---

### 7. Forgetting to Call `super`
**Mistake:**
```ruby
class Parent
  def initialize
    @name = "Parent"
  end
end

class Child < Parent
  def initialize
    @age = 5
  end
end
```
Parent’s `@name` is never set.

**Fix:**
```ruby
class Child < Parent
  def initialize
    super  # ✅ calls Parent’s initialize
    @age = 5
  end
end
```
**Rule:** Always call `super` unless you intentionally override all behavior.

---

### 8. Poor Encapsulation — Exposing Too Much
**Mistake:**
```ruby
class Engine
  attr_accessor :fuel_level
end
```
**Fix:**
```ruby
class Engine
  def refuel(liters)
    @fuel_level += liters
  end
  private :refuel
end
```
**Principle:** Expose *intentions*, not *internals*.

---

### 9. Overcomplicating Small Classes
**Mistake:**
```ruby
class Logger
  def initialize; @file = File.open('log.txt', 'a'); end
  def log(msg); @file.puts(msg); end
end
```
Sometimes you don’t need a full class — a simple function or module may suffice.

**Fix:**
```ruby
def log(msg)
  File.open('log.txt', 'a') { |f| f.puts msg }
end
```
**Lesson:** Don’t create classes for everything. Use OOP where structure *adds clarity*.

---

### 10. Ignoring Polymorphism
**Mistake:**
```ruby
if shape.type == 'circle'
  draw_circle(shape)
elsif shape.type == 'square'
  draw_square(shape)
end
```
**Fix:**
```ruby
class Shape; def draw; end; end
class Circle < Shape; def draw; puts 'Drawing Circle'; end; end
class Square < Shape; def draw; puts 'Drawing Square'; end; end
```
**Why It’s Better:** Objects handle their own behavior — no `if` jungle.

---

### 🧠 Mini Challenges
- Create a polymorphic class hierarchy with three shapes and a `draw` method.
- Rewrite a class hierarchy using composition instead of inheritance.
- Implement a base class that uses `super` properly.

---

## 🧠 Advanced-Level Mistakes

### 11. Violating the Open/Closed Principle
**Mistake:**
```ruby
class PaymentProcessor
  def pay(type)
    if type == :paypal
      # paypal logic
    elsif type == :stripe
      # stripe logic
    end
  end
end
```
**Fix:**
```ruby
class Payment
  def pay; raise NotImplementedError; end
end

class Paypal < Payment
  def pay; puts 'Paying with PayPal'; end
end

class Stripe < Payment
  def pay; puts 'Paying with Stripe'; end
end
```
**Principle:** Code should be open for extension, closed for modification.

---

### 12. Tight Coupling
**Mistake:**
```ruby
class Order
  def initialize
    @email_service = EmailService.new
  end
end
```
Now `Order` can’t exist without `EmailService`.

**Fix:**
```ruby
class Order
  def initialize(email_service)
    @mailer = email_service
  end
end
```
**Lesson:** Pass dependencies, don’t hardcode them.

---

### 13. Ignoring Composition and Interfaces
**Mistake:** Trying to use inheritance where behavior differs.
**Fix:** Extract shared behaviors into modules or strategy objects.
```ruby
module Flyable
  def fly; puts 'Flying!'; end
end
```
**Tip:** Mixins and interfaces reduce code duplication.

---

### 14. God Object (Too Many Responsibilities)
**Mistake:**
```ruby
class Game
  def start; end
  def save; end
  def render; end
  def score; end
end
```
**Fix:** Split into smaller classes:
```ruby
class Renderer; end
class ScoreTracker; end
class GameEngine; end
```
**Principle:** Each class should have **one reason to change.**

---

### 15. Ignoring Design Patterns
**Mistake:** Rewriting logic others solved decades ago.
**Fix:** Learn patterns like **Strategy**, **Observer**, **Factory**, **Decorator**.
**Example:**
```ruby
class PaymentStrategy; def pay; end; end
class CreditCardPayment < PaymentStrategy; def pay; puts 'Paid by card'; end; end
```
**Lesson:** Patterns aren’t just theory — they prevent chaos in large systems.

---

### 🧠 Mini Challenges
- Implement the Strategy pattern for a sorting algorithm.
- Use dependency injection to decouple two classes.
- Refactor a large class into three smaller ones based on their roles.

---

## ✅ Takeaways

| Level | Key Lesson |
|-------|-------------|
| Beginner | Understand encapsulation and object state |
| Intermediate | Master inheritance, polymorphism, and design separation |
| Advanced | Apply SOLID principles and use composition effectively |

---

**💡 Pro Tip:** Refactor constantly. Great OOP isn’t about perfection — it’s about *progressively organizing complexity*.

