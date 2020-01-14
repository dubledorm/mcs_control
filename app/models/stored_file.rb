class StoredFile < ApplicationRecord
  STORED_FILE_STATES = %w(creating exists deleted fail).freeze
  STORED_FILE_CONTENT_TYPE = %w(backup log).freeze

  belongs_to :program
  belongs_to :admin_user


  validates :filename, :state, :content_type, presence: true
  validates :state, inclusion: { in: STORED_FILE_STATES }
  validates :content_type, inclusion: { in: STORED_FILE_CONTENT_TYPE }

  has_one_attached :file
end
