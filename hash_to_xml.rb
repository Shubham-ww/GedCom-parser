
require 'pry'

module HashToXml
  def self.convert(h)
    puts "<gedcom>"
    puts self.process_hash(h).to_s
    puts "</gedcom>"
  end

  def self.process_hash(h)
    # binding.pry
    # tabs = 1
    id = h["id"] if !h["id"].nil?
    tag = h["tag"]
    value = h["data"] if (h.count > 2)
    data = h["data"] if !value.nil?
    if h.count > 2
      print "<" + h["tag"].to_s
      print " id=\"" + id.to_s if !id.nil?
      print " value=\"" + value.to_s if !value.nil?
      print "\">\n"
      h.each_pair do |key, value|
        if key.class != String
          (h.count - 2).times do
            self.process_hash(h[key])
          end
        end
      end
      print "</" + tag.to_s + ">"
    else
      print "<" + h["tag"].to_s
      print " id=" + id.to_s if !id.nil?
      print ">\n"
      puts h["data"].to_s
      print "</" + tag.to_s + ">\n"
    end
  end
end