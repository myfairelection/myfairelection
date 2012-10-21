class VoterInfoController < ApplicationController
  def find
    address = params[:address]
    voter_info = VoterInfo.lookup(address)
    case voter_info.status
    when 'success'
      @voter_info = voter_info
    when 'noAddressParameter'
      flash[:error] = "Please enter an address."
      redirect_to root_path
    when 'addressUnparseable'
      flash[:error] = "Could not figure out your address. Please check the address you gave us."
      redirect_to root_path
    when 'noStreetSegmentFound'
      flash[:error] = "Your address was valid, but we could not find information for the address you provided."
      redirect_to root_path      
    else
      flash[:error] = "A problem happened while looking up your polling place. Please try again."
      redirect_to root_path
    end
  end
end
