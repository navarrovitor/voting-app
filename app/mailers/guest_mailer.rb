class GuestMailer < ApplicationMailer
  def magic_link(guest, token)
    @guest = guest
    @url = "#{root_url}?token=#{token}"
    mail(to: guest.email, subject: "Your party voting link!")
  end

  private

  def root_url
    host = Rails.application.config.action_mailer.default_url_options[:host]
    protocol = Rails.application.config.action_mailer.default_url_options[:protocol] || "http"
    "#{protocol}://#{host}/"
  end
end
