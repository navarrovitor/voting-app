class Api::ResultsController < ApplicationController
  def index
    unless Setting.voting_open? == false && Setting.get("results_public") == "true"
      return render json: { error: "Results not available yet" }, status: :forbidden
    end

    render json: { results: compute_results }
  end

  private

  def compute_results
    Guest::CATEGORIES.each_with_object({}) do |category, hash|
      hash[category] = category_results(category)
    end
  end

  def category_results(category)
    votes = Vote.where(category: category).includes(:contestant)
    scores = Hash.new(0)
    votes.each { |v| scores[v.contestant_id] += Vote::POINTS[v.rank] }
    scores.sort_by { |_, pts| -pts }.map do |contestant_id, points|
      contestant = Contestant.find(contestant_id)
      { id: contestant.id, name: contestant.name, points: points }
    end
  end
end
