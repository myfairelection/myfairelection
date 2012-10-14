class VoterInfoController < ApplicationController
  def find
    address = params[:address]
    @voter_info = VoterInfo.lookup(address)
  end
end
