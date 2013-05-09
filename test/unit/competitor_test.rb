require 'test_helper'

class CompetitorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Validations
  should validate_presence_of(:name)
  should validate_numericality_of(:elo)
  should validate_numericality_of(:wins)
  should validate_numericality_of(:times_played)

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

  # shouldas for name
  should allow_value("Doc").for(:name)
  should allow_value("123").for(:name)
  should_not allow_value(nil).for(:name)
end
