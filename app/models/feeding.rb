class Feeding < Event
  has_one :delegate, class_name: "FeedingDelegate", inverse_of: :feeding, dependent: :destroy, autosave: true

  # Get me all of the these methods from the FeedingDelegate class
  methods_to_delegate = [
                        :amount, :amount=,
                        :feeding_id, :feeding_id=,
                        :feeding, :feeding=
  ]
  # splat operator *. It removes the surrounding array. ex: arr = [1, 2, 3]; *arr is just 1, 2, 3
  delegate *methods_to_delegate, to: :lazily_built_delegates
  
  private
  # Create the record if it doesn't exist
  def lazily_built_delegates
    delegate || build_delegate
  end
end
