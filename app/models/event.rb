class Event < ApplicationRecord
  # This model is an STI. Has a type field for child types
  belongs_to :pet, optional: true # this is an  optional column, lost dog owner might not know which dog it is.
  belongs_to :user
  belongs_to :chat, optional: true
  has_and_belongs_to_many :joined_users, -> { distinct }, class_name: 'User', inverse_of: :joined_events
  has_many :event_invites
  
  #{ message: "This event needs to belong to a pet." }
  validates :pet, presence: true, unless: Proc.new { |e| [FoundDog, PostEvent].include? e.class }
  validates :user, presence: true

  # scope for around me events. Events.around_me
  scope :around_me, -> { where(is_around_me: true) }
  
  after_create :add_current_user
  
  def self.around_me_events
    [LostDog, FoundDog, WalkingPartner]
  end
  
  private
  
  def add_current_user
    self.joined_users << self.user
  end
end
