class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :render_500 unless Rails.env.development? #|| Rails.env.test?
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404 unless Rails.env.development? #|| Rails.env.test?
  rescue_from AbstractController::ActionNotFound, :with => :render_404 unless Rails.env.development? #|| Rails.env.test?

  # страница не найдена
  def render_404
    respond_to do |format|
      format.html { render :file => 'errors/404', :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  # ошибка приложения
  def render_500(e)
    Rails.logger.error e.inspect
    Rails.logger.error e.backtrace.join("\n") if e

#    Airbrake.notify_or_ignore(e, parameters: params, cgi_data: ENV.to_hash)
    respond_to do |format|
      format.html { render :file => 'errors/500', :layout => false, :status => 500 }
      format.xml  { head 500 }
      format.any  { head 500 }
    end
  end

  def access_denied(exception)
    respond_to do |format|
      format.html { render :file => 'errors/403', :layout => false, :status => 403 }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
