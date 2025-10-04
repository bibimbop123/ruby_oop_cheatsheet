require "date"
class User
  attr_accessor :username
  attr_accessor :email
  attr_accessor :bio
  attr_accessor :birthdate
 
  def about_me
    "#{username.downcase} #{age} #{bio} #{email}"
  end

  def age
    t=Date.today
    ivys_age=(t-birthdate).to_i/365
  return ivys_age
end
end

user=User.new
user.username="Ivy"
user.email="Ivy.Ramirez@chicagoparkdistrict.com"
user.bio="Special Rec Instructor; Sage's mom"
user.birthdate=Date.parse("19970713")
pp user.about_me
