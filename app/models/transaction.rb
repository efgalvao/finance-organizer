class Transaction < ApplicationRecord
  belongs_to :account

  monetize :value_cents

  before_save :set_date

  # VALIDATIONS
  validates :title, presence: true
  validates :wallet_id, presence: true
  validates :kind, presence: true

  enum kind: { expense: 0, income: 1 }

  # SCOPE

  scope :expense, -> { where(kind: 'expense') }

  scope :income, -> { where(kind: 'income') }

  def category
    if category_id.nil?
      'No Category'
    else
      Category.find(category_id).name
    end
  end

  def set_date
    unless self.date.present?
      self.date = Date.current
    end
  end
end
