class Admin::ContestantsController < Admin::BaseController
  def index
    render json: Contestant.ordered.map { |c|
      { id: c.id, name: c.name, singing_enabled: c.singing_enabled, costume_enabled: c.costume_enabled, position: c.position }
    }
  end

  def create
    contestant = Contestant.new(contestant_params)
    if contestant.save
      render json: contestant, status: :created
    else
      render json: { errors: contestant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    contestant = Contestant.find(params[:id])
    if contestant.update(contestant_params)
      render json: contestant
    else
      render json: { errors: contestant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Contestant.find(params[:id]).destroy
    head :no_content
  end

  private

  def contestant_params
    params.permit(:name, :singing_enabled, :costume_enabled, :position)
  end
end
