class FoundDog < Event
  has_one :delegate, class_name: "FoundDogDelegate", inverse_of: :found_dog, dependent: :destroy, autosave: true

  # Get me all of the these methods from the FoundDogDelegate class
  methods_to_delegate = [
                        :breed_id, :breed_id=,
                        :breed, :breed=,
                        :weight_id, :weight_id=,
                        :weight, :weight=,
                        :description, :description=, 
                        :colors, :colors=,
                        :color_ids, :color_ids=,
                        :found_dog_id, :found_dog_id=,
                        :found_dog, :found_dog=
  ]
  # splat operator *. It removes the surrounding array. ex: arr = [1, 2, 3]; *arr is just 1, 2, 3
  delegate *methods_to_delegate, to: :lazily_built_delegates
  
  private
  # Create the record if it doesn't exist
  def lazily_built_delegates
    delegate || build_delegate
  end
end
