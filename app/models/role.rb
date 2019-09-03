class Role < ApplicationRecord
  has_and_belongs_to_many :admin_users, :join_table => :admin_users_roles


  belongs_to :resource,
             :polymorphic => true,
             :optional => true


  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  # Все права от Instance, т.е. права раздаются на Instance и действуют на всё, что под ним.
  # manager - просматривать, включать ретранслятор
  # editor - просматривать, добавлять порты, добавлять mc
  ROLE_NAMES = %w( manager editor )
  validates :name, presence: true, inclusion: { in: ROLE_NAMES }

  scopify

  scope :managers_only, ->{ where(name: 'manager') }
  scope :instances_only, ->{ where(resource_type: 'Instance') }
end
