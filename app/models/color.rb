class Color < ApplicationRecord
  has_and_belongs_to_many :pets, -> { distinct }, inverse_of: :colors
  #has_and_belongs_to_many :lost_dogs
    
  validates :name, presence: { message: "Please enter a color name" }
    
  scope :contains, -> (name) {where("name LIKE ?", "%#{name}%")}
  
  def color_badge
    html = <<-html_str
    <span class="badge badge-default badge-#{self.name}" style="margin: 3px">#{self.name}</span>
    html_str
    html
  end
end
