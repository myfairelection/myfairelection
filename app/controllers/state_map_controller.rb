class StateMapController < ApplicationController
  def index
  end

  def states
    @states = StateMapData.all
  end
end
