class Api::ContestantsController < ApplicationController
  def categories
    render json: {
      voting_open: Setting.voting_open?,
      categories: {
        singing: Contestant.for_singing.map { |c| { id: c.id, name: c.name } },
        costume: Contestant.for_costume.map { |c| { id: c.id, name: c.name } }
      }
    }
  end
end
