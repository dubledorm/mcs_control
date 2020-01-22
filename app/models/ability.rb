# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :show, :update, :destroy, to: :crud

    if user.admin
      can :manage, :all
      return
    end

    can [ :read, :edit, :update ], Instance, id: user.instances.where(roles: { name: :editor }).map(&:id)
    can [ :read ], Instance, id: user.instances.where(roles: { name: [:manager, :programmer] }).map(&:id)

    can [ :read, :edit, :update ], InstanceDecorator, id: user.instances.where(roles: { name: :editor }).map(&:id)
    can [ :read ], InstanceDecorator, id: user.instances.where(roles: { name: [:manager, :programmer] }).map(&:id)

    can [ :read ], Program, id: user.programs.where(roles: { name: [:editor, :manager, :programmer] }).map(&:id)
    can [ :database_backup ], Program, id: user.programs.where(roles: { name: :programmer }).map(&:id)

    can [ :read ], ProgramDecorator, id: user.programs.where(roles: { name: [:editor, :manager, :programmer] }).map(&:id)
    can [ :database_backup ], ProgramDecorator, id: user.programs.where(roles: { name: :programmer }).map(&:id)

    can [ :read ], StoredFile, id: user.stored_files.map(&:id)

    can [:retranslator_on, :retranslator_off, :read ], Port, id: user.ports.where(roles: {name: :editor }).map(&:id)
    can [:retranslator_on, :retranslator_off, :read ], Port, id: user.ports.where(roles: {name: :manager }).map(&:id)

    can [:retranslator_on, :retranslator_off, :read ], PortDecorator, id: user.ports.where(roles: {name: :editor }).map(&:id)
    can [:retranslator_on, :retranslator_off, :read ], PortDecorator, id: user.ports.where(roles: {name: :manager }).map(&:id)

    can [ :read, :show ], Retranslator if user.roles.map(&:name).include?('manager')

    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    can :read, ActiveAdmin::Page, name: "ListPort", namespace_name: "admin"
  end
end
