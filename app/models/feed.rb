require 'open-uri'

class Feed < ActiveRecord::Base
  attr_accessible :url, :vip_id
  validates_presence_of :url
  validates_uniqueness_of :url

  def url_basename
    url.rpartition("/")[2]
  end

  def load
    feed_file = open(url)
    feed_xml = Nokogiri::XML(feed_file)

    self.version = feed_xml.xpath("//vip_object/@schemaVersion").to_s
    self.vip_id = feed_xml.xpath("//vip_id/text()").to_s
    self.loaded = true
    self.save
  end
end
