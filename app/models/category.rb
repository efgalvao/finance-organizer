class Category < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user
  
  # VALIDATIONS
  validates :name, presence: true, uniqueness: true
end
