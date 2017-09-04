class WalkingPartner < Event
  has_one :delegate, class_name: "WalkingPartnerDelegate", inverse_of: :walking_partner, dependent: :destroy, autosave: true

  # Get me all of the these methods from the WalkingPartnerDelegate class
  methods_to_delegate = [
                        :description, :description=,
                        :walking_partner_id, :walking_partner_id=,
                        :walking_partner, :walking_partner=
  ]
  # splat operator *. It removes the surrounding array. ex: arr = [1, 2, 3]; *arr is just 1, 2, 3
  delegate *methods_to_delegate, to: :lazily_built_delegates
  
  private
  # Create the record if it doesn't exist
  def lazily_built_delegates
    delegate || build_delegate
  end
end
