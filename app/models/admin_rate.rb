class AdminRate < ApplicationRecord
  belongs_to :dollar_rate
  accepts_nested_attributes_for :dollar_rate
end
