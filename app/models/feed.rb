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

  def load
    feed_file = open(url)
    feed_xml = Nokogiri::XML(feed_file)

    pl_nodes = feed_xml.xpath("//polling_location")

    address = {}
    properties = {}
    pl_nodes.each do |pl_node|
      pl_node.children.each do |node|
        if node.node_name == 'address'
          node.children.each do |addr_element|
            address[addr_element.node_name] = addr_element.content
          end
        else
          properties[node.node_name] = node.content
        end
      end          
      self.polling_locations.create(address: address, 
                                    properties:properties, 
                                    id_attribute:pl_node["id"])
    end   

    self.version = feed_xml.xpath("//vip_object/@schemaVersion").to_s
    self.vip_id = feed_xml.xpath("//vip_id/text()").to_s
    self.loaded = true
    self.save
  end
end
