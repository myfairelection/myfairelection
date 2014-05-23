class StateMapController < ApplicationController
  def index
  end

  def states
    @states = StateMapData.all
    respond_to do |format|
      format.html { render action: 'states' }
      format.js { render json: @states.to_json }
    end
  end
end
