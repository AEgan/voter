class Contest < ActiveRecord::Base
  attr_accessible :description, :name, :user_id, :active

  # relationships
  belongs_to :user
  has_many :competitors

  # validations
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0, :allow_blank => false
  validates_presence_of :user_id, :name
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  
  # scopes
  scope :for_user, lambda {|uid| where("user_id = ?", uid) }
  scope :alphabetical, order("name")
  scope :active, where("active = ?", true)
  scope :inactive, where("active = ?", false)




end
