class Drink
  attr_accessor :flavor, :brand

  def initialize(flavor, brand)
    @flavor = flavor 
    @brand = brand
  end

  def info
    "this is a fancy drink"
  end

  def self.description
    "this is a fancier drink"
  end

  def self.cocacola
    Drink.new("diet", "coca cola")
  end
  
end

class ArizonaTea < Drink
  def initialize(flavor)
    super(flavor, "Arizona")
  end

  def info
    super + " (#{@flavor}) made cheap by #{@brand}"
  end
end