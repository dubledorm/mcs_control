# encoding: UTF-8
class HomeController < ApplicationController
  before_action :authenticate_admin_user!

  def index
  end

end
