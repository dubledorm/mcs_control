class Instance < ApplicationRecord

  validates :name, :presence=>true, :uniqueness => true, format: { with: /\A[a-zA-z_\d]+\z/}
end
