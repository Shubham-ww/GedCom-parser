module HashToXml
  def self.convert(h)
    puts "<gedcom>"
    for i in 0...(h.count)
      print self.process_hash(h[i]).to_s
    end
    puts "</gedcom>"
  end

  def self.process_hash(h)
    id = h["id"] if !h["id"].nil?
    tag = h["tag"]
    value = h["data"] if (h.count > 2)
    data = h["data"] if !value.nil?
    if h.count > 2
      print "<" + h["tag"].to_s
      print " id=\"" + id.to_s if !id.nil?
      print " value=\"" + value.to_s if !value.nil?
      puts "\">"
      for var in 0...(h.count - 2)
        HashToXml.process_hash(h[var])
      end
      puts "</" + tag.to_s + ">"
    else
      print "<" + h["tag"].to_s
      print " id=" + id.to_s if !id.nil?
      puts ">"
      puts h["data"].to_s
      puts "</" + tag.to_s + ">"
    end
  end
end