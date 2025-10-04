class Drink
  attr_reader :flavor, :brand

  def initialize(flavor, brand)
    @flavor = flavor 
    @brand = brand
  end

  def info
    "this is #{flavor} #{brand}"
  end
end
mountaindew = Drink.new("baja blast", "Mountain Dew")
pp mountaindew.class

pp mountaindew.info
pp mountaindew.flavor
pp mountaindew.brand