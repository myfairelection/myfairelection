require 'open-uri'
require 'nokogiri'

class Feed < ActiveRecord::Base
  attr_accessible :url, :vip_id
  validates_presence_of :url
  validates_uniqueness_of :url
  has_many :polling_locations

  def url_basename
    url.rpartition("/")[2]
  end

  def load_objects
    feed_file = open(url)
    feed_xml = Nokogiri::XML(feed_file)
    locations_loaded = 0

    ["//polling_location", "//early_vote_site"].each do |xpath|
      pl_nodes = feed_xml.xpath(xpath)

      pl_nodes.each do |pl_node|
        pl = PollingLocation.update_or_create_from_xml!(pl_node)
        if pl
          pl.feed = self
          pl.save!
          locations_loaded += 1
        end
      end   
    end
    
    self.version = feed_xml.xpath("//vip_object/@schemaVersion").to_s
    self.vip_id = feed_xml.xpath("//vip_id/text()").to_s
    self.loaded = true
    self.save
    puts "Loaded #{locations_loaded} polling locations"
  end

  def self.load_from_file(filename = nil)
    filename = ARGV[0] unless filename
    f = self.find_or_create_by_url(filename)
    if f.loaded?
      puts "Already loaded #{filename}, skipping"
    else
      puts "Loading #{filename}"
      f.load_objects
    end
  end

end
