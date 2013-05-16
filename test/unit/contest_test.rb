require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # relationships
  should belong_to(:user)
  should have_many(:competitors)

  # validations
  should validate_numericality_of(:user_id)
  should validate_presence_of(:name)

  # shouldas

  # active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)

  # shouldas for name
  should allow_value("Doc").for(:name)
  should allow_value("123").for(:name)
  should_not allow_value(nil).for(:name)

  context "creating context for contests" do

  	# setup
  	setup do
  		@userA = FactoryGirl.create(:user)
  		@userB = FactoryGirl.create(:user, :first_name => "Ryan", :email => "ryan@example.com")
  		@inactiveUser = FactoryGirl.create(:user, :first_name => "Not", :last_name => "Active", :email => "notactive@example.com", :active => false)
  		@contest1 = FactoryGirl.create(:contest, :user => @userA)
  		@contest2 = FactoryGirl.create(:contest, :user => @userA, :name => "Z Test Contest")
  		@contest3 = FactoryGirl.create(:contest, :user => @userB, :name => "C Test Contest", :active => false)
  	end

  	# teardown
  	teardown do
  		@userA.destroy
  		@userB.destroy
  		@inactiveUser.destroy
  		@contest1.destroy
  		@contest2.destroy
  		@contest3.destroy
  	end

  	# tests that the factories are working properly
  	should "have working factories for the tests" do
  		assert_equal "Alex", @userA.first_name
  		assert_equal "Ryan", @userB.first_name
  		assert_equal "Active", @inactiveUser.last_name
  		assert_equal "A Test Contest", @contest1.name
  		assert_equal "Z Test Contest", @contest2.name
  		assert_equal "C Test Contest", @contest3.name
  	end

  	# tests that there can not be duplicate names in the system
  	should "not allow contests with the same name to be created" do
  		repeatA = FactoryGirl.build(:contest, :user => @userA)
  		repeatB = FactoryGirl.build(:contest, :user => @userB, :name => "Z Test Contest")
  		repeatC = FactoryGirl.build(:contest, :user => @userA, :name => "z tEsT CoNTesT")
  		deny repeatA.valid?
  		deny repeatB.valid?
  		deny repeatC.valid?
  	end

    # tests that there is a scope to return only one random contest
    should "have a scope to return a random contest" do
      assert_equal Contest.random.size, 1
    end

  	# tests the for_user scope
  	should "have a scope to return all records that are associated with a passed in user" do
  		recordsA = Contest.for_user(@userA.id)
  		recordsB = Contest.for_user(@userB.id)
  		assert_equal 2, recordsA.size
  		assert_equal 1, recordsB.size
  		assert_equal [@contest3], recordsB
  		assert recordsA.include?(@contest1)
  		assert recordsA.include?(@contest2)
  	end

  	# alphabetical scope
  	should "have a scope to return records in alphabetical order" do
  		assert_equal [@contest1, @contest3, @contest2], Contest.alphabetical
  	end

  	# active scope
  	should "have a scope to return active records" do
  		records = Contest.active
  		assert_equal 2, records.size
  		assert records.include?(@contest1)
  		assert records.include?(@contest2)
  	end

  	# inactive scope
  	should "have a test to return only inactive records" do
  		assert_equal [@contest3], Contest.inactive
  	end 

  	# tests that a contest isn't valid if it belongs to an inactive user
  	should "not allow a contest to be created if it is associated with an inactive user" do
  		badRecord = FactoryGirl.build(:contest, :user => @inactiveUser, :name => "Unique Name")
  		deny badRecord.valid?
  	end

  end
end
