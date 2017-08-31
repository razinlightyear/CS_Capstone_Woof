class LostDog < Event
  has_one :delegate, class_name: "LostDogDelegate", inverse_of: :lost_dog, dependent: :destroy, autosave: true

  # Get me all of the these methods from the LostDogDelegate class
  methods_to_delegate = [
                        :description, :description=,
                        :lost_dog_id, :lost_dog_id=,
                        :lost_dog, :lost_dog=
  ]
  # splat operator *. It removes the surrounding array. ex: arr = [1, 2, 3]; *arr is just 1, 2, 3
  delegate *methods_to_delegate, to: :lazily_built_delegates
  
  private
  # Create the record if it doesn't exist
  def lazily_built_delegates
    delegate || build_delegate
  end
end