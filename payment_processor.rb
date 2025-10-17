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