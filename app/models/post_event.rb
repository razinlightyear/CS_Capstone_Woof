class PostEvent < Event
  has_one :delegate, class_name: "PostEventDelegate", inverse_of: :post_event, dependent: :destroy, autosave: true

  after_create :add_current_user

  # Get me all of the these methods from the LostDogDelegate class
  methods_to_delegate = [
                        :description, :description=,
                        :date_time, :date_time=,
                        :private, :private=,
                        :post_event_id, :post_event_id=,
                        :post_event, :post_event=
  ]
  # splat operator *. It removes the surrounding array. ex: arr = [1, 2, 3]; *arr is just 1, 2, 3
  delegate *methods_to_delegate, to: :lazily_built_delegates
  
  private
  # Create the record if it doesn't exist
  def lazily_built_delegates
    delegate || build_delegate
  end
  
  def add_current_user
    self.joined_users << self.user
  end
end
