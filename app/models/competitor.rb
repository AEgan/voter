class Competitor < ActiveRecord::Base
	# a name is used instead of a first and last name because what if someone wants to compare things
	# and not people?
  attr_accessible :description, :elo, :name, :times_played, :wins

  # simple validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_numericality_of :wins, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => false
  validates_numericality_of :times_played, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => false
  validates_numericality_of :elo, :only_integer => false, :greater_than_or_equal_to => 0, :allow_blank => false

  # callback so the elo is set appropriately when the competitor is created. Also makes it simple
  # to change if I want it change if I get a better understanding of the algo and want it changed
  # or you want it changed. open source and such
  after_create :set_base_elo

  # scopes. Easy way to order everything for leaderboards and a simple search scope
  scope :by_elo, order("elo DESC")
  scope :alphabetical, order("name")
  scope :search, lambda {|term| where("name LIKE ? OR description LIKE ?", "%#{term}%", "%#{term}%")}
  scope :by_wins, order("wins DESC")
  scope :by_times_played, order("times_played DESC")
  scope :random, order("RANDOM()").limit(2)

  # the odds of winning according to Elo's mind
  def exp_rate(otherElo)
  	1.0/(1+10**((otherElo - self.elo)/400.0))
  end

  # for now the K value (as it was described to me) will be set to 20. 
  # This will obviously become a function of times_played as I move in in the
  # development process
  def update_elo(otherCompetitor, win)
  	selfoffset = 20 * (2 - exp_rate(otherCompetitor.elo))
  	otheroffset = 20 * (2 - exp_rate(self.elo))
  	if(win)
  		self.elo = self.elo + selfoffset
  		otherCompetitor.elo = otherCompetitor.elo - otheroffset
  	else
  		self.elo = self.elo - selfoffset
  		otherCompetitor.elo = otherCompetitor.elo + otheroffset
  	end
  	self.save!
  	otherCompetitor.save!
  end


  private
  # make sure the elo is set off the start
  def set_base_elo
  	self.elo = 1200
  end
end
