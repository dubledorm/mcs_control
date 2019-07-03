# encoding: UTF-8
module DualStorage
  extend ActiveSupport::Concern

  DB_STATUS_VALUES = %w(undefined everywhere_exists only_here_exists only_there_exists).freeze

  included do
    validates :db_status, inclusion: { in: DB_STATUS_VALUES }, allow_nil: true
  end
end
