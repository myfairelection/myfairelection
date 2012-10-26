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
      feed_xml = Nokogiri::XML::Reader(feed_file)

      vip_id = ""
      in_vip_id = false
      locations_loaded = 0

      while feed_xml.read != nil
        case feed_xml.node_type
        when Nokogiri::XML::Reader::TYPE_ELEMENT
          next if feed_xml.self_closing?
          case feed_xml.name
          when "polling_location", "early_vote_site"
            pl = PollingLocation.update_or_create_from_xml!(feed_xml)
            if pl
              pl.feed = self
              pl.save!
              locations_loaded += 1
            end
          when "vip_object"
            version = feed_xml.attribute("schemaVersion")
          when "vip_id"
            in_vip_id = true
          else
            # do nothing
          end
        when Nokogiri::XML::Reader::TYPE_TEXT
          vip_id << feed_xml.value if in_vip_id
        when Nokogiri::XML::Reader::TYPE_END_ELEMENT
          in_vip_id = false if feed_xml.name == "vip_id"
        else
          #do nothing
        end
      end
    
    self.version = version
    self.vip_id = vip_id
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
