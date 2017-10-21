class Nudge < ApplicationRecord
	# before_create :generate_token
  	belongs_to :user
  	belongs_to :group
  	belongs_to :pet

  	def generate_token
    	self.nudge_token = loop do
      		random_token = SecureRandom.urlsafe_base64(nil, false)
      		break random_token unless Nudge.exists?(nudge_token: random_token)
    	end
  	end

end
