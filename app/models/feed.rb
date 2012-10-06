require 'uri'

class Feed < ActiveRecord::Base
  attr_accessible :url, :vip_id
  validates_presence_of :url

  def url_basename
    URI(url).path.rpartition("/")[2]
  end
end
