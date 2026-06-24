Rails.application.config.secret_key_base ||= ENV.fetch("SECRET_KEY_BASE") {
  "dev_secret_key_base_not_for_production_#{Rails.env}"
}
