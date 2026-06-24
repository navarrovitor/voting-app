class Admin::SessionsController < ApplicationController
  def create
    password = params[:password]
    if password == ENV.fetch("ADMIN_PASSWORD", "admin123")
      render json: { token: ENV.fetch("ADMIN_PASSWORD", "admin123") }
    else
      render json: { error: "Invalid password" }, status: :unauthorized
    end
  end
end
