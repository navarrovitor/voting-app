class Admin::BaseController < ApplicationController
  before_action :require_admin!
  wrap_parameters false

  private

  def require_admin!
    token = request.headers["Authorization"]&.sub(/^Bearer /, "")
    unless token == ENV.fetch("ADMIN_PASSWORD", "admin123")
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
