require 'test_helper'

class CompetitorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # relationships
  should belong_to(:contest)

  # Validations
  should validate_presence_of(:name)
  should validate_numericality_of(:elo)
  should validate_numericality_of(:wins)
  should validate_numericality_of(:times_played)
  should validate_numericality_of(:contest_id)

  # shouldas for numeric values
  # wins
  should allow_value(5).for(:wins)
  should allow_value(0).for(:wins)
  should_not allow_value(-1).for(:wins)
  should_not allow_value(3.14).for(:wins)
  should_not allow_value(nil).for(:wins)
  
  # times played
  should allow_value(5).for(:times_played)
  should allow_value(0).for(:times_played)
  should_not allow_value(-1).for(:times_played)
  should_not allow_value(3.14).for(:times_played)
  should_not allow_value(nil).for(:times_played)
  
  # elo
  should allow_value(5).for(:elo)
  should allow_value(0).for(:elo)
  should allow_value(3.14).for(:elo)
  should_not allow_value(-1).for(:elo)
  should_not allow_value(nil).for(:elo)

  # contest_id
  should allow_value(5).for(:contest_id)
  should allow_value(0).for(:contest_id)
  should_not allow_value(-1).for(:contest_id)
  should_not allow_value(3.14).for(:contest_id)
  should_not allow_value(nil).for(:contest_id)

  # shouldas for name
  should allow_value("Doc").for(:name)
  should allow_value("123").for(:name)
  should_not allow_value(nil).for(:name)

  context "Creating competitor context" do

  	# create competitor context
  	setup do
  		@doc = FactoryGirl.create(:competitor)
  		@kearney = FactoryGirl.create(:competitor, :wins => 3, :elo => 1300, :name => "Brian Kearney", :times_played => 1)
  		@miller = FactoryGirl.create(:competitor, :name => "Matt Miller", :wins => 4, :times_played => 2)
  	end
  	# destroy
  	teardown do
  		@doc.destroy
  		@kearney.destroy
  		@miller.destroy
  	end

  	should "show that factories are working as expected " do
  		assert @doc.wins == 0
  		assert_equal @kearney.name, "Brian Kearney"
  		assert_equal 4, @miller.wins
  		assert_equal 3, Competitor.all.size
  	end

  	should "have a callback that sets the default elo to 1200 on create" do
  		assert_equal 1200, @doc.elo
  		assert_equal 1200, @kearney.elo
  		assert_equal 1200, @miller.elo
  	end

  	should "not allow competitors without unique names to be created " do
  		docAgain = FactoryGirl.build(:competitor)
  		kearneyAgain = FactoryGirl.build(:competitor, :name => "Brian Kearney")
  		docAgain.destroy
  		kearneyAgain.destroy
  		deny docAgain.valid?
  		deny kearneyAgain.valid?
  	end

  	should "have a scope returning competitors in decending order by their elo" do
  		@doc.update_attribute(:elo, 1800.0)
  		@kearney.update_attribute(:elo, 1000.0)
  		@miller.update_attribute(:elo, 1300.0)
  		@doc.save!
  		@kearney.save!
  		@miller.save!
  		assert_equal [@doc.name, @miller.name, @kearney.name], Competitor.by_elo.map { |c| c.name }
  	end

  	should "have a scope to return competitors in decending order by their wins " do
  		assert_equal [@miller.name, @kearney.name, @doc.name], Competitor.by_wins.map { |c| c.name }
  	end

  	should "have a scope to return competitors in decending order by their times played" do
  		assert_equal [@miller.name, @kearney.name, @doc.name], Competitor.by_times_played.map { |c| c.name }
  	end

  	should "have a scope to return competitors in alphabetical order" do
  		assert_equal [@kearney.name, @miller.name, @doc.name], Competitor.alphabetical.map { |c| c.name }
  	end

  	should "have a scope for basic search" do
  		assert_equal [@kearney.name], Competitor.search("Kearney").map { |c| c.name }
	  end

	  should "have a scope that returns two random records" do
	  	assert_equal 2, Competitor.random.size
		end

		should "show a competitor with a higher elo will have a higher expected win rate, equal will be equal" do
			@doc.update_attribute(:elo, 1500)
			@doc.save!
			assert @doc.exp_rate(@kearney.elo) > @kearney.exp_rate(@doc.elo)
			assert_equal @kearney.exp_rate(@miller.elo), @miller.exp_rate(@kearney.elo)
		end

		should "have an elo lower after a loss, raise after a win" do
			@doc.update_elo(@kearney)
			assert @doc.elo > @kearney.elo
		end
  end
end
