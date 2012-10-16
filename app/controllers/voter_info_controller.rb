class VoterInfoController < ApplicationController
  def find
    address = params[:address]
    voter_info = VoterInfo.lookup(address)
    if voter_info.status == 'noAddressParameter'
      flash[:error] = "Please enter an address."
      redirect_to root_path
    else
      @voter_info = voter_info
    end
  end
end
