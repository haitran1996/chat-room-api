class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.permitted_attributes
    self.new.attributes.keys.map(&:to_sym) - %i[id created_at updated_at]
  end
end
