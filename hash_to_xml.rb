module HashToXml
  $xmlFile = File.new("output.xml", "w+")
  def self.convert(h)
    $xmlFile.syswrite("<gedcom>\n")
    for i in 0...(h.count)
      print self.process_hash(h[i]).to_s
    end
    $xmlFile.syswrite("</gedcom>")
  end

  def self.process_hash(h)
    id = h["id"] if !h["id"].nil?
    tag = h["tag"]
    value = h["data"] if (h.count > 2)
    data = h["data"] if !value.nil?
    if h.count > 2
      $xmlFile.syswrite("<" + h["tag"].to_s)
      $xmlFile.syswrite(" id=\"" + id.to_s + "\"") if !id.nil?
      $xmlFile.syswrite(" value=\"" + value.to_s + "\"") if !value.nil?
      $xmlFile.syswrite(">\n")
      for var in 0...(h.count - 2)
        HashToXml.process_hash(h[var])
      end
      $xmlFile.syswrite("</" + tag.to_s + ">\n")
    else
      $xmlFile.syswrite("<" + h["tag"].to_s)
      $xmlFile.syswrite(" id=\"" + id.to_s + "\"") if !id.nil?
      $xmlFile.syswrite(">\n")
      $xmlFile.syswrite(h["data"].to_s + "\n")
      $xmlFile.syswrite("</" + tag.to_s + ">\n")
    end
  end
end