class BankAccount
  attr_reader :balance # Public getter

  def initialize(owner, balance)
    @owner = owner
    @balance = balance
  end

  def statement()
    "balance #{self.balance}"
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

  # Public method to reveal owner for external use safely
  public
  def owner_name
    owner # Calls protected method internally
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

  # Protected helper: can only be called by other instances of same class
  def receive_transfer(amount, from_account)
    @balance += amount
    puts "📥 Received $#{amount} from #{from_account.owner}"
  end


end

# account1 = BankAccount.new("Alice", 1000)
# account2 = BankAccount.new("Bob", 500)


# account1.deposit(200) #  Public method
# # account1.withdraw(150) #  Public method
# # account1.transfer(300, account2) #  Uses public and protected internally