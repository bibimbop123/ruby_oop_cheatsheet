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