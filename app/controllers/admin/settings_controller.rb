class Admin::SettingsController < Admin::BaseController
  def show
    render json: {
      voting_open: Setting.voting_open?,
      results_public: Setting.get("results_public") == "true"
    }
  end

  def update
    Setting.set("voting_open", params[:voting_open].to_s) if params.key?(:voting_open)
    Setting.set("results_public", params[:results_public].to_s) if params.key?(:results_public)
    render json: { message: "Settings updated" }
  end
end
