class Api::VotesController < ApplicationController
  before_action :require_guest!

  def create
    unless Setting.voting_open?
      return render json: { error: "Voting is closed" }, status: :forbidden
    end

    category = params[:category]
    unless Guest::CATEGORIES.include?(category)
      return render json: { error: "Invalid category" }, status: :unprocessable_entity
    end

    if current_guest.voted_for?(category)
      return render json: { error: "You already voted in this category" }, status: :conflict
    end

    selections = params[:selections]
    unless selections.is_a?(Array) && selections.size == 3
      return render json: { error: "Select exactly 3 contestants" }, status: :unprocessable_entity
    end

    ranks = selections.map { |s| s[:rank].to_i }
    unless ranks.sort == [1, 2, 3]
      return render json: { error: "Must assign ranks 1, 2, and 3" }, status: :unprocessable_entity
    end

    contestant_ids = selections.map { |s| s[:contestant_id].to_i }
    if contestant_ids.uniq.size != 3
      return render json: { error: "Cannot vote for the same contestant twice" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      selections.each do |sel|
        Vote.create!(
          guest: current_guest,
          contestant_id: sel[:contestant_id].to_i,
          category: category,
          rank: sel[:rank].to_i
        )
      end
    end

    render json: { message: "Vote recorded!" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
