class Competitor < ActiveRecord::Base
	# a name is used instead of a first and last name because what if someone wants to compare things
	# and not people?
  attr_accessible :description, :elo, :name, :times_played, :wins, :photo, :contest_id

  # relationships
  belongs_to :contest

  # uploaded for photos
  mount_uploader :photo, PhotoUploader

  # simple validations
  validates_presence_of :name, :contest_id
  validates_uniqueness_of :name, :case_sensitive => false
  validates_numericality_of :wins, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => false
  validates_numericality_of :times_played, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => false
  validates_numericality_of :elo, :only_integer => false, :greater_than_or_equal_to => 0, :allow_blank => false
  validates_numericality_of :contest_id, :only_integer => true, :greater_than_or_equal_to => 1, :allow_blank => false

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
  scope :for_contest, lambda {|cid| where("contest_id = ?", cid) }

  # the odds of winning according to Elo's mind
  def exp_rate(otherElo)
  	1.0/(1+10**((otherElo - self.elo)/400.0))
  end

  # for now the K value (as it was described to me) will be set to 20. 
  # This will obviously become a function of times_played as I move in in the
  # development process
  # this was updated so that it is only called on the winner, passing in the losing
  # competitor 
  def update_elo(losingCompetitor)
    # get offset based on (right now) a static K value of 20
  	selfoffset = 20 * (2 - exp_rate(losingCompetitor.elo))
  	otheroffset = 20 * (2 - exp_rate(self.elo))
    # update the number of times played 
  	self.times_played = self.times_played + 1
  	losingCompetitor.times_played = losingCompetitor.times_played + 1
    # update win
		self.wins = self.wins + 1
    #update elo
		self.elo = self.elo + selfoffset
		losingCompetitor.elo = losingCompetitor.elo - otheroffset
    #save!
  	self.save!
  	losingCompetitor.save!
  end


  private
  # make sure the elo is set off the start
  def set_base_elo
  	self.elo = 1200
  end
end
