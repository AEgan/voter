require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # relationships
  should have_many(:contests)
  should have_many(:competitors).through(:contests)
  
	# matchers 

  # tests for role
  should allow_value("admin").for(:role)
  should allow_value("member").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)
  
  # tests for email
  should validate_uniqueness_of(:email).case_insensitive
  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)

  should allow_value("Alex").for(:first_name)
  should_not allow_value("").for(:first_name)
  should_not allow_value(nil).for(:first_name)

  should allow_value("Egan").for(:last_name)
  should_not allow_value("").for(:first_name)
  should_not allow_value(nil).for(:last_name)

  # testing users with context
  context "creating context for users" do
  	# setting up context, all users have 4 char first names so it looks nicer. 
  	setup do
  		@alex = FactoryGirl.create(:user)
  		@ryan = FactoryGirl.create(:user, :first_name => "Ryan", :email => "ryan@example.com", :role => "member")
  		@matt = FactoryGirl.create(:user, :first_name => "Matt", :last_name => "Smith", :email => "matt@example.com")
  		@mike = FactoryGirl.create(:user, :first_name => "Mike", :last_name => "Seeya", :role => "member", :email => "mike@example.com", :active => false)
  		@paul = FactoryGirl.create(:user, :first_name => "Paul", :last_name => "Sjostrom", :role => "member", :active => false, :email => "paul@example.com")
  	end

  	# teardown. May change to deletes if I want to put restrictions on destroys
  	teardown do
  		@alex.destroy
  		@ryan.destroy
  		@matt.destroy
  		@mike.destroy
  		@paul.destroy
  	end

  	# testing the factories so we can test the models
  	should "have working factories for the unit tests " do
  		assert_equal @alex.first_name, "Alex"
  		assert_equal @ryan.first_name, "Ryan"
  		assert_equal @matt.first_name, "Matt"
  		assert_equal @mike.first_name, "Mike"
  		assert_equal @paul.first_name, "Paul"
  	end

  	# TESTING SCOPES
  	# only testing one scope per test, so if one breaks we automatically know which one it is
  	# alphabetical
  	should "have a scope to order users by name, last then first" do
  		assert_equal [@alex, @ryan, @mike, @paul, @matt], User.alphabetical
  	end

  	# active
  	should "have a scope to return all active records" do
  		records = User.active
  		assert_equal 3, records.size
  		assert records.include?(@alex)
  		assert records.include?(@ryan)
  		assert records.include?(@matt)
  	end

  	# inactive
  	should "have a scope to return all inactive records" do
  		records = User.inactive
  		assert_equal 2, records.size
  		assert records.include?(@mike)
  		assert records.include?(@paul)
  	end

  	# admins
  	should "have a scope to return all admins" do
  		records = User.admins
  		assert_equal 2, records.size
  		assert records.include?(@alex)
  		assert records.include?(@matt)
  	end

  	# members
  	should "have a scope to return all members" do
  		records = User.members
  		assert_equal 3, records.size
  		assert records.include?(@ryan)
  		assert records.include?(@mike)
  		assert records.include?(@paul)
  	end

  	# no password = no user
  	should "not create a user without a password" do
  		bad = FactoryGirl.build(:user, :email => "notalex@example.com", :password => "", :password_confirmation => "")
  		deny bad.valid?
  	end

  	# password doesn't match confirmation = no user
  	should "not create a user if the password and password confirmation do not match" do
  		bad = FactoryGirl.build(:user, :email => "notalex@example.com", :password => "secret", :password_confirmation => "notsecret")
  		deny bad.valid?
  	end

  	# emails not unique, not case sensitive = no user
  	should "not allow repeat emails" do
  		bad1 = FactoryGirl.build(:user)
  		bad2 = FactoryGirl.build(:user, :email => "RYAN@EXAMPLE.COM")
  		deny bad1.valid?
  		deny bad2.valid?
  	end

    # METHODS
    # admin method
  	should "have a method to test if a user is an admin" do
  		assert @alex.admin?
  		deny @ryan.admin?
  	end

    # member method
  	should "have a method to see if a user is a member" do
  		assert @ryan.member?
  		deny @alex.member?
  	end

    # authenticate method
  	should "have working authenticate method" do
      deny User.authenticate('alex@example.com', 'notsecret')
      assert User.authenticate('ryan@example.com', 'secret')
    end

    # name
    should "have a method to return a name is last, first format" do
      assert_equal "Egan, Alex", @alex.name
      assert_equal "Egan, Ryan", @ryan.name
    end 

    # proper name
    should "have a method to return a name of a user in first last format" do
      assert_equal "Alex Egan", @alex.proper_name
      assert_equal "Ryan Egan", @ryan.proper_name
    end

  end
end
