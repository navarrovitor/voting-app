class Admin::ResultsController < Admin::BaseController
  def index
    results = Guest::CATEGORIES.each_with_object({}) do |category, hash|
      votes = Vote.where(category: category).includes(:contestant)
      scores = Hash.new(0)
      vote_counts = Hash.new(0)
      votes.each do |v|
        scores[v.contestant_id] += Vote::POINTS[v.rank]
        vote_counts[v.contestant_id] += 1
      end
      hash[category] = scores.sort_by { |_, pts| -pts }.map do |cid, points|
        c = Contestant.find(cid)
        { id: c.id, name: c.name, points: points, votes: vote_counts[cid] }
      end
    end

    total_voters = Guest.where.not(session_token: nil).count
    render json: {
      results: results,
      total_voters: total_voters,
      voting_open: Setting.voting_open?,
      results_public: Setting.get("results_public") == "true"
    }
  end
end
