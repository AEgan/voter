class Contest < ActiveRecord::Base
  attr_accessible :description, :name, :user_id, :active

  # relationships
  belongs_to :user
  has_many :competitors

  # validations
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0, :allow_blank => false
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :user_id, :name
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  validate :user_active_in_system, :on => :create
  
  # scopes
  scope :for_user, lambda {|uid| where("user_id = ?", uid) }
  scope :alphabetical, order("name")
  scope :active, where("active = ?", true)
  scope :inactive, where("active = ?", false)
  scope :random, order("RANDOM()").limit(1)
  scope :search, lambda {|term| where("name like ? or description like ?", "%#{term}%", "%#{term}%")}

  private
  #custom validation
  def user_active_in_system
    return true if self.user_id.nil?
    unless User.active.map { |u| u.id }.include?(self.user_id)
      errors.add(:user, "is not active in the system")
    end
  end

end
