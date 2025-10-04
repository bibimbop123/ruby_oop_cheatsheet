class Drink
  attr_accessor :flavor, :size, :count

  @@count = 0
  def initialize(flavor, size)
    @flavor = flavor
    @size = size 
    @@count += 1
  end

  def self.drink 
    "refreshing #{@flavor} #{@size} drink"
  end

  def self.increment
    @@count += 1
  end

  def self.count
    @@count 
  end
end

pp Drink.drink
pp Drink.increment
pp Drink.increment
pp Drink.increment
pp Drink.count

class Arizona < Drink
  def self.drink
    "tea is for the wise"
  end
end

pp Arizona.drink