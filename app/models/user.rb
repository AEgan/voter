class User < ActiveRecord::Base
	# make sure password is secure
	has_secure_password
	# add password and confirmation to attr_accessible, get rid of password_digest
  attr_accessible :active, :email, :first_name, :last_name, :password, :password_confirmation, :role

  # relationships
  has_many :contests
  has_many :competitors, :through => :contests

  # validations
  validates_presence_of :email, :last_name, :first_name
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  validates_inclusion_of :role, :in => %w[admin member], :message => "is not recognized by the system"


  # scopes
  scope :alphabetical, order("last_name, first_name")
  scope :active, where("active = ?", true)
  scope :inactive, where("active = ?", false)
  scope :admins, where("role = ?", "admin")
  scope :members, where("role = ?", "member")
  scope :search, lambda {|term| where("email like ? or first_name like ? or last_name like ?", "%#{term}%", "%#{term}%", "%#{term}%")}

  ROLES = [['Administrator', :admin],['Member', :member]]

  # login by email address
  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end

  def admin?
  	role == 'admin'
  end

  def member?
  	role == 'member'
  end

  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end
end
