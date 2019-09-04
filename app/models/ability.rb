# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :show, :update, :destroy, :to => :crud

    if user.admin
      can :manage, :all
      return
    end

    can [ :edit, :update ], Instance, id: user.instances.where(roles: { name: :editor }).map(&:id)

    can [ :read ], Program, id: user.programs.where(roles: { name: :editor }).map(&:id)

    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
    can :read, :all

    cannot :crud, AdminUser
    cannot :crud, Role
  end
end
